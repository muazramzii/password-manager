

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager/Home.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:network_to_file_image/network_to_file_image.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;


class ListAccount extends StatefulWidget {
  @override
  _ListAccountState createState() => _ListAccountState();

}

class _ListAccountState extends State<ListAccount> {


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _GetItemtList() async{

    var url = Uri.parse("https://www.triplet-lab.com/kopshop/ItemList.php?token=Wht@11650");

    final response = await http.get(url);

    print(response.body);

    if(response.statusCode == 200){

      print(response.body);
      return json.decode(response.body);

    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_GetEvent();
    _GetItemtList();
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: SafeArea(
          child: AppBar(
            title: const Text('ACCOUNT'),
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Home()));
                });
              },
            ),
          ),
        ),
      ),
      body:new SafeArea(
        child: new FutureBuilder(
          future:_GetItemtList() ,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return new ItemList(list: snapshot.data as List?);
              }
            }
            return Center(
                child: Text("Currently No Product List Available"),
            );
          },
        ),
      ),
        floatingActionButton:
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: Icon(Icons.add_circle),
          label: Text("Account"),
        )
    );
  }
}


class ItemList extends StatelessWidget {

  final List? list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {

    return new ListView.separated(
      itemCount: list==null?0:list!.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      itemBuilder: (context,i){

        return new ListTile(
          leading: Image.asset(
            'image/PMLOGO.png',
            height: 50,
            fit: BoxFit.fitWidth,
          ),
          title:Row(
            children: [
              SizedBox(width: 10,),
              Flexible(
                child:Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list![i]['NAME'], style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 2.0,),
                      ],
                    )
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.navigate_next, color: Colors.grey),
            onPressed: (){},
          ) ,
          onTap: (){
            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new ItemDetail(lists: list,index: i,)));
          },
        );
      },
    );
  }
}