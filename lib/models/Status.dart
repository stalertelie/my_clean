class Status {
  Status({
    this.status,
  });

  bool? status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
  };
}