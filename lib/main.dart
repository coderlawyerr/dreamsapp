// main.dart
import 'package:dream/const/color.dart';
import 'package:dream/controller/ruya_provider.dart';
import 'package:dream/controller/theme_provider.dart';
import 'package:dream/model/ruya_model.dart';
import 'package:dream/widget/animated_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';

void main() async {
  //burda da adapteri register etmeyi unutma ve initalize etmeyi unutma
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  await Hive.initFlutter();

  Hive.registerAdapter(RuyaModelAdapter());
  await Hive.openBox<RuyaModel>('ruyalar');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RuyaProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ThemeProvider'ı da buraya ekledik
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Burada "themeProvider" doğru yazılmalı
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: themeProvider.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: FallingTextAnimation(),
    );
  }
}
