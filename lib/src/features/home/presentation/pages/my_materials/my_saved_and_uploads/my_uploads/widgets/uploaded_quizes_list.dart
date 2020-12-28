import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/holding_widgets/college/college_uploaded_quiz_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/no_materials_yet_widget.dart';
import 'package:provider/provider.dart';

class UploadedQuizesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider uploadedLecturesStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
    return Scaffold(
      key: uploadedLecturesStateProvider.quizesScaffoldKey,
      body: Selector<MyUploadsStateProvider, bool>(
        selector: (context, stateProvider) => stateProvider.isFetchingQuizes,
        builder: (context, isFetching, _) {
          if (isFetching) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Selector<MyUploadsStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.uploadedQuizes.length,
            builder: (context, count, _) => count == 0
                ? NoMaterialYetWidget(
                    onReload: () async {
                      uploadedLecturesStateProvider.setIsFetchingQuizesTo(true);
                      await uploadedLecturesStateProvider.fetchQuizes();
                      uploadedLecturesStateProvider.setIsFetchingQuizesTo(false);
                    },
                    materialName: 'uploaded quizes',
                  )
                : ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, pos) {
                      QuizCollection currentQuiz = uploadedLecturesStateProvider.uploadedQuizes[pos];
                      if (uploadedLecturesStateProvider.isAcademic) {
                        return CollegeUploadedQuizHoldingWidget(pos: pos);
                      }
                      //SchoolMaterial currentMaterial = uploadedLecturesStateProvider.uploadedLectures[pos];
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentQuiz.credentials.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('published in:${currentQuiz.postDate.substring(0, 10)}'),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${currentQuiz.questionsCount} questions'),
                              Text('Topic: ${currentQuiz.credentials.topic}'),
                              Text('stage:${currentQuiz.credentials.stage}'),
                              Text(
                                currentQuiz.credentials.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: FlatButton(
                            child: Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
