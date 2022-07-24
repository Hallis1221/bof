import 'package:bof/logic/bucket.dart';
import 'package:bof/logic/jobs.dart';
import 'package:flutter/material.dart';

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
