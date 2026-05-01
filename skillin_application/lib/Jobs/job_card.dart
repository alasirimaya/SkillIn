import 'package:flutter/material.dart';
import '../profile/saved_job_model.dart';
import '../profile/saved_jobs_provider.dart';
import 'job_model.dart';

class JobCard extends StatefulWidget {
  final JobModel job;
  final String location;
  final String jobType;
  final String timeAgo;
  final VoidCallback onTap;
  final VoidCallback? onSkillGapTap;

  const JobCard({
    super.key,
    required this.job,
    required this.location,
    required this.jobType,
    required this.timeAgo,
    required this.onTap,
    this.onSkillGapTap,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    final isSaved = SavedJobsProvider.isSaved(widget.job.id);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7DBFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.business_center,
                    color: Color(0xFF1B1F3B),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1F3B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${widget.job.company} • ${widget.location}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6A6F85),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    SavedJobsProvider.toggleSaved(
                      SavedJobModel(
                        id: widget.job.id,
                        title: widget.job.title,
                        company: widget.job.company,
                        location: widget.location,
                        jobType: widget.jobType,
                      ),
                    );
                    setState(() {});
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF6A6F85),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _tag(
                  widget.job.skills.isEmpty ? "General" : widget.job.skills,
                ),
                const SizedBox(width: 8),
                _tag(widget.jobType),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Text(
                  widget.timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A6F85),
                  ),
                ),
                const Spacer(),

                if (widget.onSkillGapTap != null) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F1F57),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFF0F1F57),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: widget.onSkillGapTap,
                    child: const Text("Skill Gap"),
                  ),
                  const SizedBox(width: 8),
                ],

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8E3FF),
                    foregroundColor: const Color(0xFF4A63D3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: widget.onTap,
                  child: const Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6A6F85),
          ),
        ),
      ),
    );
  }
}