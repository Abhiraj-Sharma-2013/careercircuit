import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/repositories/career_data_repository.dart';

class CountingBundle extends CachingAssetBundle {
  final String source;
  int loads = 0;
  bool fail = false;
  CountingBundle(this.source);
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loads++;
    if (fail) throw StateError('Test bundle unavailable');
    return source;
  }

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late String source;
  setUpAll(() async {
    source = await rootBundle.loadString(CareerDataRepository.assetPath);
  });

  test(
    'real asset has 120 complete codes, 210 careers and ordered learning lists',
    () async {
      final repository = CareerDataRepository.instance;
      await repository.ensureLoaded();
      final dataset = repository.dataset!;
      expect(dataset.hollandCodes.length, 120);
      expect(dataset.careers.length, 210);
      expect(dataset.validate(), isEmpty);
      for (final entry in dataset.hollandCodes.values) {
        expect(entry.careerIds.length, 3);
        expect(
          repository.careersFor(entry.hollandCode).map((c) => c.id),
          entry.careerIds,
        );
        for (final id in entry.careerIds) {
          expect(repository.careerById(id), isNotNull);
        }
      }
      for (final career in dataset.careers.values) {
        expect(career.topicsToExplore.length, 3);
        expect(career.skillsToLearn.length, 3);
      }
      expect(repository.codeFor('XXX'), isNull);
      expect(repository.careersFor('XXX'), isEmpty);
      expect(() => dataset.careers.clear(), throwsUnsupportedError);
      expect(
        () => dataset.careers.values.first.topicsToExplore.clear(),
        throwsUnsupportedError,
      );
      expect(
        () => dataset.careers.values.first.riasec.clear(),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'concurrent requests load and decode once; successful cache never reloads',
    () async {
      final bundle = CountingBundle(source);
      var decodes = 0;
      final repository = CareerDataRepository.forTesting(
        bundle: bundle,
        decode: (text) async {
          decodes++;
          return decodeCareerDataset(text);
        },
      );
      await Future.wait(List.generate(8, (_) => repository.ensureLoaded()));
      await repository.ensureLoaded();
      expect(bundle.loads, 1);
      expect(decodes, 1);
    },
  );

  test('failed loads do not expose partial data and can retry', () async {
    final bundle = CountingBundle(source)..fail = true;
    final repository = CareerDataRepository.forTesting(bundle: bundle);
    await expectLater(repository.ensureLoaded(), throwsStateError);
    expect(repository.dataset, isNull);
    expect(repository.careersFor('RIA'), isEmpty);
    bundle.fail = false;
    await repository.ensureLoaded();
    expect(bundle.loads, 2);
    expect(repository.careersFor('RIA').length, 3);
  });

  test(
    'invalid code counts, references, and learning counts fail validation',
    () {
      for (var fault = 0; fault < 3; fault++) {
        final json = jsonDecode(source) as Map<String, dynamic>;
        if (fault == 0) {
          (json['hollandCodes'] as Map).remove('RIA');
        }
        if (fault == 1) {
          json['hollandCodes']['RIA']['careerIds'][0] = 'missing';
        }
        if (fault == 2) {
          (json['careers'].values.first['topicsToExplore'] as List)
              .removeLast();
        }
        expect(
          () => decodeCareerDataset(jsonEncode(json)),
          throwsA(isA<AssertionError>()),
        );
      }
    },
  );
}
