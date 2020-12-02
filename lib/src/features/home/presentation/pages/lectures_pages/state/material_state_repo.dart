import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';

abstract class MaterialStateRepository {

  GlobalKey<ScaffoldState> get scaffoldKey;

  List<StudyMaterial> get materials;

  bool get isAcademic;

  bool get failureOfInitialFetch;

  bool get endOfResults;

  bool get isPagintaionFailed;

  bool get isFetching;

  void setIsFetchingTo(bool update);

  bool get isPaginating;

  void setIsPaginatingTo(bool update);

  Future<void> loadCredentialData();

  Future<void> fetchInitialData();

  Future<void> fetchForPagination();

  void appendToMaterialsFrom(List<StudyMaterial> data);

  Future<void> onRefresh();

  void appendToComments(String id, int pos);

  void removeFromComments(String id, int pos);

  Future<void> onMaterialSaving(int pos);

  Future<void> onMaterialSavingFromExternal(String id);

  void removeMaterialAt(int pos);
  Future<void> showSnackBar(String message, {int seconds});

  void notifyMyListeners();
}



abstract class QuizStateRepository{

  GlobalKey<ScaffoldState> get scaffoldKey;

  List<QuizCollection> get materials;

  bool get isAcademic;

  bool get failureOfInitialFetch;

  bool get endOfResults;

  bool get isPagintaionFailed;

  bool get isFetching;

  void setIsFetchingTo(bool update);

  bool get isPaginating;

  void setIsPaginatingTo(bool update);

  Future<void> loadCredentialData();

  Future<void> fetchInitialData();

  Future<void> fetchForPagination();

  void appendToMaterialsFrom(List<QuizCollection> data);

  Future<void> onRefresh();

  void appendToComments(String id, int pos);

  void removeFromComments(String id, int pos);

  Future<void> onMaterialSaving(int pos);

  Future<void> onMaterialSavingFromExternal(String id);

  void removeMaterialAt(int pos);
  Future<void> showSnackBar(String message, {int seconds});

  void notifyMyListeners();
}
