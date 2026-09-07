import '../models/career.dart';

const List<Career> careerData = [
  Career(
    id: 'software_engineer',
    title: 'Software Engineer',
    category: 'Technology',
    shortDescription: 'Builds apps, websites, games, and software tools.',
    longDescription:
        'A software engineer uses coding and problem solving to build apps, websites, games, and tools that people use every day.',
    schoolSubjects: ['Math', 'Computer Science', 'English'],
    skills: [
      'Coding',
      'Problem Solving',
      'Debugging',
      'Teamwork',
      'Communication',
    ],
    starterProject: 'Build a simple quiz app or calculator app.',
    interestTags: ['I', 'R', 'C'],
    aiRiskLevel: 'Medium',
    futureProofScore: 82,
    aiImpactSummary:
        'AI can help write simple code, but humans are still needed to understand problems, design systems, test apps, and make decisions.',
    alternativeCareer: 'AI Solutions Engineer',
    alternativeReason:
        'An AI Solutions Engineer uses coding and AI tools to solve real-world problems, which may be more future-ready as AI grows.',
  ),

  Career(
    id: 'cybersecurity_analyst',
    title: 'Cybersecurity Analyst',
    category: 'Technology',
    shortDescription: 'Protects computers, networks, and data from hackers.',
    longDescription:
        'A cybersecurity analyst helps protect websites, apps, computer systems, and private information from cyber attacks.',
    schoolSubjects: ['Computer Science', 'Math', 'Technology'],
    skills: [
      'Problem Solving',
      'Attention to Detail',
      'Networking Basics',
      'Security Thinking',
      'Communication',
    ],
    starterProject: 'Build a password strength checker.',
    interestTags: ['I', 'C', 'R'],
    aiRiskLevel: 'Medium',
    futureProofScore: 88,
    aiImpactSummary:
        'AI can help detect security threats faster, but humans are still needed to investigate attacks and protect systems.',
    alternativeCareer: 'AI Security Analyst',
    alternativeReason:
        'An AI Security Analyst uses AI tools to find and stop cyber threats, which makes this path more future-ready.',
  ),

  Career(
    id: 'ux_designer',
    title: 'UX Designer',
    category: 'Art & Design',
    shortDescription:
        'Designs apps and websites so they are easy and enjoyable to use.',
    longDescription:
        'A UX designer studies how people use apps and websites, then designs better screens, buttons, and flows so users have a better experience.',
    schoolSubjects: ['Art', 'Computer Science', 'English', 'Psychology'],
    skills: [
      'Creativity',
      'User Research',
      'Design Thinking',
      'Communication',
      'Problem Solving',
    ],
    starterProject: 'Redesign the homepage of a school app or website.',
    interestTags: ['A', 'I', 'S'],
    aiRiskLevel: 'Medium',
    futureProofScore: 80,
    aiImpactSummary:
        'AI can create quick design ideas, but humans are still needed to understand users, test designs, and solve real problems.',
    alternativeCareer: 'Product Designer',
    alternativeReason:
        'A Product Designer combines design, user research, and business thinking, making the role broader and more future-ready.',
  ),

  Career(
    id: 'data_analyst',
    title: 'Data Analyst',
    category: 'Technology',
    shortDescription:
        'Uses data to find patterns and help people make decisions.',
    longDescription:
        'A data analyst looks at information, finds patterns, creates charts, and explains what the data means so teams can make better decisions.',
    schoolSubjects: ['Math', 'Computer Science', 'Statistics', 'English'],
    skills: [
      'Spreadsheets',
      'Charts',
      'Pattern Finding',
      'Critical Thinking',
      'Communication',
    ],
    starterProject:
        'Analyze your weekly screen time or study time and create charts.',
    interestTags: ['I', 'C'],
    aiRiskLevel: 'Medium-High',
    futureProofScore: 72,
    aiImpactSummary:
        'AI can create reports and charts quickly, so data analysts will need stronger problem-solving and storytelling skills.',
    alternativeCareer: 'AI Data Specialist',
    alternativeReason:
        'An AI Data Specialist understands data and AI tools, which can make the career more future-ready.',
  ),

  Career(
    id: 'robotics_engineer',
    title: 'Robotics Engineer',
    category: 'Engineering',
    shortDescription:
        'Builds and programs robots that can perform useful tasks.',
    longDescription:
        'A robotics engineer designs, builds, tests, and improves robots used in factories, hospitals, schools, space, and homes.',
    schoolSubjects: ['Math', 'Science', 'Computer Science', 'Engineering'],
    skills: [
      'Building',
      'Coding',
      'Problem Solving',
      'Mechanical Thinking',
      'Teamwork',
    ],
    starterProject: 'Build a simple robot using a beginner robotics kit.',
    interestTags: ['R', 'I'],
    aiRiskLevel: 'Low-Medium',
    futureProofScore: 90,
    aiImpactSummary:
        'AI will make robots smarter, but humans are needed to design, build, repair, and improve robotic systems.',
    alternativeCareer: 'AI Robotics Technician',
    alternativeReason:
        'An AI Robotics Technician works hands-on with robots and AI systems, making it a strong future-ready path.',
  ),

  Career(
    id: 'teacher',
    title: 'Teacher',
    category: 'Education',
    shortDescription:
        'Helps students learn new skills and understand new ideas.',
    longDescription:
        'A teacher explains lessons, supports students, creates activities, and helps young people grow academically and personally.',
    schoolSubjects: ['English', 'Math', 'Science', 'History'],
    skills: [
      'Communication',
      'Patience',
      'Leadership',
      'Creativity',
      'Helping Others',
    ],
    starterProject: 'Create a mini lesson and teach it to a younger student.',
    interestTags: ['S', 'A', 'E'],
    aiRiskLevel: 'Low-Medium',
    futureProofScore: 84,
    aiImpactSummary:
        'AI can help teachers create lessons and practice questions, but students still need human support, encouragement, and guidance.',
    alternativeCareer: 'AI Learning Designer',
    alternativeReason:
        'An AI Learning Designer creates lessons and learning tools using technology and AI.',
  ),

  Career(
    id: 'environmental_scientist',
    title: 'Environmental Scientist',
    category: 'Environment',
    shortDescription:
        'Studies the environment and helps solve problems like pollution and climate change.',
    longDescription:
        'An environmental scientist studies air, water, land, plants, and animals to help protect nature and solve environmental problems.',
    schoolSubjects: ['Science', 'Biology', 'Math', 'Geography'],
    skills: [
      'Observation',
      'Research',
      'Data Collection',
      'Problem Solving',
      'Communication',
    ],
    starterProject:
        'Track recycling, water use, or local litter for one week and make a report.',
    interestTags: ['I', 'R', 'S'],
    aiRiskLevel: 'Low-Medium',
    futureProofScore: 86,
    aiImpactSummary:
        'AI can help analyze environmental data, but humans are needed for field work, decision-making, and community action.',
    alternativeCareer: 'Climate Data Analyst',
    alternativeReason:
        'A Climate Data Analyst combines environmental science and data skills to solve climate-related problems.',
  ),

  Career(
    id: 'entrepreneur',
    title: 'Entrepreneur',
    category: 'Business',
    shortDescription:
        'Starts a business or creates a product or service people need.',
    longDescription:
        'An entrepreneur finds a problem, creates a solution, builds a team, and tries to turn an idea into a business.',
    schoolSubjects: ['Math', 'Business', 'English', 'Technology'],
    skills: [
      'Leadership',
      'Creativity',
      'Communication',
      'Problem Solving',
      'Planning',
    ],
    starterProject:
        'Create a simple business idea and make a one-page business plan.',
    interestTags: ['E', 'S', 'C'],
    aiRiskLevel: 'Low-Medium',
    futureProofScore: 83,
    aiImpactSummary:
        'AI can help with ideas, writing, research, and marketing, but humans still decide what problems to solve and how to lead.',
    alternativeCareer: 'AI Product Manager',
    alternativeReason:
        'An AI Product Manager helps build useful AI-powered products by combining business, technology, and user understanding.',
  ),
];
