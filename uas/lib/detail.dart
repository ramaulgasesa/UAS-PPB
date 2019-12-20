import 'package:flutter/material.dart';
import 'adminDashboard.dart';
class Detail extends StatefulWidget {
  final int idx;
  List list;
  String username;
  Detail({this.list,this.idx,this.username});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<String> status = ["Sedang Ditinjau","Proses Tindak Lanjut","Laporan Selesai"];
  String _status = '';
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF78DBF3);
  // final secondColor = Color(0xFF323846);
    final appBarColor = Color(0xFFFAFAFA);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("DASHBOARD", style: TextStyle(color: primaryColor),),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Admin"),
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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
                  child: Text("Detail Laporan", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: primaryColor),),
                ),
                Image.network("https://backendppb.000webhostapp.com/image/${widget.list[widget.idx]['foto']}",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                Text("Username pelapor: ${widget.list[widget.idx]['username']}"),
                Text("Lokasi: ${widget.list[widget.idx]['lokasi']}"),
                Padding(
                  padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                  child: Text("Deskripsi Laporan", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: primaryColor),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(widget.list[widget.idx]['deskripsi'], textAlign: TextAlign.justify,),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Update(id: widget.list[widget.idx]['id'],)));
                      },
                      child: Text("Update", style: TextStyle(color: Colors.white),),
                      color: Colors.blueAccent
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text("Update", style: TextStyle(color: Colors.white),),
                        color: Colors.redAccent
                      ),
                    )
                 ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Update extends StatelessWidget {
  String id;
  Update({this.id});

  List<String> status = ["Sedang Ditinjau","Proses Tindak Lanjut","Laporan Selesai"];
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF78DBF3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Update Laporan"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Row(
            children: <Widget>[
              Text("Ststus Laporan"),

            ],
          ),
        ),
      ),
    );
  }
}