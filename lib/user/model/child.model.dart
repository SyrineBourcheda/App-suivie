class Child {
  String Id;
  String Name;
  int Code;
  String Age;
  String sex;
  String? image;
  String? parentId;
  String status;
  String lat;
  String lng;
  String positionTime;

  Child({
    this.Id = '',
    required this.Name,
    required this.Code,
    required this.Age,
    required this.sex,
    required this.image,
    required this.parentId,
    this.status = "not connected",
    this.lat = '',
    this.lng = '',
    this.positionTime = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Name': Name,
      'Code': Code,
      'Age': Age,
      'sex': sex,
      'image': image,
      'ParentId': parentId,
      'status': status,
      'lat': lat,
      'lng': lng,
      'positionTime': positionTime,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
        Id: json['Id'],
        Name: json['Name'],
        Code: json['Code'],
        Age: json['Age'],
        sex: json['sex'],
        image: json['image'],
        parentId: json['ParentId'],
        status: json['status'],
        lat: json['lat'],
        lng: json['lng'],
        positionTime: json['positionTime']);
  }
}
