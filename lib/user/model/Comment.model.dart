class Comment {
  String Id;
  String Name;
  String email;
  String message;
  bool isPublished;

  Comment(
      {this.Id = "",
      required this.Name,
      required this.email,
      required this.message,
      this.isPublished = false});

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Name': Name,
      'message': message,
      'email': email,
      'isPublished': isPublished
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        Id: json['Id'],
        Name: json['Name'],
        email: json['email'],
        message: json['message'],
        isPublished: json['ispublished']);
  }
}
