import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/route/page_route.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/service/app_lifecycle.dart';
import 'package:esmartbazaar/service/binding.dart';
import 'package:esmartbazaar/service/local_auth.dart';
import 'package:esmartbazaar/service/native_call.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/hex_color.dart';
import 'package:esmartbazaar/util/security/app_config.dart';

import 'data/app_pref.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
bool _isDeviceRooted = true;

/*bool isLocalApk = true;*/

Widget? testPageMode() => null;


Future<void> _iniSafeDevice() async {
  _isDeviceRooted =await NativeCall.isDeviceRooted();
  /*await PalTrustedDevice.check(onFail: () {  },rooted: true,devMode: false,
      emulator: true,onExtStorage: false);*/

}

Future<void> _initOrientations() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _iniSafeDevice();
  await _initOrientations();
  await appBinding();
  debugPrint = (String? message, {int? wrapWidth}) => '';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppPreference appPreference = Get.find();

  @override
  Widget build(BuildContext context) {
    var initialPage = _initialPage();

    if (_isDeviceRooted) {
      initialPage = AppRoute.rootPage;
    }

    if (testPageMode() != null) {
      initialPage = AppRoute.testPage;
    }
    var backgroundColor = AppColor.backgroundColor;
    ThemeData themeData = _themeData(backgroundColor);

    return AppLifecycleManager(
      child: GetMaterialApp(
          navigatorKey: navState,
          themeMode: ThemeMode.light,
          navigatorObservers: [routeObserver],
          theme: themeData,
          initialRoute: initialPage,
          getPages: getAllPages),
    );
  }

  ThemeData _themeData(Color backgroundColor) {
    return ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        dividerColor: Colors.grey,
        dividerTheme:
            const DividerThemeData(space: 12, thickness: 1, indent: 10),
        fontFamily: 'ProductSans',
        colorScheme: ColorScheme.light(
            primary: HexColor("470175"),
            secondary: HexColor("0e0273"),
            onSecondary: Colors.white),
        cardTheme: CardTheme(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        primaryColor: HexColor("470175"),
        primaryColorDark: HexColor("2d004a"),
        primaryColorLight: HexColor("5e009c"),
        textTheme: buildTextTheme(),
    useMaterial3: false);
  }

  String _initialPage() {
    return (appPreference.sessionKey.isEmpty ||
            appPreference.sessionKey == "na" || !appPreference.isBiometricAuthentication)
        ? AppRoute.loginPage
        : AppRoute.mainPage;
  }

  TextTheme buildTextTheme() {
    return const TextTheme(
      headline5: TextStyle(fontSize: 22.0, height: 1.3),
      headline4:
          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, height: 1.3),
      headline3:
          TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, height: 1.3),
      headline2:
          TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, height: 1.4),
      headline1:
          TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, height: 1.4),
      subtitle1:
          TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, height: 1.2),
      headline6:
          TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, height: 1.3),
      bodyText2:
          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2),
      bodyText1:
          TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, height: 1.3),
      caption:
          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, height: 1.2),
    );
  }

  @override
  void initState() {
    super.initState();

    AppConfig.init();
  }

  @override
  void dispose() {
    super.dispose();
  }
}




/*App To Do*/
/*
*
*
* */
