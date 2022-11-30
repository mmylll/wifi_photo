import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wifi_photo/methods/share_intent.dart';
import 'package:wifi_photo/views/handle_intent_ui.dart';
import 'package:wifi_photo/views/drawer/history.dart';
import 'package:wifi_photo/views/intro_page.dart';
import 'package:wifi_photo/views/receive_ui/manual_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_photo/controllers/controllers.dart';
import 'app.dart';

import 'views/share_ui/share_page.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('appData');
  GetIt getIt = GetIt.instance;
  SharedPreferences prefInst = await SharedPreferences.getInstance();
  prefInst.get('isIntroRead') ?? prefInst.setBool('isIntroRead', false);
  prefInst.get('isDarkTheme') ?? prefInst.setBool('isDarkTheme', true);
  getIt.registerSingleton<PercentageController>(PercentageController());
  getIt.registerSingleton<ReceiverDataController>(ReceiverDataController());
  bool externalIntent = false;
  if (Platform.isAndroid) {
    externalIntent = await handleSharingIntent();
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (_) {}
  }
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
            scheme: FlexScheme.deepPurple,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 15,
            appBarOpacity: 0.95,
            swapColors: true,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 30,
            ),
            background: Colors.white,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            fontFamily: 'questrial'),
        routes: {
          '/': (context) => AnimatedSplashScreen(
            splash: 'assets/images/splash.png',
            nextScreen: prefInst.getBool('isIntroRead') == true
                ? (externalIntent ? const HandleIntentUI() : const App())
                : const IntroPage(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: const Color.fromARGB(255, 0, 4, 7),
          ),
          '/home': (context) => const App(),
          '/sharepage': (context) => const SharePage(),
          '/receivepage': (context) => const ReceivePage(),
          '/history': (context) => const HistoryPage()
        },
      )
  );
}
