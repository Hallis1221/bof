import 'package:bof/main.dart';
import 'package:bof/logic/jobs.dart';
import 'package:bof/widgets/jobs.dart';
import 'package:flutter/material.dart';

import '../bucket_selector.dart';

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
