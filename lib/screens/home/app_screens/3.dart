import 'dart:io';

import 'package:VIRTUALDRKIT/screens/home/app_screens/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

class MyHomePage3 extends StatelessWidget {
  final doc = pdf.Document();
  final heading = "DR Prescription Data";
  final description = "Your DR level : 3. You are free from DR";
  var image1;

  MyHomePage3(File image) {
    image1 =
        PdfImage.file(doc.document, bytes: File(image.path).readAsBytesSync());
  }

  writeOnPdf() {
    doc.addPage(pdf.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pdf.EdgeInsets.all(32),
        build: (pdf.Context context) {
          return <pdf.Widget>[
            pdf.Center(
                child: pdf.Text(heading,
                    textAlign: pdf.TextAlign.center,
                    style: pdf.TextStyle(fontSize: 16.0))),
            pdf.SizedBox(height: 30.0),
            pdf.Text(description,
                textAlign: pdf.TextAlign.left,
                style: pdf.TextStyle(fontSize: 15.0)),
            pdf.Image(image1)
          ];
        }));
  }

  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(doc.save());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: RaisedButton(
        onPressed: () async {
          writeOnPdf();
          await savePDF();
          Directory documentDirectory =
              await getApplicationDocumentsDirectory();

          String documentPath = documentDirectory.path;

          String fullPath = "$documentPath/example.pdf";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPreviewScreen(
                        path: fullPath,
                      )));
        },
        child: Text("Click to Continue"),
      ),
    );
  }
}
