import 'package:flutter/material.dart';
import 'package:password_manager/AddAccount.dart';
import 'package:password_manager/Home.dart';

import 'Singletons/AppData.dart';
import 'Singletons/CryptoService.dart';
import 'Singletons/SupabaseConfig.dart';


class ListAccount extends StatefulWidget {
  @override
  _ListAccountState createState() => _ListAccountState();

}

class _ListAccountState extends State<ListAccount> {


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Map<String, dynamic>>> _getVaultItems() async{
    final rows = await supabase
        .from('vault_items')
        .select()
        .eq('user_id', appData.userid)
        .order('created_at');

    return List<Map<String, dynamic>>.from(rows as List);
  }

  Future<void> _openAddAccount() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAccount()),
    );
    if (added == true && mounted) {
      setState(() {});
    }
  }

  void _showPasswordDialog(Map<String, dynamic> item) {
    String password;
    try {
      password = cryptoService.decryptText(
        EncryptedPayload(ciphertext: item['encrypted_password'], iv: item['iv']),
      );
    } catch (e) {
      password = '(unable to decrypt)';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['site_name'] ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${item['account_username']}'),
            SizedBox(height: 10),
            Text('Password: $password'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Home()));
              },
            ),
          ),
        ),
      ),
      body:new SafeArea(
        child: new FutureBuilder<List<Map<String, dynamic>>>(
          future:_getVaultItems() ,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            if(snapshot.hasError){
              return Center(child: Text("Failed to load accounts: ${snapshot.error}"));
            }
            final items = snapshot.data ?? [];
            if(items.isEmpty){
              return Center(
                  child: Text("No accounts saved yet. Tap + to add one."),
              );
            }
            return ItemList(list: items, onTapItem: _showPasswordDialog);
          },
        ),
      ),
        floatingActionButton:
        FloatingActionButton.extended(
          onPressed: _openAddAccount,
          icon: Icon(Icons.add_circle),
          label: Text("Account"),
        )
    );
  }
}


class ItemList extends StatelessWidget {

  final List<Map<String, dynamic>> list;
  final void Function(Map<String, dynamic>) onTapItem;

  ItemList({required this.list, required this.onTapItem});

  @override
  Widget build(BuildContext context) {

    return new ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      itemBuilder: (context,i){
        final item = list[i];

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
                        Text(item['site_name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 2.0,),
                        Text(item['account_username'] ?? '', style: TextStyle(color: Colors.grey[700], fontSize: 12),),
                      ],
                    )
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.navigate_next, color: Colors.grey),
            onPressed: () => onTapItem(item),
          ) ,
          onTap: (){
            onTapItem(item);
          },
        );
      },
    );
  }
}
