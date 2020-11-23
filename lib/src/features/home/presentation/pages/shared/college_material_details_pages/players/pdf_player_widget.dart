import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PDFPlayerWidget extends StatelessWidget {
  final String _path;

  const PDFPlayerWidget(String path) : this._path = path;

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: _path,
    );
  }
}
