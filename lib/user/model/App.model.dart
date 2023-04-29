class App {
  String id;
  String appName;
  String packageName;
  String? versionName;
  String? idEnfant;
  bool isBlocked;

  App({
    this.id = "",
    required this.appName,
    required this.packageName,
    required this.versionName,
    this.idEnfant = '',
    required this.isBlocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'packageName': packageName,
      'versionName': versionName,
      'idEnfant': idEnfant,
      'isBlocked': isBlocked
    };
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      appName: json['appName'],
      packageName: json['packageName'],
      versionName: json['versionName'],
      idEnfant: json['idEnfant'],
      isBlocked: json['isBlocked'],
    );
  }
}
