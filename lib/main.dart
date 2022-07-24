// ignore_for_file: avoid_print

import 'package:bof/widgets/bucket_selector.dart';
import 'package:bof/widgets/jobs.dart';
import 'package:bof/widgets/pages/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: JobPage(),
    );
  }
}

class JobPage extends StatelessWidget {
  const JobPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const JobList(),
      bottomNavigationBar: const GlobalBottomNavigation(),
      appBar: AppBar(
        //appbar widget on Scaffold
        title: const Text("Bucket of flutter!"), //title aof appbar
        backgroundColor: Colors.blueAccent, //background color of appbar

        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SearchPage())),
            icon: const Icon(Icons.search),
          ),
          const BucketSelector(),
        ],
      ),
    );
  }
}

class GlobalBottomNavigation extends StatelessWidget {
  const GlobalBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'My jobs',
        ),
      ],
    );
  }
}
