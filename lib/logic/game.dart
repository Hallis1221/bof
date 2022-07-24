class Game {
  final int id;
  final String name;

  Game({
    required this.id,
    required this.name,
  });
  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
