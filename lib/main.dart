import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:test_work_app/pages/anketa_page.dart';

import 'constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: SpinKitDoubleBounce(
          color: AppColors.yellow,
          size: 50,
          duration: Duration(milliseconds: 2000),
        ),
      ),
      overlayOpacity: 0.8,
      overlayColor: Colors.black.withOpacity(0.3),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColors.white,
        ),
        home: AnketaPage(),
      ),
    );
  }
}

