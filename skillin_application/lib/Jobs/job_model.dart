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
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      company: (json['company'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      position: (json['position'] ?? '').toString(),
      salary: (json['salary'] ?? '').toString(),
      timeAgo: (json['timeAgo'] ?? json['time_ago'] ?? '').toString(),
      logo: (json['logo'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      skills: (json['skills'] ?? '').toString(),
    );
  }
}