import 'package:flutter/material.dart';

class FlutterTodosTheme {
  static ThemeData get light {
    return ThemeData(
      fontFamily: 'Rounded',
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        toggleableActiveColor: const Color(0xFF13B9FF));
  }
  static ThemeData get dark{
    return ThemeData(
      fontFamily: 'Rounded',
      appBarTheme : AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: const Color(0xFF13b9ff)
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating
      )
      ,toggleableActiveColor: const Color(0xff13b9ff)
    );
  }
}
