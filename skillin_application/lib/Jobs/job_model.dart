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

    final extractedLocation = extractFromDescription('Location');
    final extractedType = extractFromDescription('Employment Type');
    final extractedWorkplace = extractFromDescription('Workplace');

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
      similarity: (json['similarity'] ?? 0).toDouble(),
    );
  }
}