import 'package:bof/types/job.dart';
import 'package:bof/types/jobs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobList extends StatefulWidget {
  const JobList({
    Key? key,
  }) : super(key: key);

  @override
  JobListState createState() => JobListState();
}

class JobListState extends State<JobList> {
  final scrollController = ScrollController();
  late JobsStream jobs;

  @override
  void initState() {
    jobs = JobsStream();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        jobs.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: jobs.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: jobs.refresh,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < snapshot.data.length) {
                  // return Post(post: snapshot.data[index]);
                  return TempJob(job: snapshot.data[index]);
                } else if (jobs.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('nothing more to load!')),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}

class TempJob extends StatelessWidget {
  const TempJob({Key? key, required this.job}) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: job.getPayRange(job.id),
        builder: (context, snapshot) => ListTile(
            title: Text(job.title),
            subtitle: Text(job.company.name),
            trailing: Text(snapshot.data?.toString() ?? 'N/A'),
            onTap: () {
              final Uri url =
                  Uri.parse("https://bucketofcrabs.net/jobs/${job.id}");
              launchUrl(
                url,
                mode: LaunchMode.inAppWebView,
              ).then((value) {
                if (!value) {
                  throw Exception('Could not launch $url');
                }
              });
            }));
  }
}
