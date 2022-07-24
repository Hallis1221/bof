import 'package:bof/main.dart';
import 'package:bof/widgets/pages/my_jobs.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

NavigationManager navigationManager = NavigationManager(pages: [
  Page(title: 'Browse', icon: Icons.home, page: const JobPage()),
  Page(title: 'My Jobs', icon: Icons.bookmark, page: const MyJobs()),
]);

class NavigationManager {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>();

  final List<Page> pages;

  Stream<int> get currentPageIndex => _currentPageIndex.stream;
  int get currentPageIndexValue => _currentPageIndex.value;
  Widget get currentPage => pages[_currentPageIndex.value].page;

  void setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  NavigationManager({required this.pages}) {
    _currentPageIndex.add(0);
  }
}

class Page {
  final Widget page;
  final String title;
  final IconData icon;

  Page({
    required this.page,
    required this.title,
    required this.icon,
  });
}
