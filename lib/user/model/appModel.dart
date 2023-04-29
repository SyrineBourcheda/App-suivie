class App {
  String id;
  String AppName;

  App({
    this.id = '',
    required this.AppName,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "AppName": AppName,
    };
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(id: json['id'], AppName: json['AppName']);
  }
}
