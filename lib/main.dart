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
    return const MaterialApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Bucket of Flutter',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //appbar widget on Scaffold
          title: const Text("Bucket of flutter!"), //title aof appbar
          backgroundColor: Colors.blueAccent, //background color of appbar

          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchPage())),
                icon: const Icon(Icons.search)),
            const BucketSelector(),
          ],
        ),
        body: const JobList());
  }
}

class BucketSelector extends StatelessWidget {
  const BucketSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bucket>>(
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
        });
  }
}

// Search Page
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    textController.addListener(() {
      currentSearchQuery.setSearchQuery(textController.text);
      jobStream.removeAllJobs();
      jobStream.refresh();
    });
    return Scaffold(
      appBar: AppBar(
        // The search area here
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                      textController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
        actions: const [
          BucketSelector(),
        ],
      ),
      body: const JobList(),
    );
  }
}
