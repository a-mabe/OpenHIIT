import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openhiit/old/pages/home/home.dart';
// import 'package:openhiit/old/providers/timer_creation_notifier.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Permission.scheduleExactAlarm.isDenied.then((value) {
      if (value) {
        Permission.scheduleExactAlarm.request();
      }
    });
  }

  GoogleFonts.config.allowRuntimeFetching = false;

  // Monospaced font licensing.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.renderViews.first.automaticSystemUiAdjustment =
        false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Theme.of(context).brightness,
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TimerProvider()),
          // ChangeNotifierProvider(create: (_) => TimerCreationNotifier())
        ],
        child: MaterialApp(
          title: 'OpenHIIT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(), // standard dark theme
          themeMode: ThemeMode.system,
          home: const MyHomePage(),
        ));
  }
}
