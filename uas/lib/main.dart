import 'dart:convert';

import 'package:flutter/material.dart';
import 'signup.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'adminDashboard.dart';
import 'dashboardUser.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: <String,WidgetBuilder>{
        '/admin' : (BuildContext context) => DashboardAdmin(),
        '/user' : (BuildContext context) => DashboardUser(),
        '/MyHomePage' : (BuildContext context) => MyHomePage(title: "LOGIN")
      },
      home: MyHomePage(title: 'LOGIN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _username,_password;
  bool error = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final primaryColor = Color(0xFF78DBF3);
  final secondColor = Color(0xFF323846);
  final appBarColor = Color(0xFFFAFAFA);
  Future<List> _login() async{
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      String url = "https://backendppb.000webhostapp.com/auth.php";
      final res = await http.post(url,body: {
        "login" : "login",
        "username" : _username,
        "password" : _password
      });
      if(res.body.toString().length == 0){
        setState(() {
            error = true;
        });
      }else{
        setState(() {
            error = false;
        });
        var dataUser = jsonDecode(res.body.toString());
        if(dataUser["role"] == "admin"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardAdmin(username: dataUser['username'],)));
        }else if(dataUser["role"] == "user"){
          // Navigator.pushReplacementNamed(context, '/user');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardUser(id: dataUser['id'],username: dataUser['username'],)));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(widget.title, style: TextStyle(color: primaryColor),),
      ),
      body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/img/Untan.png',  
                        width: 140.0,  
                        height: 110.0,  
                        fit: BoxFit.contain,  
                      ),
                      Padding(  
                        padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),  
                        child: Text(  
                          "E RESOURCE",  
                          style: TextStyle(color: primaryColor,fontSize: 40.0, fontWeight: FontWeight.bold),  
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:10.0),  
                        child: Text(  
                          "FT UNTAN",  
                          style: TextStyle(color: secondColor,fontSize: 20.0,fontWeight: FontWeight.w300),  
                        ),
                      ),  
                  Form(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: secondColor),
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'Inputan tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (value) => _username = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: secondColor),
                            ),
                            validator: (input){
                              if(input.isEmpty){
                                return 'Inputan tidak boleh kosong';
                              }
                               return null;
                            },
                            onSaved: (input) => _password = input,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: OutlineButton(
                            onPressed: () {
                              _login();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("LOGIN", style: TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                              child: Text("Tidak punya akun?", style: TextStyle(color: secondColor, fontSize: 18.0, fontWeight: FontWeight.w300),),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                              },
                              child: Text("Daftar",style: TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold))),
                         ],),
                        //  Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red))
                      ],
                    ),
                    key: _formKey,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
