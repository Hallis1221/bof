import 'package:bof/logic/jobs.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'job.dart';

MyJobsManager myJobsManager = MyJobsManager();

class MyJobsManager {
  final BehaviorSubject<List<String>> _jobIds = BehaviorSubject<List<String>>();
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>();
  final BehaviorSubject<List<Job>> _jobs = BehaviorSubject<List<Job>>();

  late SharedPreferences prefs;

  Stream<List<String>> get jobIds => _jobIds.stream;
  List<String> get jobIdsValue => _jobIds.value;

  Stream<bool> get isLoading => _isLoading.stream;
  bool get isLoadingValue => _isLoading.value;

  Stream<List<Job>> get jobs => _jobs.stream;
  List<Job> get jobsValue => _jobs.value;

  void addJobId(String jobId) {
    // Check if jobId is already in jobIdsValue
    if (!jobIdsValue.contains(jobId)) {
      _jobIds.add(
        List.from(_jobIds.value)..add(jobId),
      );
    }
    save();
  }

  void removeJobId(String jobId) {
    _jobIds.add(
      List.from(_jobIds.value)..remove(jobId),
    );
  }

  void removeAllJobs() {
    _jobIds.add([]);
  }

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    _jobIds.add(prefs.getStringList('jobIds') ?? []);
    convertToJobs();
  }

  Future<void> convertToJobs() async {
    _isLoading.add(true);

    for (var jobId in jobIdsValue) {
      Job job = await jobStream.getJob(jobId);
      _jobs.add(
        List.from(_jobs.value)..add(job),
      );
    }
    _isLoading.add(false);
  }

  Future<void> refresh() async {
    await load();
    await convertToJobs();
    save();
  }

  void convertToJob(String jobId) async {
    _isLoading.add(true);

    Job job = await jobStream.getJob(jobId);
    _jobs.add(
      List.from(_jobs.value)..add(job),
    );

    _isLoading.add(false);
  }

  void save() async {
    await prefs.setStringList('jobIds', _jobIds.value);
    print(prefs.getStringList('jobIds'));
  }

  MyJobsManager() {
    _jobIds.add([]);
    _jobs.add([]);
    load();
  }
}
