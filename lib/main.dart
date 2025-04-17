import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:maqdis_connect/core/services/routers.dart';
import 'package:maqdis_connect/features/group/controllers/get_list_group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/perjalanan_controller.dart';
import 'package:maqdis_connect/features/group/controllers/user_status_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load file .env sebelum menjalankan aplikasi
  // inisialisasi localization
  await initializeDateFormatting('id_ID', null);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      initialRoute: '/splashScreen',
      initialBinding: BindingsBuilder(() {
        Get
          ..lazyPut<UserStatusController>(UserStatusController.new)
          ..lazyPut<PerjalananController>(PerjalananController.new)
          ..lazyPut<GetListGroupController>(GetListGroupController.new);
      }),
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: GlobalColors.mainColor,
          selectionColor: GlobalColors.mainColor.withOpacity(0.5),
          selectionHandleColor: GlobalColors.mainColor,
        ),
      ),
      getPages: Routers.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
