import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'VibeChan';
  static const String appVersion = '1.0.0';
  
  static ThemeData get lightTheme => FlexThemeData.light(
    scheme: FlexScheme.materialBaseline,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    subThemesData: const FlexSubThemesData(
      elevatedButtonRadius: 8,
      outlinedButtonRadius: 8,
      inputDecoratorRadius: 8,
      cardRadius: 8,
    ),
  );

  static ThemeData get darkTheme => FlexThemeData.dark(
    scheme: FlexScheme.materialBaseline,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    subThemesData: const FlexSubThemesData(
      elevatedButtonRadius: 8,
      outlinedButtonRadius: 8,
      inputDecoratorRadius: 8,
      cardRadius: 8,
    ),
  );
}