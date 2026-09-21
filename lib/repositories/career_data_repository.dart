import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/career_dataset.dart';

/// Top-level callback: decoding, model construction and validation run in compute.
CareerDataset decodeCareerDataset(String source) {
  final dataset = CareerDataset.fromJson(
    (jsonDecode(source) as Map).cast<String, dynamic>(),
  );
  final errors = dataset.validate();
  assert(errors.isEmpty, errors.join('\n'));
  if (errors.isNotEmpty) throw FormatException(errors.join('\n'));
  return dataset;
}

class CareerDataRepository {
  static const assetPath = 'assets/career_dataset.json';
  static final instance = CareerDataRepository._(rootBundle);
  final AssetBundle _bundle;
  final Future<CareerDataset> Function(String) _decode;
  CareerDataset? _dataset;
  Future<void>? _loading;

  CareerDataRepository._(this._bundle) : _decode = _computeDataset;
  @visibleForTesting
  factory CareerDataRepository.forTesting({
    required AssetBundle bundle,
    Future<CareerDataset> Function(String)? decode,
  }) => CareerDataRepository._withDecoder(bundle, decode ?? _computeDataset);

  CareerDataRepository._withDecoder(this._bundle, this._decode);

  static Future<CareerDataset> _computeDataset(String source) =>
      compute(decodeCareerDataset, source);
  CareerDataset? get dataset => _dataset;

  Future<void> ensureLoaded() {
    if (_dataset != null) return Future.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    try {
      final source = await _bundle.loadString(assetPath);
      _dataset = await _decode(source);
    } catch (error) {
      // A failed load may be retried; never substitute stale sample careers.
      _loading = null;
      if (kDebugMode) debugPrint('Career dataset load failed: $error');
      rethrow;
    }
  }

  HollandCodeEntry? codeFor(String code) => _dataset?.hollandCodes[code];
  CareerRecord? careerById(String id) => _dataset?.careers[id];
  List<CareerRecord> careersFor(String code) => List.unmodifiable([
    for (final id in codeFor(code)?.careerIds ?? const <String>[])
      ?careerById(id),
  ]);
}
