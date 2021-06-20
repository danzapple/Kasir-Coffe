import 'package:flutter/material.dart';
import 'package:kasirpemesanancoffe/layout/kasir_modeling.dart';

import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAmber,
        elevation: 0.0,
        title: Text("Kasir Coffe"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 400,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          itemKasir(
                              contentKasir('1', '150'),
                              KasirCoffe(
                                coffe: "1",
                              ),
                              "1"),
                          SizedBox(
                            width: 15,
                          ),
                          itemKasir(
                              contentKasir('2', '100'),
                              KasirCoffe(
                                coffe: "2",
                              ),
                              "2"),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          coffe = "3";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KasirCoffe(
                                        coffe: "3",
                                      )));
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorAmber,
                          ),
                          padding: EdgeInsets.all(8),
                          child: contentKasir('3', '80'),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column contentKasir(String number, String pelanggan) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kasir Coffe $number",
          style: textStyle20White,
        ),
        Text(
          "Buka Jam 08.00 - 23.00 ",
          style: textStyleNormalWhite,
        ),
      ],
    );
  }

  Expanded itemKasir(Widget child, Widget navWidget, String number) {
    return Expanded(
      child: InkWell(
        onTap: () {
          coffe = number;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => navWidget));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorAmber,
          ),
          margin: EdgeInsets.only(
            top: 20,
          ),
          padding: EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
