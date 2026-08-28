
import 'package:password_manager/Home.dart';
import 'package:password_manager/ListAccount.dart';
import 'package:password_manager/Login.dart';
//import 'package:password_manager/Profile.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/Singletons/AppData.dart';
import 'package:password_manager/Singletons/CryptoService.dart';
import 'package:password_manager/Singletons/SupabaseConfig.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Image.asset('image/PMLOGO.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
          ),

          ListTile(
            leading: Icon(Icons.supervised_user_circle_outlined),
            title: Text('Profile'),
            onTap: () => {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()))
            },
          ),
          Divider(
              color: Colors.grey
          ),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text('List Account'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListAccount()));
            },
          ),
          Divider(
              color: Colors.grey
          ),

          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Apps'),
            onTap: () => {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => YourPets()))
            },
          ),
          Divider(
              color: Colors.grey
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async{
              await supabase.auth.signOut();
              cryptoService.clear();
              appData.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Login()),
                      (Route<dynamic> route) => false
              );
            },

          ),
        ],
      ),
    );
  }
}
