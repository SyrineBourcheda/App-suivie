import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ResponsiveNavBarPage extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(70);
  ResponsiveNavBarPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: HexColor('#EEF2F3').withOpacity(0.1),
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(150.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/image.png',
                    height: 90,
                    width: 80,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "AppName",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.oleoScript(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: HexColor('#221D67'),
                    ),
                  ),
                  if (isLargeScreen) Expanded(child: _navBarItems())
                ],
              ),
            ),
          ),
        ),
        drawer: isLargeScreen ? null : _drawer(),
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    leading: _getIconForMenuItem(item),
                    title: Text(item),
                  ))
              .toList(),
        ),
      );

  void _onNavBarItemSelected(BuildContext context, int index) {
    switch (_menuItems[index]) {
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Contact':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Reviews':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Sign In':
        Navigator.pushNamed(context, '/login');
        break;
    }
  }

  final List<String> _menuItems = <String>[
    'About',
    'Contact',
    'Reviews',
    'Sign In',
  ];

  Icon _getIconForMenuItem(String menuItem, {double size = 32.0}) {
    IconData iconData;
    Color color;
    switch (menuItem) {
      case 'About':
        iconData = Icons.info_outline;
        color = HexColor('#4B88D0');

        break;
      case 'Contact':
        iconData = Icons.email_outlined;
        color = HexColor('#4B88D0');

        break;
      case 'Reviews':
        iconData = Icons.star_border;
        color = HexColor('#4B88D0');

        break;
      case 'Sign In':
        iconData = Icons.login_outlined;
        color = HexColor('#4B88D0');

        break;
      default:
        iconData = Icons.info_outline;
        color = HexColor('#4B88D0');
    }
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}

class _navBarItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .asMap()
            .entries
            .map(
              (entry) => InkWell(
                onTap: () => _onNavBarItemSelected(context, entry.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 36),
                  child: Row(
                    children: [
                      _getIconForMenuItem(entry.value, size: 24.0),
                      SizedBox(width: 8.0),
                      Text(
                        entry.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.oleoScript(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: HexColor('#221D67'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onNavBarItemSelected(BuildContext context, int index) {
    switch (_menuItems[index]) {
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Contact':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Reviews':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        break;
      case 'Sign In':
        Navigator.pushNamed(context, '/login');
        break;
    }
  }

  final List<String> _menuItems = <String>[
    'About',
    'Contact',
    'Reviews',
    'Sign In',
  ];

  Icon _getIconForMenuItem(String menuItem, {double size = 32.0}) {
    IconData iconData;
    Color color;
    switch (menuItem) {
      case 'About':
        iconData = Icons.info_outline;
        color = HexColor('#4B88D0');

        break;
      case 'Contact':
        iconData = Icons.email_outlined;
        color = HexColor('#4B88D0');

        break;
      case 'Reviews':
        iconData = Icons.star_border;
        color = HexColor('#4B88D0');

        break;
      case 'Sign In':
        iconData = Icons.login_outlined;
        color = HexColor('#4B88D0');

        break;
      default:
        iconData = Icons.info_outline;
        color = HexColor('#4B88D0');
    }
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
