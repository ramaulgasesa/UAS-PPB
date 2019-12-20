import 'dart:convert';

import 'package:flutter/material.dart';
import 'tambah.dart';
import 'package:http/http.dart' as http;
import 'tambahLaporan.dart';
class DashboardUser extends StatelessWidget {
  DashboardUser({this.id,this.username});
  final String id;
  final String username;
  Future<List> getData(String id) async {
    String url = "https://backendppb.000webhostapp.com/function.php?id="+id;
    final res = await http.get(url);
    return json.decode(res.body); 
  }
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF78DBF3);
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username),
              currentAccountPicture: Image.asset('assets/img/user.png'), 
              accountEmail: null,
            ),
            GestureDetector(
                onTap: (){},
                child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
              )
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Laporan'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
            ),
            ListTile(
              leading: Icon(Icons.keyboard_backspace),
              title: Text('Logout'),
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Keluar'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: getData(id),
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?  ItemList(list: snapshot.data,username: username,) : Center(child: Text('Data belum ada'),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TambahLaporan(username: username,id: id,))),
      ),
    );
  }
}
class ItemList extends StatelessWidget {
  final primaryColor = Color(0xFF78DBF3);
  List list;
  String username;
  ItemList({this.list,this.username});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: list == null ? 0 : list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, idx){
            return Card(
                elevation: 8.0,
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/img/user.png',width: 30,
                          height: 30,
                          fit:BoxFit.fill  ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),),
                        )
                    ],),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 50.0,top: 10.0, bottom: 10.0),
                      child: Text(list[idx]['deskripsi'], textAlign: TextAlign.justify,),
                    ),
                  ),
                ),
            );
          }
      );
  }
}