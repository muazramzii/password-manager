

//import 'package:busmedic/NavDrawer.dart';
import 'package:password_manager/ListAccount.dart';
import 'package:password_manager/NavDrawer.dart';
import 'package:password_manager/Singletons/AppData.dart';
import 'package:password_manager/Singletons/SupabaseConfig.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final dateFormatter = DateFormat('EEE, d MMM yyyy');
  static final dateFormatter2 = DateFormat('yyyy-MM-dd');
  DateTime checkouttime = DateTime.now();


  bool _validate = false;
  int? _vaultCount;

  @override
  void initState() {
    super.initState();
    _loadVaultCount();
  }

  Future<void> _loadVaultCount() async {
    try {
      final rows = await supabase
          .from('vault_items')
          .select('id')
          .eq('user_id', appData.userid);
      if (!mounted) return;
      setState(() {
        _vaultCount = rows.length;
      });
    } catch (e) {
      // leave _vaultCount null -> shows a placeholder instead of a wrong number
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Password Manager', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),

              Container(
                margin: EdgeInsets.only(top: 10, left: 30),
                child: Text(
                  'Hi, Welcome..,\n' + appData.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoMono',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(height: 5.0,),

              Container(
                  height: 150,
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ListAccount()));
                    },
                    child: Card(
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,
                              child: Text(_vaultCount?.toString() ?? '-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)
                              ),
                            ) ,
                            //SizedBox(width: 10,),

                            Expanded(
                              flex: 2,
                              child: Text('Secure Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  //_openMap();
                                },
                                child: Center(
                                  child: Image.asset('image/lockvector1.png',
                                    height: 60,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text('Category',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),

              Container(
                height: 150,
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ListAccount()));
                        },
                        child: Card(
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Text('Social', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          //launch("https://play.google.com/store/apps/details?id=com.geoxspot.rider.gokl");
                        },
                        child: Card(
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Text('Email', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          //launch("https://play.google.com/store/apps/details?id=my.gov.dbkl.mobis");
                        },
                        child: Card(
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Text('System', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          //launch("https://play.google.com/store/apps/details?id=com.dbkl.myschoolbus");
                        },
                        child: Card(
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Text('Computer', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Manage Your Password', style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('All in one place',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18,
                                letterSpacing: 0.1,))
                        ],
                      )
                  )
              ),

              Image.asset('image/pmimage.png'),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),


    );
  }
}