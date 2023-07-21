import 'package:expense_tracker/pages/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var cColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 59, 181, 146));

//for dark mode theme
var cDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  //by using SystemChrome we can lock the orientation of the app i.e; landscape/portrait
  //by setting deviceOrientation to portraitUp the will always be in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: cDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: cDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: cDarkColorScheme.onPrimaryContainer,
          foregroundColor: cDarkColorScheme.primaryContainer,
        )),
      ),
      //lightTheme
      theme: ThemeData().copyWith(
        useMaterial3: true,
        //scaffoldBackgroundColor:const Color.fromARGB(255, 225, 107, 180),
        colorScheme: cColorScheme,
        appBarTheme: const AppBarTheme(
          elevation: 8,
        ).copyWith(
          foregroundColor: cColorScheme.primaryContainer,
          backgroundColor: cColorScheme.onPrimaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: cColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: cColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.normal,
                color: cColorScheme.onSecondaryContainer,
                fontSize: 20,
              ),
            ),
      ),
      home: const Expenses(),
    );
  }
}
