
import 'package:get_it/get_it.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/core/platform/services/user_info._service.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/global_current_sender.dart';
import '../../../Navigator/navigation_service.dart';
GetIt locator = GetIt.instance;

void setup()async{
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NotificationStateProvider());
  locator.registerLazySingleton(() => CurrentSender());
}