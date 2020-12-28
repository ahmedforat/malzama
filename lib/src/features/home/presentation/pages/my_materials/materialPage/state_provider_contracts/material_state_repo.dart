import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/api_client/clients/common_materials_client.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

import '../../../../../../../core/api/contract_response.dart';
import '../../../../../models/materials/college_material.dart';
import '../../../../../models/materials/school_material.dart';
import '../../../../../models/materials/study_material.dart';
import '../quizes/quiz_collection_model.dart';

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

  void replaceMaterialWith(StudyMaterial newMaterial);

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

  Future<void> deleteMaterialById(int pos) async {
    locator<DialogService>().showDialogOfLoading(message: 'deleting');
    final String id = materials[pos].id;
    ContractResponse response = await CommonMaterialClient().deleteMaterial(collectionName: collectionName, materialId: id);
    if (response is Success) {
      if(collectionName.substring((3)) == 'lectures'){
        await FileSystemServices.deleteCachedFileById(id);
      }
      final String storeName = collectionName.substring(3) == 'videos' ? MyUploaded.VIDEOS : MyUploaded.LECTURES;
      await QuizAccessObject().deleteUploadedMaterial(storeName, id: id);

      removeMaterialAt(pos);
      locator<DialogService>().completeAndCloseDialog(null);
      locator<UserInfoStateProvider>().fetchUploadedMaterialsCount();
      await Future.delayed(Duration(milliseconds: 200));
      showSnackBar('deleted', seconds: 4);
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      await Future.delayed(Duration(milliseconds: 200));
      showSnackBar('Failed to delete this material', seconds: 4);
    }
  }

  Future<void> editMaterialById({@required int pos, Map<String, dynamic> payload}) async {
    locator<DialogService>().showDialogOfLoading(message: 'updating');
    final String id = materials[pos].id;
    final String storeName = collectionName.substring(3) == 'videos' ? MyUploaded.VIDEOS : MyUploaded.LECTURES;
    ContractResponse response = await CommonMaterialClient().editMaterial(id: id, collectionName: collectionName, payload: payload);
    if (response is Success) {
      StudyMaterial studyMaterial = await QuizAccessObject().getUploadedVideoOrPdfById(storeName: storeName, id: id);
      if (studyMaterial != null) {
        Map<String, dynamic> localMaterial = studyMaterial.toJSON();
        payload.entries.toList().forEach((element) => localMaterial[element.key] = element.value);
        QuizAccessObject().findOneAndUpdateById(id: id, value: localMaterial, storeName: storeName);
      }
      locator<DialogService>().completeAndCloseDialog(null);
      await Future.delayed(Duration(milliseconds: 200));
      locator<UserInfoStateProvider>().fetchUploadedMaterialsCount();
      showSnackBar('material updated', seconds: 4);
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      await Future.delayed(Duration(milliseconds: 200));
      showSnackBar('Failed to update this material', seconds: 4);
    }
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
