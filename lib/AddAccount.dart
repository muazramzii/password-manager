import 'package:flutter/material.dart';

import 'Singletons/AppData.dart';
import 'Singletons/CryptoService.dart';
import 'Singletons/SupabaseConfig.dart';

class AddAccount extends StatefulWidget {
  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _siteName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isSubmitting = false;
  bool _isShowPassword = false;

  Future<void> _save() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = cryptoService.encryptText(_password.text);
      await supabase.from('vault_items').insert({
        'user_id': appData.userid,
        'site_name': _siteName.text.trim(),
        'account_username': _username.text.trim(),
        'encrypted_password': payload.ciphertext,
        'iv': payload.iv,
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Site / App Name',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _siteName,
                  decoration: InputDecoration(
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    suffixIcon: Icon(Icons.language, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a site/app name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text('Username / Email',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    suffixIcon: Icon(Icons.supervised_user_circle_outlined, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text('Password',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _password,
                  obscureText: !_isShowPassword,
                  decoration: InputDecoration(
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => setState(() => _isShowPassword = !_isShowPassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _save();
                            }
                          },
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text('SAVE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _siteName.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
