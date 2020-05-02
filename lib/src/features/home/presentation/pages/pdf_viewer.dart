import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../state_provider/pdf_viewer_state_provider.dart';

class PDFViewerWidget extends StatefulWidget {
  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  int _totalPages;
  int _currentPage;
  PDFViewController _pdfViewController;

  Widget build(BuildContext context) {
    PdfViewerState pdfViewState = Provider.of<PdfViewerState>(context);
    print('before crash again');

    ScreenUtil.init(context);
    return Scaffold(
      body: pdfViewState.isLoading
          ? Selector<PdfViewerState, int>(
              selector: (context, stateProvider) => stateProvider.progress,
              builder: (context, progress, _) => Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          progress >= 100
                              ? 'Preparing lecture .... '
                              : 'Loading ...' + progress.toString() + '%',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(50)),
                          child: LinearProgressIndicator(value: progress / 100),
                        ),
                      ],
                    ),
                  )),
            )
          : pdfViewState.hasError
              ? Container(
                  child: Center(
                    child: Text(pdfViewState.errorMessage),
                  ),
                )
              : SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: PDFView(
                        filePath: pdfViewState.pdfPath,
                        swipeHorizontal: true,
                        onViewCreated: (controller) async {
                          _pdfViewController = controller;
                          _currentPage =
                              await _pdfViewController.getCurrentPage();
                          _totalPages = await _pdfViewController.getPageCount();
                          setState(() {});
                        },
                        onPageChanged: (current, total) {
                          setState(() {
                            _currentPage = current;
                            _totalPages = total;
                          });
                        },
                      )),
                      Positioned(
                          top: ScreenUtil().setHeight(50),
                          child: Container(
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: ScreenUtil().setWidth(80),
                                    height: ScreenUtil().setHeight(50),
                                    child: Text(
                                      '${_currentPage ?? 0 + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.black45,
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(50),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: ScreenUtil().setWidth(80),
                                    height: ScreenUtil().setHeight(50),
                                    child: Text(
                                      '${_totalPages ?? 0 + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Positioned(
                        top: ScreenUtil().setHeight(1700),
                        left: ScreenUtil().setWidth(100),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setSp(50)),
                                topRight:
                                    Radius.circular(ScreenUtil().setSp(50)),
                              )),
                              builder: (context) => Container(
                                height: ScreenUtil().setHeight(1700),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(ScreenUtil().setSp(10)),
                                    topRight:
                                        Radius.circular(ScreenUtil().setSp(10)),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Comments(),
                                ),
                              ),
                            );
                          },
                          splashColor: Colors.blue,
                          child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                            decoration: BoxDecoration(
                                color: Colors.black26.withOpacity(0.2)),
                            child: Text('View Comments'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}

class Comments extends StatelessWidget {
  List<String> _comments =
      List.generate(50, (int i) => 'the comment number $i');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(230)),
            child: Container(
              height: ScreenUtil().setHeight(20),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, pos) => ListTile(
                leading: FaIcon(FontAwesomeIcons.user),
                title: Text('User member number $pos'),
                subtitle: Text(_comments[pos]),
                trailing: FaIcon(FontAwesomeIcons.thumbsUp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(40),
                right: ScreenUtil().setSp(20),
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: ScreenUtil().setSp(30)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ScreenUtil().setHeight(500)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                          hintText: 'Add a comment',
                      ),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(50),),
                  Icon(Icons.send,color: Colors.blueAccent,size: ScreenUtil().setSp(75),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
