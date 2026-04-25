/*import 'package:flutter/material.dart';
import 'dummy_jobs.dart';
import 'job_card.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Find Your Job",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search for jobs...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Jobs List
            Expanded(
              child: ListView.builder(
                itemCount: dummyJobs.length,
                itemBuilder: (context, index) {
                  return JobCard(
                    job: dummyJobs[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JobDetailsScreen(job: dummyJobs[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/
/*
import 'package:flutter/material.dart';
import 'job_card.dart';
import 'job_details_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<JobModel> jobs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final response = await JobsService.getJobs();

    if (response["ok"] == true) {
      final List data = response["data"] as List;

      setState(() {
        jobs = data
            .map((job) => JobModel.fromJson(Map<String, dynamic>.from(job)))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = response["msg"]?.toString() ?? "Failed to load jobs";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Find Your Job",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: fetchJobs,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                )
              : jobs.isEmpty
                  ? const Center(child: Text("No jobs found"))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Search for jobs...",
                                border: InputBorder.none,
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];

                                return JobCard(
                                  job: job,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            JobDetailsScreen(jobId: job.id),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
*/import 'package:flutter/material.dart';
import 'filter_screen.dart';
import 'job_card.dart';
import 'job_details_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';
import '../services/auth_service.dart';

class JobsListScreen extends StatefulWidget {
  final bool useRecommendations;
  final String? initialJobType;

  const JobsListScreen({
    super.key,
    this.useRecommendations = false,
    this.initialJobType,
  });

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<JobModel> allJobs = [];
  List<JobModel> filteredJobs = [];
  List<double> allSimilarities = [];
  List<double> filteredSimilarities = [];

  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(text: "Riyadh, KSA");

  String selectedJobType = "All Jobs";

  @override
  void initState() {
    super.initState();
    selectedJobType = widget.initialJobType ?? "All Jobs";
    fetchJobs();
    searchController.addListener(applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (widget.useRecommendations) {
        final meResult = await AuthService.getMe().timeout(
          const Duration(seconds: 8),
        );

        if (meResult["ok"] != true) {
          setState(() {
            isLoading = false;
            errorMessage =
                meResult["msg"]?.toString() ?? "Failed to load current user.";
          });
          return;
        }

        final Map<String, dynamic> meData =
            Map<String, dynamic>.from(meResult["data"] as Map);

        final int userId = meData["id"];

        final response = await JobsService.getRecommendations(userId);

        if (response["ok"] == true) {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(response["data"] as Map);
          final List recommendations = data["recommendations"] ?? [];

          final List<JobModel> loadedJobs = recommendations.map<JobModel>((rec) {
            final map = Map<String, dynamic>.from(rec as Map);
            final similarity = ((map["similarity"] ?? 0) as num).toDouble();

            return JobModel(
              id: map["job_id"] ?? map["id"] ?? 0,
              title: (map["title"] ?? "").toString(),
              company: (map["company"] ?? "").toString(),
              location: (map["location"] ?? "Riyadh, KSA").toString(),
              category: (map["workplace"] ?? map["category"] ?? "General")
                  .toString(),
              type: (map["employment_type"] ?? map["type"] ?? "Full Time")
                  .toString(),
              position: "",
              salary: "",
              timeAgo: "1 day ago",
              logo: "",
              description: (map["description"] ?? "").toString(),
              skills: (map["skills"] ?? "").toString(),
              similarity: similarity,
            );
          }).toList();

          final List<double> loadedSimilarities =
              loadedJobs.map((job) => job.similarity).toList();

          setState(() {
            allJobs = loadedJobs;
            allSimilarities = loadedSimilarities;
            isLoading = false;
          });

          applyFilters();
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                response["msg"]?.toString() ?? "Failed to load recommendations.";
          });
        }
      } else {
        final response = await JobsService.getJobs();

        if (response["ok"] == true) {
          final List data = response["data"] as List;

          final List<JobModel> loadedJobs = data
              .map((job) => JobModel.fromJson(Map<String, dynamic>.from(job)))
              .toList();

          setState(() {
            allJobs = loadedJobs;
            allSimilarities = loadedJobs.map((job) => job.similarity).toList();
            isLoading = false;
          });

          applyFilters();
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                response["msg"]?.toString() ?? "Failed to load jobs.";
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Something went wrong: $e";
      });
    }
  }

  bool _matchesJobType(JobModel job) {
    if (selectedJobType == "All Jobs") return true;

    final type = job.type.toLowerCase().replaceAll("-", " ").trim();
    final workplace = job.category.toLowerCase().trim();
    final selected = selectedJobType.toLowerCase().replaceAll("-", " ").trim();

    if (selected == "full time") return type == "full time";
    if (selected == "part time") return type == "part time";
    if (selected == "remote") return workplace == "remote" || type == "remote";

    return true;
  }

  bool _matchesLocation(JobModel job) {
    final locationQuery = locationController.text.trim().toLowerCase();

    if (locationQuery.isEmpty ||
        locationQuery == "riyadh, ksa" ||
        locationQuery == "any location") {
      return true;
    }

    return job.location.toLowerCase().contains(locationQuery);
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();

    final List<JobModel> newFilteredJobs = [];
    final List<double> newFilteredSimilarities = [];

    for (int i = 0; i < allJobs.length; i++) {
      final job = allJobs[i];
      final similarity = i < allSimilarities.length ? allSimilarities[i] : 0.0;

      final matchesQuery =
          query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.skills.toLowerCase().contains(query);

      if (matchesQuery && _matchesJobType(job) && _matchesLocation(job)) {
        newFilteredJobs.add(job);
        newFilteredSimilarities.add(similarity);
      }
    }

    setState(() {
      filteredJobs = newFilteredJobs;
      filteredSimilarities = newFilteredSimilarities;
    });
  }

  Future<void> openFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          selectedJobType: selectedJobType,
          selectedLocation: locationController.text,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedJobType = result["jobType"] ?? selectedJobType;
        locationController.text = result["location"] ?? locationController.text;
      });
      applyFilters();
    }
  }

  Widget _searchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage("assets/images/BackgroundSearch.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFB5B8C7)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => applyFilters(),
                    decoration: InputDecoration(
                      hintText: widget.useRecommendations
                          ? "Search recommended jobs..."
                          : "Search jobs...",
                      hintStyle: const TextStyle(color: Color(0xFFB5B8C7)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFF4A146)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: locationController,
                    onChanged: (_) => applyFilters(),
                    decoration: const InputDecoration(
                      hintText: "Riyadh, KSA",
                      hintStyle: TextStyle(color: Color(0xFFB5B8C7)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6A6F85),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _topFilterRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: openFilter,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1F57),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                "assets/images/forFilter.png",
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.tune, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _chip(widget.useRecommendations ? "Recommended" : "All Jobs"),
        const SizedBox(width: 10),
        _chip(selectedJobType),
        const SizedBox(width: 10),
        _chip(locationController.text.isEmpty
            ? "Any Location"
            : locationController.text),
      ],
    );
  }

  Widget _emptyState() {
    return Expanded(
      child: Center(
        child: Text(
          widget.useRecommendations
              ? "No recommendations found"
              : "No jobs found",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1F3B),
          ),
        ),
      ),
    );
  }

  Color _matchColor(double similarity) {
    return const Color(0xFF0F1F57);
  }

  IconData _matchIcon(double similarity) {
    if (similarity >= 0.75) return Icons.star;
    if (similarity >= 0.50) return Icons.thumb_up;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1F3B)),
        title: const Text(
          "Search",
          style: TextStyle(color: Color(0xFF1B1F3B)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(errorMessage!, textAlign: TextAlign.center),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _searchHeader(),
                      const SizedBox(height: 18),
                      _topFilterRow(),
                      const SizedBox(height: 18),
                      filteredJobs.isEmpty
                          ? _emptyState()
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredJobs.length,
                                itemBuilder: (context, index) {
                                  final job = filteredJobs[index];
                                  final similarity =
                                      index < filteredSimilarities.length
                                          ? filteredSimilarities[index]
                                          : 0.0;

                                  final safeSimilarity =
                                      similarity.clamp(0.0, 1.0);

                                  final matchPercent =
                                      (safeSimilarity * 100).toStringAsFixed(0);

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      JobCard(
                                        job: job,
                                        location: job.location.isEmpty
                                            ? "Riyadh, KSA"
                                            : job.location,
                                        jobType: job.type.isEmpty
                                            ? "Full Time"
                                            : job.type,
                                        timeAgo: job.timeAgo.isEmpty
                                            ? "1 day ago"
                                            : job.timeAgo,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => JobDetailsScreen(
                                                jobId: job.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          0,
                                          12,
                                          14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  _matchIcon(safeSimilarity),
                                                  size: 18,
                                                  color:
                                                      _matchColor(safeSimilarity),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Match: $matchPercent%",
                                                  style: TextStyle(
                                                    color: _matchColor(
                                                        safeSimilarity),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                value: safeSimilarity,
                                                minHeight: 8,
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  _matchColor(safeSimilarity),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}