
import 'package:password_manager/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));


  //register textform
  TextEditingController _regEmail = new TextEditingController();
  TextEditingController _regPassword = new TextEditingController();
  TextEditingController _phoneno = new TextEditingController();
  TextEditingController _regName = new TextEditingController();


  Future _saveRecord(BuildContext context) async {

    var url = Uri.parse("https://www.triplet-lab.com/PasswordManager/Register.php");

    var response = await http.post(url, body: {
      "EMAIL": _regEmail.text,
      "PASSWORD": _regPassword.text,
      "PHONENO": _phoneno.text,
      "NAME": _regName.text,
    });

    if (response.statusCode == 200) {
      //var data = json.decode(response.body);

      final snackBar = SnackBar(
        content: Container(
          height: 40.0,
          child: Center(
              child: Text(
                "Data Saved.",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
        ),
        //duration: Duration(seconds: 10),
        backgroundColor: Colors.black54,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Timer timer = new Timer(new Duration(seconds: 3), () {

        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new Login()));
        });

      });
    }
  }


  Widget _entryField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 45),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Email',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _regEmail,
            decoration: InputDecoration(
              //border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.email_rounded,
                  color: Colors.blueAccent,
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
          SizedBox(
            height: 20,
          ),
          Text('Password',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: _regPassword,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                } else if(value.length < 6 ){
                  return 'Name must be greater than 6 characters';
                }
                return null;
              },
              onSaved: (value) {
                _regPassword;
              },
              decoration: InputDecoration(
                //border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.admin_panel_settings_sharp,
                    color: Colors.blueAccent,
                  ), onPressed: () {  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
          ),
          SizedBox(
            height: 20,
          ),
          Text('Phone No',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _phoneno,
            keyboardType: TextInputType.number,
            //obscureText: isPassword,
            decoration: InputDecoration(
              //border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.phone,
                  color: Colors.blueAccent,
                ), onPressed: () {  },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Please enter Phone No';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text('Name',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.characters,
            controller: _regName,
            //obscureText: isPassword,
            decoration: InputDecoration(
              //border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: Colors.blueAccent,
                ), onPressed: () {  },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Please enter Name';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
        child: ButtonTheme(
          minWidth: double.infinity,
          height: 50.0,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue[900],
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                _saveRecord(context);
                //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Processing Data')));

              }
            },
            child: Text("SUBMIT",
              style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,),
            ),
            //onPressed: () => Navigator.of(context).pushNamed('/home'),
          ),
        )
    );
  }


  Widget _RegisterForm() {
    return Column(
      children: <Widget>[
        _entryField(),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            height: height,
            child:  Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: null,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .1),
                          Text('Register Form', style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),),
                          _RegisterForm(),
                          // SizedBox(height: 5),
                          _submitButton(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}