class UserModel {
  UserModel({
    required this.name,
    required this.number,
    required this.email,
    required this.uId,
  });

  late String name;
  late String number;
  late String email;
  late String uId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["name"] = name;
    data["number"] = number;
    data["email"] = email;
    data["userId"] = uId;
    return data;
  }
}
