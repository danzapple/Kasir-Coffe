import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasirpemesanancoffe/database/produk_base.dart';
import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';
import 'package:path/path.dart';

class Produk extends StatefulWidget {
  String coffe;
  Produk({@required this.coffe});
  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  TextEditingController namaController;
  TextEditingController hargaController;
  File img;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      img = tempImage;
    });
  }

  String filename;
  String photoUrl = "";

  Future uploadPic(BuildContext context) async {
    filename = basename(img.path);
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child("/produk");

    StorageUploadTask task = firebaseStorage.child(filename).putFile(img);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String downUrl = await (await task.onComplete).ref.getDownloadURL();

    print("photoUrl : " + downUrl);
    setState(() {
      photoUrl = downUrl;
      print("download Url" + photoUrl);
      print("Profile Picture Uploaded");
    });
  }

  @override
  void initState() {
    namaController = TextEditingController(text: "");
    hargaController = TextEditingController(text: "");
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text("Menyimpan...."),
      action: SnackBarAction(
          label: "close",
          onPressed: () {
            print("close");
          }),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  _showSnackBarValidasi() {
    final snackBar = SnackBar(
      content: Text("Data harus di isi dengan lengkap !"),
      action: SnackBarAction(
          label: "close",
          onPressed: () {
            print("close");
          }),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  List<String> _menu = ["Makanan", "Minuman"]; // Option 2
  String _selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: colorAmber,
        title: Text("Produk"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              await getImage();
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 30),
              height: 120,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorWhite,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(1, 1))
                  ]),
              child: img != null
                  ? Image.file(
                      img,
                      fit: BoxFit.cover,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.black26,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Upload Foto",
                          style: textStyleGrey11,
                        )
                      ],
                    ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: colorAmber, style: BorderStyle.solid, width: 1)),
            child: DropdownButton(
              isExpanded: true,
              itemHeight: 60,
              underline: Container(),
              hint: Text(
                'Jenis Menu',
                style: TextStyle(color: Colors.black26),
              ), // Not necessary for Option 1
              value: _selectedMenu,
              onChanged: (newValue) {
                setState(() {
                  _selectedMenu = newValue;
                });
              },
              items: _menu.map((menu) {
                return DropdownMenuItem(
                  child: new Text(menu),
                  value: menu,
                );
              }).toList(),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                controller: namaController,
                cursorColor: colorAmber,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintText: "Nama Makanan/Minuman",
                    hintStyle: TextStyle(color: Colors.black26),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber))),
              )),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: hargaController,
                cursorColor: colorAmber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Harga",
                    hintStyle: TextStyle(color: Colors.black26),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: colorAmber))),
              )),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.only(left: 15, right: 15, top: 40),
            child: RaisedButton(
              elevation: 0.0,
              onPressed: () async {
                if (namaController.text.isEmpty ||
                    hargaController.text.isEmpty ||
                    img == null) {
                  _showSnackBarValidasi();
                } else {
                  _showSnackBar();
                  uploadPic(context).whenComplete(() {
                    ProdukService().produkDataInsert(
                        namaController.text,
                        hargaController.text,
                        photoUrl,
                        widget.coffe,
                        _selectedMenu,
                        context);
                    Navigator.pop(context);
                  });
                }
              },
              color: colorAmber2,
              child: Text(
                "Simpan",
                style: textStyleNormalWhite,
              ),
            ),
          )
        ],
      ),
    );
  }
}
