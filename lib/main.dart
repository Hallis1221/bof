// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: HttpLink("https://api.bucketofcrabs.net/graphql"),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            //appbar widget on Scaffold
            title: const Text("Bucket of flutter!"), //title aof appbar
            backgroundColor: Colors.redAccent, //background color of appbar
          ),
          body: const JobList()),
    );
  }
}

class JobList extends StatelessWidget {
  const JobList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*    fetchJobs(client).then((jobs) {
      print(jobs);
    });
*/
    return Center(
      child: FutureBuilder<QueryResult>(
          future: fetchJobs(client),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text("Loading...");
            }

            List jobsRaw = snapshot.data?.data!['getJobPreviews']['jobs'];

            List<Job> jobs = jobsRaw.map((job) {
              print("\n  JOB: ${job!['jobId']} \n \n");
              return (Job(
                id: job!['jobId'],
                createdAt: job!['createdAt'],
                location: job!['location'],
                title: job!['title'],
                onsiteOnly: job!['onsiteOnly'],
                remoteOnly: job!['remoteOnly'],
              ));
            }).toList();

            List<JobOverviewWidget> jobWidgets = jobs.map((job) {
              return JobOverviewWidget(job: job);
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: jobWidgets,
              ),
            );
          }),
    );
  }
}

class JobOverviewWidget extends StatelessWidget {
  const JobOverviewWidget({
    Key? key,
    required this.job,
  }) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: (() => kIsWeb
              ? html.window
                  .open("https://bucketofcrabs.net/jobs/${job.id}", "name")
              : launchUrl(
                  Uri(
                      scheme: 'https',
                      host: 'www.bucketofcrabs.net',
                      path: 'jobs/${job.id}'),
                )),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: Title(
                      color: Colors.red,
                      child: Text(
                        job.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Text(job.location),
                  Text(job.createdAt),
                ],
              ),
            ),
          ),
        ),
      );
}

class Job {
  String id;
  String title;
  String location;
  bool remoteOnly;
  bool onsiteOnly;
  String createdAt;

  Job({
    required this.title,
    required this.location,
    required this.remoteOnly,
    required this.onsiteOnly,
    required this.createdAt,
    required this.id,
  });
}

Future<QueryResult> fetchJobs(GraphQLClient client) async {
  const String query = r'''
  query GetJobPreviews($amount: Int!, $offset: Int!, $filter: GetJobsFilterInput) {
    getJobPreviews(amount: $amount, offset: $offset, filter: $filter) {
      jobs {
        jobId
        company {
          companyId
          name
          email
          isVerified
          isMarketplacePartner
          __typename
        }
        title
        location
        remoteOnly
        onsiteOnly
        createdAt
        lastEditAt
        buckets {
          id
          name
          __typename
        }
        games {
          id
          name
          __typename
        }
        __typename
      }
      totalCount
      __typename
    }
  }

''';

  final QueryOptions options = QueryOptions(
    document: gql(query),
    variables: const <String, dynamic>{
      "amount": 10,
      "offset": 10,
      "filter": {
        "name": "",
        "buckets": [],
        "games": [],
        "location": "",
        "isOnsiteOnly": false
      }
    },
  );

  return await client.query(options);
}
