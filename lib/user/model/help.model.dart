class Help_Message {
  String Id;
  String Name;
  String email;
  String message;

  Help_Message({
    this.Id = "",
    required this.Name,
    required this.email,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Name': Name,
      'message': message,
      'email': email,
    };
  }

  factory Help_Message.fromJson(Map<String, dynamic> json) {
    return Help_Message(
      Id: json['Id'],
      Name: json['Name'],
      email: json['email'],
      message: json['message'],
    );
  }
}
