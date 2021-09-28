class User {
  User({
    this.phone,
    this.password,
    this.nom,
    this.prenoms,
    this.commune,
    this.token,
    this.id,
    this.userId,
    this.type
  });

  String? phone;
  String? password;
  String? nom;
  String? prenoms;
  String? commune;
  String? token;
  String? id;
  String? type;
  int? userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["@id"] == null ? null : json["@id"],
    type: json["@type"] == null ? null : json["@type"],
    userId: json["id"] == null ? null : json["id"],
    phone: json["phone"] == null ? null : json["phone"],
    password: json["password"] == null ? null : json["password"],
    nom: json["nom"] == null ? null : json["nom"],
    prenoms: json["prenoms"] == null ? null : json["prenoms"],
    commune: json["commune"] == null ? null : json["commune"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id == null ? null : id,
    "@type": type == null ? null : type,
    "id": userId == null ? null : userId,
    "phone": phone == null ? null : phone,
    "password": password == null ? null : password,
    "nom": nom == null ? null : nom,
    "prenoms": prenoms == null ? null : prenoms,
    "commune": commune == null ? null : commune,
  };
}
