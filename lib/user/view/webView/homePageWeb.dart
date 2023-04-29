import 'package:flutter/material.dart';

class HomePageWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon application web'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la version web de mon applicationn!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}