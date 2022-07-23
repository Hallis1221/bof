// Type imports
import 'package:graphql/client.dart';

import '../graphql/client.dart';
import 'bucket.dart';
import 'company.dart';
import 'game.dart';

class Job {
  final String id;
  final Company company;
  final String title;
  final String location;
  final bool remoteOnly;
  final bool onsiteOnly;
  final DateTime createdAt;
  final DateTime lastEditAt;
  final List<Bucket> buckets;
  final List<Game> games;

  late Future<JobDetails> jobDetails = _getJobDetails(id);

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["jobId"] as String,
        company: Company.fromJson(json["company"]),
        title: json["title"] as String,
        location: json["location"] ?? "",
        remoteOnly: json["remoteOnly"] ?? false,
        onsiteOnly: json["onsiteOnly"] ?? false,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"] as String)
            : DateTime.now(),
        lastEditAt: json["lastEditAt"] != null
            ? DateTime.parse(json["lastEditAt"])
            : DateTime.now(),
        buckets:
            List<Bucket>.from(json["buckets"].map((x) => Bucket.fromJson(x))),
        games: List<Game>.from(json["games"].map((x) => Game.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jobId": id,
        "company": company.toJson(),
        "title": title,
        "location": location,
        "remoteOnly": remoteOnly,
        "onsiteOnly": onsiteOnly,
        "createdAt": createdAt.toIso8601String(),
        "lastEditAt": lastEditAt.toIso8601String(),
        "buckets": List<dynamic>.from(buckets.map((x) => x.toJson())),
        "games": List<dynamic>.from(games.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return '$title - ${company.name}';
  }

  // We can get the details of a job by querying the API with the job ID.

  Future<JobDetails> _getJobDetails(String jobId) {
    const String query = r'''
 query OpenJob($jobId: String!) {
  openJob(jobId: $jobId) {
    jobId
    title
    description
    durationType
    duration
    hourlyrate
    location
    remoteOnly
    onsiteOnly
    isFilled
    isClosed
    createdAt
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
    questions {
      jobQuestionId
      type
      question
      possibleAnswers
      sequence
      isRequired
      __typename
    }
    company {
      vanities {
        vanity
        __typename
      }
      isVerified
      isMarketplacePartner
      companyId
      name
      website
      avatar
      about
      socialDiscord
      socialTwitter
      socialInstagram
      socialLinkedin
      socialFacebook
      __typename
    }
    __typename
  }
}


''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: <String, dynamic>{
        "jobId": jobId,
      },
    );
    return client.query(options).then((QueryResult result) {
      return JobDetails.fromJson(result.data!["openJob"], this);
    });
  }

  Job({
    required this.id,
    required this.company,
    required this.title,
    required this.location,
    required this.remoteOnly,
    required this.onsiteOnly,
    required this.createdAt,
    required this.lastEditAt,
    required this.buckets,
    required this.games,
  });
}

class JobDetails {
  // Job details are fetched from the API with the following query.
  /*
  query OpenJob($jobId: String!) {
  openJob(jobId: $jobId) {
    jobId
    title
    description
    durationType
    duration
    hourlyrate
    location
    remoteOnly
    onsiteOnly
    isFilled
    isClosed
    createdAt
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
    questions {
      jobQuestionId
      type
      question
      possibleAnswers
      sequence
      isRequired
      __typename
    }
    company {
      vanities {
        vanity
        __typename
      }
      isVerified
      isMarketplacePartner
      companyId
      name
      website
      avatar
      about
      socialDiscord
      socialTwitter
      socialInstagram
      socialLinkedin
      socialFacebook
      __typename
    }
    __typename
  }
}
*/

  final Job parent;

  final List<Question> questions;

  final String description;
  final String durationType;
  final String duration;
  final String hourlyrate;

  final bool isFilled;
  final bool isClosed;

  factory JobDetails.fromJson(Map<String, dynamic> json, Job jobParent) =>
      JobDetails(
        parent: jobParent,
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        description: json["description"],
        durationType: json["durationType"],
        duration: json["duration"],
        hourlyrate: json["hourlyrate"],
        isFilled: json["isFilled"],
        isClosed: json["isClosed"],
      );

  JobDetails({
    required this.parent,
    required this.questions,
    required this.description,
    required this.durationType,
    required this.duration,
    required this.hourlyrate,
    required this.isFilled,
    required this.isClosed,
  });
}

class Question {
  final String jobQuestionId;
  final String type;
  final String question;
  final List<String> possibleAnswers;
  final int sequence;
  final bool isRequired;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        jobQuestionId: json["jobQuestionId"],
        type: json["type"],
        question: json["question"],
        possibleAnswers:
            List<String>.from(json["possibleAnswers"].map((x) => x)),
        sequence: json["sequence"],
        isRequired: json["isRequired"],
      );

  Question({
    required this.jobQuestionId,
    required this.type,
    required this.question,
    required this.possibleAnswers,
    required this.sequence,
    required this.isRequired,
  });
}
