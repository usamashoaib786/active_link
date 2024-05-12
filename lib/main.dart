import 'package:active_link/View/HomeScreen/provider.dart';
import 'package:active_link/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<NotifyProvider>(create: (_) => NotifyProvider()),      
        ], child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calender',
          theme: ThemeData(),
          home: SplashScreen(),
        ),
      );
    });
  }
}

    
