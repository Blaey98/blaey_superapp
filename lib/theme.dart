import 'package:flutter/material.dart';

// Defina as cores principais do seu tema
const Color primaryColor = Colors.green;
const Color secondaryColor = Colors.orange;
const Color backgroundColor = Colors.white;
const Color textColor = Colors.black;

// Defina um estilo de texto padrão
final TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: textColor),
  titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: textColor),
  bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: textColor),
);

// Crie um ThemeData personalizado
final ThemeData customTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
    background: backgroundColor,
    onPrimary: backgroundColor,
  ),
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    titleTextStyle: TextStyle(
      color: backgroundColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: backgroundColor,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
);