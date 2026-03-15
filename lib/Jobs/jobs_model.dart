class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String jobType;
  final String description;
  final List<String> skills;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.description,
    required this.skills,
  });
}
