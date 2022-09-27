class User {
  User(
      {this.phone,
      this.password,
      this.nom,
      this.prenoms,
      this.commune,
      this.token,
      this.id,
      this.userId,
      this.type,
      this.isDeleted,
      this.email});

  String? phone;
  String? password;
  String? nom;
  String? prenoms;
  String? commune;
  String? token;
  String? id;
  String? type;
  int? userId;
  String? email;
  bool? isDeleted;

  User.withValues(
      {this.id,
      this.nom,
      this.prenoms,
      this.commune,
      this.phone,
      this.password,
      this.token,
      this.type,
      this.userId,
      this.email,
      this.isDeleted});
  User.empty();

  User clone(
      {id,
      nom,
      prenoms,
      commune,
      phone,
      password,
      token,
      type,
      userId,
      isDeleted,
      email}) {
    return User.withValues(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prenoms: prenoms ?? this.prenoms,
        commune: commune ?? this.commune,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        token: token ?? this.token,
        type: type ?? this.type,
        userId: userId ?? this.userId,
        isDeleted: isDeleted ?? this.isDeleted,
        email: email ?? this.email);
  }

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
        email: json["email"] == null ? null : json["email"],
        isDeleted: json["isDeleted"] == null ? null : json["isDeleted"],
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
        "email": email == null ? null : email,
        "isDeleted": isDeleted == null ? null : isDeleted,
      }..removeWhere((String key, dynamic value) => value == null);
}
