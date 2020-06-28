
import 'package:get_it/get_it.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/features/home/presentation/state_provider/my_materials_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import '../../../Navigator/navigation_service.dart';
GetIt locator = GetIt.instance;

void setup(){
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => MyMaterialStateProvider());
  locator.registerLazySingleton(() => NotificationStateProvider());
  locator.registerLazySingleton(() => NavigationService.getInstance());
}