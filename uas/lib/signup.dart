import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _username,_password,_passwordConf;
  bool success = false, found = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final primaryColor = Color(0xFF78DBF3);
  final secondColor = Color(0XFF323846);
  final appBarColor = Color(0xFFFAFAFA);
  Future<List> _signUp() async {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      var url = "https://backendppb.000webhostapp.com/auth.php";
      final res = await http.post(url, body: {
        "signUp": "signUp",
        "username": _username,
        "password": _password
      });
      var resData = jsonDecode(res.body);
      if(resData == 2){
        setState(() {
         found = true; 
        });
      }
      print(resData);
      if(resData == "1"){
        setState(() {
         success = true; 
        });
      }else if(resData == "2"){
        setState(() {
         found = true; 
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: <String,WidgetBuilder>{
        '/login' : (BuildContext context) => MyHomePage(),},
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text("SIGN UP", style: TextStyle(color: primaryColor),)
          ),
          body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(  
                            padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),  
                            child: Text(  
                              "Register",  
                              style: TextStyle(color: primaryColor,fontSize: 40.0, fontWeight: FontWeight.bold),  
                            ),
                          ),
                        Form(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: TextFormField(
                                  onSaved: (input) => _username = input,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: TextStyle(color: secondColor),
                                  ),
                                  validator: (input){
                                    return input.isEmpty ? 'Tidak boleh kosong' : input.length < 6 ? "Username minimal 6 karakter" : null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: TextFormField(
                                  validator: (input){
                                    return input.isEmpty ? 'Tidak boleh kosong' :input.length < 6 ? "Username minimal 6 karakter" : null;
                                  },
                                  onSaved: (input) => _password = input,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: secondColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: TextFormField(
                                  validator: (input){
                                    return input.isEmpty ? 'Tidak boleh kosong' : input.length < 6 ? "Username minimal 6 karakter"  : null;
                                  },
                                  onSaved: (input) => _passwordConf = input,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password',
                                    labelStyle: TextStyle(color: secondColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: OutlineButton(
                                  onPressed: (){
                                    _signUp();
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Icon(Icons.check,size: 60.0,color: primaryColor,),
                                        content: Text("Register berhasil"),
                                        actions: <Widget>[
                                          Center(
                                            child: new IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: (){
                                                Navigator.pushReplacementNamed(context, '/MyHomePage');
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("DAFTAR", style: TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text("Sudah punya akun?", style: TextStyle(color: secondColor, fontSize: 18.0, fontWeight: FontWeight.w300),),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text("Login",style: TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold))),
                              ],
                            )
                          ],
                        ),
                        key: _formKey,
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
    );
  }
}