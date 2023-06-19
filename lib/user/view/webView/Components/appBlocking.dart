
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentAppList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applications de l'enfant"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('App').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final appDocs = snapshot.data!.docs;
          if (appDocs.isEmpty) {
            return Center(child: Text("Aucune application trouvée."));
          }

          return ListView.builder(
            itemCount: appDocs.length,
            
            itemBuilder: (context, index) {
            final Map<String, dynamic> appData = appDocs[index].data() as Map<String, dynamic>;
              if(appData['appName']!=null){
                return ListTile(
                //leading: Image.memory(appData['iconBytes']),
                title: Text(appData['appName']),
                //subtitle: Text(appData['packageName']),
              );
              }else{
                return ListTile(
                  title: Text('no data'),
                );
              }
            },
          );
        },
      ),
    );
  }
}












































































/*
class AppBlocking extends StatefulWidget {
  const AppBlocking({super.key});

  @override
  State<AppBlocking> createState() => _AppBlockingState();
}

class _AppBlockingState extends State<AppBlocking> {
  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Blocking"),
        actions: <Widget>[Icon(Icons.app_blocking_outlined,color: Colors.white,)],
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "",
                children: [
                   _CustomListTile(
                      title: "Facebook",
                      icon: FontAwesomeIcons.facebook,
                      trailing:
                          CupertinoSwitch(value: switchValue, onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           })),
                  
                   _CustomListTile(
                      title: "Instagram",
                      icon: FontAwesomeIcons.instagram,
                      trailing:
                          CupertinoSwitch(value: switchValue, onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           })),
                  
                   _CustomListTile(
                      title: "TikTok",
                      icon: FontAwesomeIcons.tiktok,
                      trailing:
                          CupertinoSwitch(value: switchValue,onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           })),
                  
                   _CustomListTile(
                      title: "Youtube",
                      icon: FontAwesomeIcons.youtube,
                      trailing:
                          CupertinoSwitch(value: switchValue, onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           })),
                  
                   _CustomListTile(
                      title: "Snapchat",
                      icon: FontAwesomeIcons.snapchat,
                      trailing:
                          CupertinoSwitch(value: switchValue, onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           })),
                  
                   _CustomListTile(
                      title: "Twitter",
                      icon: FontAwesomeIcons.twitter,
                      trailing:
                          CupertinoSwitch(
                            value: switchValue,
                           onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? switchValue;});

                           }
                           )),
                  
                ],
              ),
              
            
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing ?? const Icon(FontAwesomeIcons.forward, size: 18),
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

*/



/*class InstalledAppsScreen extends StatefulWidget {
  @override
  _InstalledAppsScreenState createState() => _InstalledAppsScreenState();
}

class _InstalledAppsScreenState extends State<InstalledAppsScreen> {
  late Stream<QuerySnapshot> _appsStream;

  @override
  void initState() {
    super.initState();
    _appsStream = FirebaseFirestore.instance.collection('apps').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _appsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;

              Uint8List iconData = data['icon'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: MemoryImage(iconData),
                ),
                title: Text(data['appName']),
                subtitle: Text('${data['packageName']}'),
                trailing: Text(
                  'Version: ${data['version']} (${data['buildNumber']})',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _saveInstalledApps,
      ),
    );
  }

  Future<void> _saveInstalledApps() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference appsCollection = firestore.collection('apps');

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    PackageInfo packageInfo;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await deviceInfoPlugin.androidInfo;
      packageInfo = await PackageInfo.fromPlatform();
      ByteData byteData = await rootBundle.load(packageInfo.appName);
      Uint8List iconData = byteData.buffer.asUint8List();
      appsCollection.doc(packageInfo.packageName).set({
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'icon': iconData,
      });
    } 
  }
}
*/


