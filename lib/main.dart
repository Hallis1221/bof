// ignore_for_file: avoid_print

import 'package:bof/logic/navigator.dart' as NM;
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
      currentIndex: NM.navigationManager.currentPageIndexValue,
      onTap: (int index) {
        if (index != NM.navigationManager.currentPageIndexValue) {
          NM.navigationManager.setCurrentPageIndex(index);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => NM.navigationManager.currentPage,
          ));
        }
      },
      items: NM.navigationManager.pages.map((NM.Page page) {
        return BottomNavigationBarItem(
          icon: Icon(page.icon),
          label: page.title,
        );
      }).toList(),
    );
  }
}
