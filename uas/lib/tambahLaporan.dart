
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:uas/dashboardUser.dart';
class TambahLaporan extends StatefulWidget {
  String username;
  String id;
  TambahLaporan({this.username,this.id});
  @override
  _TambahLaporanState createState() => _TambahLaporanState();
}

class _TambahLaporanState extends State<TambahLaporan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File foto;
  Future<void> _alert(BuildContext context) async {
    return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Icon(Icons.check,size: 60.0,color:  Color(0xFF78DBF3),),
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
      );
    },
  );
  }
  Future _pilihImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      foto = image;
    });
  }
  Future simpan(File foto) async {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      try {
        var stream = http.ByteStream(DelegatingStream.typed(foto.openRead()));
        var imgLenth = await foto.length();
        var uri = Uri.parse("https://backendppb.000webhostapp.com/insert.php");
        var request = http.MultipartRequest("POST", uri);
        var multipartFile = new http.MultipartFile("image", stream, imgLenth, filename: basename(foto.path)); 
        request.fields['detail'] = detail;
        request.fields['lokasi'] = lokasi;
        request.fields['userid'] = widget.id;
        request.files.add(multipartFile);
        var response = await request.send();
        if(response.statusCode > 2){
          print("image upload");
        }else{
          print("image failed");
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }
  String detail,lokasi;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF78DBF3);
    final secondColor = Color(0xFF323846);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor,
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
      body: ListView(
        children: <Widget>[
          Container(
            width: width,
            height: (height/2)+40,
            margin: EdgeInsets.only(top: 50,bottom: 50, left: 20,right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                color: Color(0XFF2699FB),
                offset: Offset(0,5),
                blurRadius: 30,
              ),]
            ),
            child: Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('Form Laporan', textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: TextFormField(
                      onSaved: (value) => detail = value,
                      decoration: InputDecoration(
                        labelText: 'Ketik laporan',
                        labelStyle: TextStyle(color: secondColor),
                      ),
                      validator: (input) {
                        return input.isEmpty ? 'Inputan tidak boleh kosong' : null;
                      },
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: TextFormField(
                      onSaved: (value) => lokasi = value,
                      decoration: InputDecoration(
                        labelText: 'Lokasi',
                        labelStyle: TextStyle(color: secondColor),
                      ),
                    validator: (input) {
                        return input.isEmpty ? 'Inputan tidak boleh kosong' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: foto == null ? OutlineButton(
                      onPressed: _pilihImage,
                      child: Text('Choose file')
                    ): Image.file(foto, width: 150, height: 50,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: OutlineButton(
                      onPressed: () {
                        simpan(foto);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Icon(Icons.check,size: 60.0,color: primaryColor,),
                            content: Text("Laporan anda telah terkirim"),
                            actions: <Widget>[
                              Center(
                                child: new IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: (){
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardUser(id: widget.id,username: widget.username,)));
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
                          Text("Lapor", style: TextStyle(color: primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ],
              ),
              key: _formKey
            ),
          )
      ],),
    );
  }
}