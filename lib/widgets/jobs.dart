import 'package:bof/logic/job.dart';
import 'package:bof/logic/jobs.dart';
import 'package:bof/logic/my_jobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                  return JobOverviewTile(job: snapshot.data[index]);
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

class JobOverviewTile extends StatelessWidget {
  const JobOverviewTile({Key? key, required this.job}) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: job.getPayRange(job.id),
      builder: (context, snapshot) {
        return Slidable(
            key: Key(job.id),
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),
              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {
                jobStream.removeJob(job);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Job saved!'),
                ));
              }),
              // All actions are defined in the children parameter.
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: (BuildContext context) {
                    jobStream.removeJob(job);
                    myJobsManager.addJobId(job.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Job saved!'),
                    ));
                  },
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.bookmark,
                  label: 'Save',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {
                jobStream.removeJob(job);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '\'${job.title}\' dismissed. It will reappear when you refresh.'),
                  ),
                );
              }),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    jobStream.removeJob(job);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '\'${job.title}\' dismissed. It will reappear when you refresh.'),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
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
              onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(snapshot.data?.toString() ?? 'N/A'))),
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
            ));
      },
    );
  }
}
