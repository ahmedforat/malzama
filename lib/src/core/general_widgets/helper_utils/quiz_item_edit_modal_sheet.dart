import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_player/edit_quiz_item_state_provider.dart';
import 'package:provider/provider.dart';

class EditQuizItemModalSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    EditQuizItemStateProvider editStateProvider = Provider.of<EditQuizItemStateProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
          height: ScreenUtil().setHeight(1700),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().setSp(50)),
                topRight: Radius.circular(ScreenUtil().setSp(50)),
              )),
          child: Form(
            key: editStateProvider.formKey,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(350)),
                    child: Container(
                      height: ScreenUtil().setHeight(30),
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  Container(
                    //color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(40),
                              //color: Colors.blueAccent,
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(80),
                        ),
                        InkWell(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(45),
                              color: Colors.blueAccent,
                            ),
                          ),
                          onTap: editStateProvider.saveAndUpload,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(80),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(100),
                          ),
                          Container(
                            //height: ScreenUtil().setHeight(300),
                            width: MediaQuery.of(context).size.width,
                            //color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
                            child: Selector<EditQuizItemStateProvider, String>(
                              selector: (context, stateProvider) => stateProvider.errorMessages[0],
                              builder: (context, errorMessage, _){
                                print('question textfield is rebuilding');
                                return TextFormField(
                                  maxLines: null,
                                  controller: editStateProvider.questionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
                                    ),
                                    hintText: 'type question here',
                                    errorText: errorMessage,
                                  ),
                                  onChanged: (value) => editStateProvider.setErrorMessageToNull(0),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                          ),
                          Container(
                            //color: Colors.blueAccent,
                            height: ScreenUtil().setHeight(1000),
                            child: Row(
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: ScreenUtil().setWidth(200),
                                  //color: Colors.yellow,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: OptionRadioListTile(0)),
                                      Expanded(child: OptionRadioListTile(1)),
                                      Expanded(child: OptionRadioListTile(2)),
                                      Expanded(child: OptionRadioListTile(3)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    //color: Colors.purple,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        OptionTextFieldWithSelector(
                                          controller: editStateProvider.optionAcontroller,
                                          hintText: 'option A',
                                          errorMessageIndex: 1,
                                        ),
                                        OptionTextFieldWithSelector(
                                          controller: editStateProvider.optionBcontroller,
                                          hintText: 'option B',
                                          errorMessageIndex: 2,
                                        ),
                                        OptionTextFieldWithSelector(
                                          controller: editStateProvider.optionCcontroller,
                                          hintText: 'option C',
                                          errorMessageIndex: 3,
                                        ),
                                        OptionTextFieldWithSelector(
                                          controller: editStateProvider.optionDcontroller,
                                          hintText: 'option D',
                                          errorMessageIndex: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            //height: ScreenUtil().setHeight(300),
                            width: MediaQuery.of(context).size.width,
                            //color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(30)),
                            child: TextFormField(
                              maxLines: null,
                              maxLength: null,
                              controller: editStateProvider.explainController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
                                ),
                                hintText: 'explain (optional)',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(50),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class OptionRadioListTile extends StatelessWidget {
  final int optionNumber;

  OptionRadioListTile(this.optionNumber);

  @override
  Widget build(BuildContext context) {
    EditQuizItemStateProvider editStateProvider = Provider.of<EditQuizItemStateProvider>(context, listen: false);

    return Container(
      //color: Colors.blueAccent,
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setSp(20),
      ),
      //width: ScreenUtil().setWidth(150),
      //height: ScreenUtil().setWidth(150),
      child: Center(
        child: SizedBox(
          child: Selector<EditQuizItemStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.answers[optionNumber],
            builder: (context, value, _) => Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.green,
              value: value,
              onChanged: (update) => editStateProvider.updateAnswers(update, optionNumber),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionTextFieldWithSelector extends StatelessWidget {
  final int errorMessageIndex;
  final TextEditingController controller;
  final String hintText;

  OptionTextFieldWithSelector({
    @required this.controller,
    @required this.hintText,
    @required this.errorMessageIndex,
  });

  @override
  Widget build(BuildContext context) {
    EditQuizItemStateProvider editStateProvider = Provider.of<EditQuizItemStateProvider>(context, listen: false);

    return Selector<EditQuizItemStateProvider, String>(
      selector: (context, stateProvider) => stateProvider.errorMessages[errorMessageIndex],
      builder: (context, value, _) {
        print('option $errorMessageIndex is rebuilding');
        return OptionTextField(
          controller: controller,
          hintText: hintText,
          errorText: value,
          onChanged: (value) => editStateProvider.setErrorMessageToNull(errorMessageIndex),
        );
      },
    );
  }
}

class OptionTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String errorText;
  final void Function(String) onChanged;

  OptionTextField({
    @required this.controller,
    @required this.hintText,
    @required this.errorText,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: ScreenUtil().setHeight(200),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setSp(20),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              right: ScreenUtil().setSp(50),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(30))),
                  hintText: hintText,
                  errorText: errorText),
              maxLines: null,
              maxLength: null,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
