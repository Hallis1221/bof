class Company {
  final String companyId;
  final String name;
  final String email;
  final bool isVerified;
  final bool isMarketplacePartner;

  Company({
    required this.companyId,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.isMarketplacePartner,
  });
  factory Company.fromJson(Map<String, dynamic> json) => Company(
        companyId: json["companyId"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        isVerified: json["isVerified"] ?? false,
        isMarketplacePartner: json["isMarketplacePartner"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "name": name,
        "email": email,
        "isVerified": isVerified,
        "isMarketplacePartner": isMarketplacePartner,
      };
}
