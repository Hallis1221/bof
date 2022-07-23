import 'dart:async';

import 'package:bof/graphql/client.dart';
import 'package:bof/types/job.dart';
import 'package:graphql/client.dart';

class JobsStream {
  Stream<List<Job>> stream = const Stream.empty();
  bool hasMore = true;

  bool _isLoading = false;
  List<Map> _data = [];
  StreamController<List<Map>> _controller = StreamController<List<Map>>();

  JobsStream() {
    _data = <Map>[];
    _controller = StreamController<List<Map>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<Map> postsData) {
      return postsData.map((Map postData) {
        return Job.fromJson(postData);
      }).toList();
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = <Map>[];
      hasMore = true;
    }

    if (_isLoading || !hasMore) {
      return Future.value();
    }

    _isLoading = true;

    return _fetchJobs(10).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (postsData.length == 10);
      _controller.add(_data);
    });
  }
}

Future<List<Map<dynamic, dynamic>>> _fetchJobs(int length) async {
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
    variables: <String, dynamic>{
      "amount": length,
      "offset": length,
      "filter": const {
        "name": "",
        "buckets": [],
        "games": [],
        "location": "",
        "isOnsiteOnly": false
      }
    },
  );

  final QueryResult queryResult = await client.query(options);

  List jobs = queryResult.data!["getJobPreviews"]["jobs"];

  return jobs.map((e) => Job.fromJson(e).toJson()).toList();
}
