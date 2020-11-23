

import 'package:malzama/src/features/home/models/materials/study_material.dart';

abstract class MaterialStateRepo{
  List<StudyMaterial> get materials;
  bool get isAcademic;
  bool get failureOfInitialFetch;
  bool get endOfResults ;
  bool get isPagintaionFailed;
  bool get isFetching;
  void setIsFetchingTo(bool update);
  bool get isPaginating;
  void setIsPaginatingTo(bool update);
  Future<void> loadCredentialData();
  Future<void> fetchInitialData();
  Future<void> fetchForPagination();
  void appendToMaterialsFrom(List<Map<String, dynamic>> data);
  Future<void> onRefresh();
  void appendToComments(String id,int pos);
  void removeFromComments(String id,int pos);
  void notifyMyListeners();
}