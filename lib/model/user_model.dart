// class UserModel {
//   UserModel({
//     required this.name,
//     required this.number,
//     required this.email,
//     required this.uId,
//   });
//
//   late String name;
//   late String number;
//   late String email;
//   late String uId;
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//
//     data["name"] = name;
//     data["number"] = number;
//     data["email"] = email;
//     data["userId"] = uId;
//     return data;
//   }
// }
class UserData {
  String name;
  String email;
  String phoneNumber;
  String profilePic;
  String uId;

  UserData({required this.name, required this.email, required this.phoneNumber, required this.profilePic, required this.uId});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePic: json['profilePictureUrl'] ?? '',
      uId: json['userId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePic,
      'userId': uId,
    };
  }
}
