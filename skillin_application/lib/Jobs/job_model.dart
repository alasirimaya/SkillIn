class JobModel {
  final int id;
  final String title;
  final String company;
  final String location;
  final String category;
  final String type;
  final String position;
  final String salary;
  final String timeAgo;
  final String logo;
  final String description;
  final String skills;

  final String educationRequirement;
  final String experienceRequirement;
  final String languages;

  final double similarity;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.category,
    required this.type,
    required this.position,
    required this.salary,
    required this.timeAgo,
    required this.logo,
    required this.description,
    required this.skills,
    required this.educationRequirement,
    required this.experienceRequirement,
    required this.languages,
    required this.similarity,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final descriptionText = (json['description'] ?? '').toString();

    String extractFromDescription(String label) {
      final regex = RegExp(
        '$label\\s*:\\s*(.*)',
        caseSensitive: false,
        multiLine: true,
      );

      final match = regex.firstMatch(descriptionText);
      return match != null ? (match.group(1) ?? '').trim() : '';
    }

    double parseSimilarity(dynamic value) {
      if (value == null) return 0.0;

      double similarityValue = 0.0;

      if (value is int) {
        similarityValue = value.toDouble();
      } else if (value is double) {
        similarityValue = value;
      } else {
        similarityValue = double.tryParse(value.toString()) ?? 0.0;
      }

      // Backend returns 0.54, 0.87, etc.
      // UI needs 54, 87, etc.
      if (similarityValue <= 1) {
        similarityValue = similarityValue * 100;
      }

      return similarityValue;
    }

    final extractedLocation = extractFromDescription('Location');
    final extractedType = extractFromDescription('Employment Type');
    final extractedWorkplace = extractFromDescription('Workplace');
    final extractedEducation =
        extractFromDescription('Education Requirement');
    final extractedExperience =
        extractFromDescription('Experience Requirement');
    final extractedLanguages =
        extractFromDescription('Preferred Languages');

    return JobModel(
      id: json['job_id'] ?? json['id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      company: (json['company'] ?? '').toString(),
      location: (json['location'] ?? extractedLocation).toString(),
      category: (json['category'] ?? json['workplace'] ?? extractedWorkplace)
          .toString(),
      type: (json['type'] ?? json['employment_type'] ?? extractedType)
          .toString(),
      position: (json['position'] ?? '').toString(),
      salary: (json['salary'] ?? '').toString(),
      timeAgo: (json['timeAgo'] ?? json['time_ago'] ?? '1 day ago').toString(),
      logo: (json['logo'] ?? '').toString(),
      description: descriptionText,
      skills: (json['skills'] ?? '').toString(),
      educationRequirement:
          (json['education_requirement'] ?? extractedEducation).toString(),
      experienceRequirement:
          (json['experience_requirement'] ?? extractedExperience).toString(),
      languages: (json['languages'] ?? extractedLanguages).toString(),
      similarity: parseSimilarity(json['similarity']),
    );
  }
}