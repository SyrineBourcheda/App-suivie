class User_app {
  String Id;
  String FullName;
  String email;
  String PassWord;
  String role;
  bool isLoggedIn;

  User_app(
      {this.Id = "",
      required this.FullName,
      required this.email,
      required this.PassWord,
      required this.role,
      this.isLoggedIn = false});

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'FullName': FullName,
      'email': email,
      'Password': PassWord,
      'role': role,
      'isLoggedIn': isLoggedIn
    };
  }

  factory User_app.fromJson(Map<String, dynamic> json) {
    return User_app(
        Id: json['Id'],
        FullName: json['FullName'],
        email: json['email'],
        PassWord: json['Password'],
        role: json['role'],
        isLoggedIn: json['isLoggedIn']);
  }
}
