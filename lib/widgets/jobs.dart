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

  @override
  void initState() {
    jobStream = JobStream();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        jobStream.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: jobStream.jobs,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: jobStream.refresh,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < snapshot.data.length) {
                  // return Post(post: snapshot.data[index]);
                  return TempJob(job: snapshot.data[index]);
                } else if (jobStream.hasMore) {
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
      builder: (context, snapshot) {
        final payrangeSnack =
            SnackBar(content: Text(snapshot.data?.toString() ?? 'N/A'));

        return ListTile(
          title: Text(
            job.title,
          ),
          subtitle: Text(job.company.name),
          trailing: SizedBox(
            width: 130.0,
            child: Text(
              snapshot.data?.toString() ?? 'N/A',
              softWrap: false,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onLongPress: () =>
              ScaffoldMessenger.of(context).showSnackBar(payrangeSnack),
          onTap: () {
            final Uri url =
                Uri.parse("https://bucketofcrabs.net/jobs/${job.id}");
            launchUrl(
              url,
              mode: LaunchMode.inAppWebView,
            ).then(
              (value) {
                if (!value) {
                  throw Exception('Could not launch $url');
                }
              },
            );
          },
        );
      },
    );
  }
}
