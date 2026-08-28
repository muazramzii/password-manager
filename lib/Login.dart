import 'package:password_manager/Home.dart';
import 'package:password_manager/Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

import 'Singletons/AppData.dart';
//import 'package:password_manager/Singletons/AppData.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {


  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late FocusNode _passwordFocusNode, _loginFocusNode;
  bool _isShowPassWord = false;
  bool isLoggedIn = false;


  @override
  void initState() {
    super.initState();
    //autoLogIn();
    _passwordFocusNode = FocusNode();
    _loginFocusNode = FocusNode();
  }

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();



  Future<Null>  _loginApps(BuildContext context) async{

    var url =  Uri.parse("https://www.triplet-lab.com/PasswordManager/Login.php");


    try{

      final response = await http.post(url,body:{
        'token':'Wht@11650',
        'email':_email.text,
        'password':_password.text,
      });

      if(response.statusCode == 200){
        print(response.body);

        var data = json.decode(response.body);


        setState(() {

          isLoggedIn = true;

          appData.userid = int.parse(data['USERID']);
          appData.email = data['EMAIL'];
          appData.phoneno = data['PHONE'];
          appData.name = data['NAME'];

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success'),
            backgroundColor: Colors.green,
          ));

          new Timer(new Duration(seconds: 3), (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new Home()));

          });


        });
      }

    }catch(e){
      setState(() {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed!'),
          backgroundColor: Colors.red,
        )
        );

      });
      print("Error : "+e.toString());

    }
  }




  bool _isLoading = false;



  /// show password
  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Theme.of(context).primaryColorDark.withOpacity(0.3), Theme.of(context).primaryColorLight.withOpacity(0.3)]
                      )
                  ),
                ),
              ),
              ClipPath(

                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Theme.of(context).primaryColorDark.withOpacity(0.6), Theme.of(context).primaryColorLight.withOpacity(0.6)])),
                ),
              ),
              ClipPath(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          child: Image.asset('image/PMLOGO.png',
                            height: 200,
                            width: 380,)
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue[900]
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          //登录Form
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      //border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.supervised_user_circle_outlined,
                          color: Colors.blue[900],
                        ), onPressed: () {  },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: !_isShowPassWord,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      //border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isShowPassWord ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue[900],
                          ),
                          onPressed: () => _showPassWord()
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue[900],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //Loading
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation,);
            },
            child: _isLoading ? _buildLoginLoading() : _buildLoginButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLoading() {
    return CircularProgressIndicator();
  }

  Widget _buildLoginButton() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: double.infinity,
            height: 50.0,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20,),
              ),
              onPressed: ()async{

                if (_formKey.currentState!.validate()) {

                }

                _loginApps(context);

                //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

              },
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 10.0,
          ),
          ButtonTheme(
            minWidth: double.infinity,
            height: 50.0,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              child: Text(
                "Register",
                style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700, fontSize: 20,),
              ),
              onPressed: ()async{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _loginFocusNode.dispose();
    super.dispose();
  }
}
