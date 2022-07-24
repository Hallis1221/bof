// ignore_for_file: avoid_print

import 'package:bof/types/jobs.dart';
import 'package:bof/widgets/jobs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'types/bucket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Bucket of Flutter',
      home: Scaffold(
          appBar: AppBar(
            //appbar widget on Scaffold
            title: const Text("Bucket of flutter!"), //title aof appbar
            backgroundColor: Colors.blueAccent, //background color of appbar
            actions: [
              FutureBuilder<List<Bucket>>(
                  future: currentBuckets.possibleBuckets,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return PopupMenuButton(itemBuilder: (context) {
                      return snapshot.data!.map((bucket) {
                        return CheckedPopupMenuItem(
                          value: bucket,
                          checked: currentBuckets.buckets.contains(bucket),
                          child: Text(bucket.name),
                        );
                      }).toList();
                    }, onSelected: (Bucket bucket) {
                      if (currentBuckets.buckets.contains(bucket)) {
                        currentBuckets.removeBucket(bucket);
                      } else {
                        currentBuckets.addBucket(bucket);
                      }
                      jobStream.removeAllJobs();
                      jobStream.refresh();
                    });
                  }),
            ],
          ),
          body: const JobList()),
    );
  }
}
