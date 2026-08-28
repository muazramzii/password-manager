import 'package:flutter/material.dart';

import 'Singletons/AppInfo.dart';

class AboutApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Apps'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('image/PMLOGO.png', height: 120)),
              SizedBox(height: 20),
              Text('Password Manager',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Version ${AppInfo.version}', style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 20),
              Text(
                'Password Manager helps you store your website and app credentials '
                'in an encrypted vault. Your vault passwords are encrypted on your '
                'device with AES-256 before they are ever sent to the server, so '
                'only you can read them.',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
