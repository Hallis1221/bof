import 'package:bof/logic/job.dart';
import 'package:bof/logic/my_jobs.dart';
import 'package:bof/main.dart';
import 'package:bof/widgets/jobs.dart';
import 'package:flutter/material.dart';

class MyJobs extends StatelessWidget {
  const MyJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const GlobalBottomNavigation(),
        // Create one listtile for each id in MyJobsManager
        body: StreamBuilder<List<Job>>(
          stream: myJobsManager.jobs,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: myJobsManager.refresh,
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return JobOverviewTile(job: snapshot.data![index]);
                },
              ),
            );
          },
        ));
  }
}
