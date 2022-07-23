class Bucket {
  final int id;
  final String name;

  Bucket({
    required this.id,
    required this.name,
  });
  factory Bucket.fromJson(Map<String, dynamic> json) => Bucket(
        id: json["id"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
