import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/references/references.dart';

class QuizWidget extends StatefulWidget {
  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  PageController _pageController;
  double currentPage;
  @override
  void initState() {
    super.initState();
    setState(() {
      _pageController = new PageController();
      WidgetsBinding.instance.addPostFrameCallback((d) {
        print(d);
        print(_pageController.page);
        setState(() {
          currentPage = _pageController.page;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('WWWWWWWWWWWWWWWWWWWWWW'.length);
          print(
              'eater effect than most other antimuscarinic agents?'
                  .length);
        },
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            ScreenUtil().setSp(30),
          ),
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(50)),
              width: double.infinity,
              height: ScreenUtil().setHeight(300),
              child: Text('Pharmacology'),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
            ),
            Expanded(
              child: Container(
                color: Colors.red,
                child: PageView.builder(
                    onPageChanged: (pos) {
                      setState(() {
                        currentPage = double.parse(pos.toString());
                      });
                    },
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, pos) {
                      return QuizBody();
                    }),
              ),
            ),
            if (mounted)
              SizedBox(
                width: double.infinity,
                height: ScreenUtil().setHeight(200),
                child: Container(
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                          onPressed: currentPage == null || currentPage == 0.0
                              ? null
                              : () {
                                  print(_pageController.page);
                                  if (_pageController.page > 0.0) {
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.bounceInOut);
                                  }
                                },
                          icon: Icon(Icons.arrow_back),
                          label: Text('Previous')),
                      SizedBox(width: ScreenUtil().setWidth(200)),
                      FlatButton.icon(
                        onPressed: currentPage == null || currentPage == 9.0
                            ? null
                            : () {
                                print(_pageController.page);
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.bounceInOut);
                              },
                        icon: Text('Next'),
                        label: Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                ),
              )
          ]),
        ),
      ),
    );
  }
}

class QuizBody extends StatefulWidget {
  @override
  _QuizBodyState createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  bool isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    String text = 'Ophthalmic solutions should be formulated to include which of the following?';
    String mainText = '$text $text $text $text Ophthalmic solutions should be formulated to include which ' ;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                //color: Colors.yellowAccent,
                constraints:  isExpanded || mainText.length < 360? BoxConstraints() : BoxConstraints(
                  maxHeight: ScreenUtil().setHeight( 420),
                  minHeight: ScreenUtil().setHeight(420),
                ),
                child: Text(
                     mainText,
                     maxLines: isExpanded ? 1000 : 12,
                    textAlign: TextAlign.center, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil()
              .setSp(45??References.getProperFontSize('The most common disintergrator in compressed tablets is'.length))),
                  ), 
              ),
            
            if(mainText.length > 360) Align(
              child: FlatButton(onPressed: (){
              setState(() {
                isExpanded = !isExpanded;
              });
              }, child: Text(isExpanded ?'See less':'See more')),
              alignment: Alignment.centerRight,
            ),
            SizedBox( 
              height: ScreenUtil().setHeight(50),
            ),
            ListTile(
              leading: selectingWidget(
                  ScreenUtil().setWidth(50), ScreenUtil().setHeight(50)),
              title: Text('Nexium'),
            ),
            ListTile(
              leading: selectingWidget(
                  ScreenUtil().setWidth(50), ScreenUtil().setHeight(50)),
              title: Text('Nexium'),
            ),
            ListTile(
              leading: selectingWidget(
                  ScreenUtil().setWidth(50), ScreenUtil().setHeight(50)),
              title: Text('Nexium'),
            ),
            ListTile(
              leading: selectingWidget(
                  ScreenUtil().setWidth(50), ScreenUtil().setHeight(50)),
              title: Text('Nexium'),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            )
          ],
        ),
      ),
    );
  }

  Widget selectingWidget(double width, double height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      );

      BoxConstraints getBoxConstraints(bool isExpanded,String text,double minHeight,double maxHeight){
        if(isExpanded){
          return BoxConstraints();
        }else{

        }
      }
}
