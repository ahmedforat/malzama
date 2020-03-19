import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfCall extends StatefulWidget {
  @override
  _PdfCallState createState() => _PdfCallState();
}

class _PdfCallState extends State<PdfCall> {
  bool _isLoading=false,_isInit=true;
  PDFDocument document;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: Center(
            child: _isInit?Text('press button to load pdf file'):_isLoading?Center(
              child: CircularProgressIndicator(),
            ):PDFViewer(document: document)
          ))
          ,Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(child: MaterialButton(


                child: Text('assets'),
                      onPressed: (){
                     loadFromAssets();
                           },
                            )),
            ],
          )
        ],
      ),
    );
  }

   loadFromAssets() async{
    setState(() {
      _isInit=false;
      _isLoading=true;
    });
    document = await PDFDocument.fromAsset("assets/ahmed.pdf");


   }

  loadFromURL() async{
    setState(() {
      _isInit=false;
      _isLoading=true;
    });
    document = await PDFDocument.fromAsset("assets/ahmed.pdf");


  }}
