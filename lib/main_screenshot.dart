// Throwaway harness for capturing README screenshots of each screen without
// needing live Supabase auth/data. NOT part of the shipped app — build with:
//   flutter build web --target=lib/main_screenshot.dart --dart-define=SCREEN=<name>
// SCREEN one of: login, register, home, listaccount, addaccount, profile, about
import 'package:flutter/material.dart';

import 'package:password_manager/AboutApps.dart';
import 'package:password_manager/AddAccount.dart';
import 'package:password_manager/Home.dart';
import 'package:password_manager/ListAccount.dart';
import 'package:password_manager/Login.dart';
import 'package:password_manager/Profile.dart';
import 'package:password_manager/Register.dart';
import 'package:password_manager/Singletons/AppData.dart';

const screen = String.fromEnvironment('SCREEN', defaultValue: 'login');

void main() {
  appData.userid = 'demo-user-id';
  appData.name = 'Muhammad Muaz Ramzi';
  appData.email = 'muazramzii.123@gmail.com';
  appData.phoneno = '0123456789';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (screen) {
      case 'register':
        return Register();
      case 'home':
        return Home();
      case 'listaccount':
        return _MockListAccount();
      case 'addaccount':
        return AddAccount();
      case 'profile':
        return Profile();
      case 'about':
        return AboutApps();
      default:
        return Login();
    }
  }
}

// Same Scaffold/AppBar/FAB as the real ListAccount, but with mock vault
// entries instead of a live Supabase fetch (no auth session in this harness).
class _MockListAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mockItems = [
      {'site_name': 'Gmail', 'account_username': 'demo.user@example.com'},
      {'site_name': 'Facebook', 'account_username': 'demo.user'},
      {'site_name': 'Campus Portal', 'account_username': 'STU2021001'},
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: SafeArea(
          child: AppBar(
            title: const Text('ACCOUNT'),
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ItemList(list: mockItems, onTapItem: (_) {}),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add_circle),
        label: Text("Account"),
      ),
    );
  }
}
