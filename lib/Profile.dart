import 'package:flutter/material.dart';

import 'Singletons/AppData.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Name', appData.name),
              SizedBox(height: 20),
              _buildField('Email', appData.email),
              SizedBox(height: 20),
              _buildField('Phone No', appData.phoneno),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xfff3f3f4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(value.isEmpty ? '-' : value),
        ),
      ],
    );
  }
}
