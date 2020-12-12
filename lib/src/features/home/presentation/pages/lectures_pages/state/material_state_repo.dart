import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/api/contract_response.dart';
import '../../../../models/materials/college_material.dart';
import '../../../../models/materials/school_material.dart';
import '../../../../models/materials/study_material.dart';
import '../../my_materials/materialPage/quizes/quiz_collection_model.dart';

abstract class MaterialStateRepository {
  String get failureMessage;

  String get collectionName;

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

  void appendToMaterialsOnRefreshFrom(List<StudyMaterial> data);

  void removeFromComments(String id, int pos);

  Future<void> onMaterialSaving(int pos);

  Future<void> onMaterialSavingFromExternal(String id);

  void removeMaterialAt(int pos);

  Future<void> showSnackBar(String message, {int seconds});

  void notifyMyListeners();

  // json parser
  StudyMaterial jsonParser(dynamic json) {
    return isAcademic
        ? new CollegeMaterial.fromJSON(json as Map<String, dynamic>)
        : new SchoolMaterial.fromJSON(json as Map<String, dynamic>);
  }

  List<StudyMaterial> getFetchedMaterialsFromResponse(ContractResponse response) {
    List<StudyMaterial> fetchedMaterial = [];
    Map<String, dynamic> responseBody = json.decode(response.message);
    List<dynamic> fetchedData = responseBody['data'] as List<dynamic>;
    if (fetchedData.isNotEmpty) {
      List<StudyMaterial> _fetched = fetchedData.map<StudyMaterial>(jsonParser).toList();
      fetchedMaterial.addAll(_fetched);
    }
    return fetchedMaterial;
  }
}

abstract class QuizStateRepository {
  bool get hasQuizes;

  String get failureMessage;

  GlobalKey<ScaffoldState> get scaffoldKey;

  List<QuizCollection> get materials;

  bool get isAcademic;

  bool get failureOfInitialFetch;

  bool get endOfResults;

  bool get isFetching;

  void setIsFetchingTo(bool update);

  bool get isPaginating;

  bool get isPaginationFailed;

  void setIsPaginatingTo(bool update);

  Future<void> loadCredentialData();

  Future<void> fetchInitialData();

  Future<void> fetchForPagination();

  void appendToMaterialsFrom(List<QuizCollection> data);

  void appendToMaterialsOnRefreshFrom(List<QuizCollection> data);

  Future<void> onRefresh();

  void appendToComments(String id, int pos);

  void removeFromComments(String id, int pos);

  Future<void> onMaterialSaving(int pos);

  Future<void> onMaterialSavingFromExternal(String id);

  void removeMaterialAt(int pos);

  Future<void> showSnackBar(String message, {int seconds});

  void notifyMyListeners();

  // json parser
  QuizCollection jsonParser(json) => new QuizCollection.fromJSON(json as Map<String, dynamic>);

  List<QuizCollection> getFetchedDataFromResponse(ContractResponse response) {
    List<QuizCollection> fetchedQuizes = [];
    Map<String, dynamic> data = json.decode(response.message);
    List<dynamic> fetchedData = data['data'] as List<dynamic>;
    if (fetchedData.isNotEmpty) {
      fetchedQuizes = fetchedData.map<QuizCollection>(jsonParser).toList();
    }
    return fetchedQuizes;
  }
}
