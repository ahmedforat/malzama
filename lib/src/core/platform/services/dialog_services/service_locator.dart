
import 'package:get_it/get_it.dart';

import '../../../../features/home/models/users/user.dart';
import '../../../../features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import '../../../../features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import '../../../../features/home/presentation/state_provider/notifcation_state_provider.dart';
import '../../../../features/home/presentation/state_provider/user_info_provider.dart';
import '../../../../features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/global_current_sender.dart';
import 'dialog_service.dart';
GetIt locator = GetIt.instance;

void setup(User data)async{
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NotificationStateProvider());
  locator.registerLazySingleton(() => CurrentSender());
  locator.registerLazySingleton(() => PDFStateProvider());
  locator.registerLazySingleton(() => VideoStateProvider());
  locator.registerLazySingleton(() => UserInfoStateProvider(data));

}