import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';
import 'package:vienna_airport_taxi/core/theme/app_theme.dart';
import 'package:vienna_airport_taxi/presentation/screens/splash/splash_screen.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'), // English
            Locale('de'), // German
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}
