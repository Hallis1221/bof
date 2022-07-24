class Bucket {
  final String name;

  Bucket({
    required this.name,
  });
  factory Bucket.fromJson(Map<String, dynamic> json) => Bucket(
        name: json["name"],
      );

  // A bucket is actually just a string.
  String toJson() => name.toString();
}
