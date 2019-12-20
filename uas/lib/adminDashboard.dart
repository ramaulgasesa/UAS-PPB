import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'detail.dart';
class DashboardAdmin extends StatefulWidget {
  DashboardAdmin({this.username});
  final String username;
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final primaryColor = Color(0xFF78DBF3);
  final secondColor = Color(0xFF323846);
  final appBarColor = Color(0xFFFAFAFA);
  Future<List> getData() async {
    String url = "https://backendppb.000webhostapp.com/function.php";
    final res = await http.get(url);
    return json.decode(res.body); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("DASHBOARD", style: TextStyle(color: primaryColor),),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.username),
              currentAccountPicture: Image.asset('assets/img/user.png'), 
              accountEmail: null,
            ),
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DashboardAdmin(username: widget.username,)));
                },
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
            GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/MyHomePage');
                },
                child: ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Logout'),
              )
            ),
          ],
        ),
      ),
      body: DoubleBackToCloseApp(
          child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ?  ItemList(list: snapshot.data,username: widget.username,) : Center(child: Text('Data belum ada'),);
          },
        ),
        snackBar: SnackBar(
          content:  Text('Klik dua kali untuk keluar'),
        ),
      )
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
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => Detail(list: list,idx: idx, username: username,)));
              },
              child: Card(
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
                            child: Text(list[idx]['username'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),),
                          )
                      ],),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 50.0,top: 10.0, bottom: 10.0),
                        child: Text(list[idx]['deskripsi'], textAlign: TextAlign.justify,),
                      ),
                    ),
                  ),
              ),
            ),
          );
        }
    );
  }
}