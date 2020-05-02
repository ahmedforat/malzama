
import 'package:get_it/get_it.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/features/home/presentation/state_provider/my_materials_state_provider.dart';

GetIt locator = GetIt.instance;

void setup(){
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => MyMaterialStateProvider());
}