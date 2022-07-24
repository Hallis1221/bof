import 'dart:async';

import 'package:bof/graphql/client.dart';
import 'package:bof/types/job.dart';
import 'package:graphql/client.dart';
import 'package:rxdart/rxdart.dart';

import 'bucket.dart';

Future<List<Job>> _fetchJobs(int length, List<Bucket> buckets) async {
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
  final bucketsOfJson =
      buckets.map((Bucket bucket) => bucket.toJson()).toList();

  final QueryOptions options = QueryOptions(
    document: gql(query),
    variables: <String, dynamic>{
      "amount": length,
      "offset": length,
      "filter": {
        "name": "",
        "buckets": bucketsOfJson,
        "games": const [],
        "location": "",
        "isOnsiteOnly": false
      }
    },
  );
  final QueryResult queryResult = await client.query(options);
  List jobs = queryResult.data!["getJobPreviews"]["jobs"];
  return jobs.map((e) => Job.fromJson(e)).toList();
}

class JobStream {
  final BehaviorSubject<List<Job>> _jobs = BehaviorSubject<List<Job>>();
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _hasMore = BehaviorSubject<bool>();

  Stream<List<Job>> get jobs => _jobs.stream;
  Stream<bool> get isLoading => _isLoading.stream;

  bool get hasMore => _hasMore.stream.value;

  // set flipHasMore(bool value) => _hasMore..add(!_hasMore.value);

  JobStream() {
    _isLoading.add(false);
    _jobs.add([]);
    _hasMore.add(true);
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _hasMore.add(true);
    }

    if (_isLoading.value || !_hasMore.value) {
      return Future.value();
    }

    _isLoading.add(true);

    return _fetchJobs(10, []).then((List<Job> jobsData) {
      _isLoading.add(false);
      _jobs.add(_jobs.value..addAll(jobsData));
      _hasMore.add(jobsData.length == 10);
    });
  }
}

class CurrentBuckets {
  final BehaviorSubject<List<Bucket>> _buckets =
      BehaviorSubject<List<Bucket>>.seeded([]);

  Stream get stream$ => _buckets.stream;
  List<Bucket> get buckets => _buckets.value;

  addBucket(Bucket bucket) {
    final List<Bucket> newBuckets = List.from(_buckets.value)..add(bucket);
    _buckets.add(newBuckets);
  }
}
