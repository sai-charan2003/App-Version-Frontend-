import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278190080),
      surfaceTint: Color(4284374622),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280690214),
      onPrimaryContainer: Color(4289835441),
      secondary: Color(4284374622),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4293322470),
      onSecondaryContainer: Color(4283058762),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280690214),
      onTertiaryContainer: Color(4289835441),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294572537),
      onSurface: Color(4279966491),
      onSurfaceVariant: Color(4283188550),
      outline: Color(4286477686),
      outlineVariant: Color(4291806405),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4291217094),
      primaryFixed: Color(4293059298),
      onPrimaryFixed: Color(4279966491),
      primaryFixedDim: Color(4291217094),
      onPrimaryFixedVariant: Color(4282861383),
      secondaryFixed: Color(4293059298),
      onSecondaryFixed: Color(4279966491),
      secondaryFixedDim: Color(4291217094),
      onSecondaryFixedVariant: Color(4282861383),
      tertiaryFixed: Color(4293059298),
      onTertiaryFixed: Color(4279966491),
      tertiaryFixedDim: Color(4291217094),
      onTertiaryFixedVariant: Color(4282861383),
      surfaceDim: Color(4292532954),
      surfaceBright: Color(4294572537),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177779),
      surfaceContainer: Color(4293848814),
      surfaceContainerHigh: Color(4293454056),
      surfaceContainerHighest: Color(4293059298),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278190080),
      surfaceTint: Color(4284374622),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280690214),
      onPrimaryContainer: Color(4292664540),
      secondary: Color(4282598211),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285822068),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280690214),
      onTertiaryContainer: Color(4292664540),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572537),
      onSurface: Color(4279966491),
      onSurfaceVariant: Color(4282925378),
      outline: Color(4284833118),
      outlineVariant: Color(4286675066),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4291217094),
      primaryFixed: Color(4285822068),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284243036),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285822068),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284243036),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285822068),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284243036),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532954),
      surfaceBright: Color(4294572537),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177779),
      surfaceContainer: Color(4293848814),
      surfaceContainerHigh: Color(4293454056),
      surfaceContainerHighest: Color(4293059298),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278190080),
      surfaceTint: Color(4284374622),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280690214),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280427042),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282598211),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280690214),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572537),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280820260),
      outline: Color(4282925378),
      outlineVariant: Color(4282925378),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281348144),
      inversePrimary: Color(4293717228),
      primaryFixed: Color(4282598211),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281150765),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282598211),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281150765),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282598211),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281150765),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532954),
      surfaceBright: Color(4294572537),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177779),
      surfaceContainer: Color(4293848814),
      surfaceContainerHigh: Color(4293454056),
      surfaceContainerHighest: Color(4293059298),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4291217094),
      surfaceTint: Color(4291217094),
      onPrimary: Color(4281348144),
      primaryContainer: Color(4278190080),
      onPrimaryContainer: Color(4288059030),
      secondary: Color(4291217094),
      onSecondary: Color(4281348144),
      secondaryContainer: Color(4282203453),
      onSecondaryContainer: Color(4291940817),
      tertiary: Color(4291217094),
      onTertiary: Color(4281348144),
      tertiaryContainer: Color(4278190080),
      onTertiaryContainer: Color(4288059030),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279440147),
      onSurface: Color(4293059298),
      onSurfaceVariant: Color(4291806405),
      outline: Color(4288188048),
      outlineVariant: Color(4283188550),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059298),
      inversePrimary: Color(4284374622),
      primaryFixed: Color(4293059298),
      onPrimaryFixed: Color(4279966491),
      primaryFixedDim: Color(4291217094),
      onPrimaryFixedVariant: Color(4282861383),
      secondaryFixed: Color(4293059298),
      onSecondaryFixed: Color(4279966491),
      secondaryFixedDim: Color(4291217094),
      onSecondaryFixedVariant: Color(4282861383),
      tertiaryFixed: Color(4293059298),
      onTertiaryFixed: Color(4279966491),
      tertiaryFixedDim: Color(4291217094),
      onTertiaryFixedVariant: Color(4282861383),
      surfaceDim: Color(4279440147),
      surfaceBright: Color(4281940281),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4279966491),
      surfaceContainer: Color(4280229663),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281677109),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4291546059),
      surfaceTint: Color(4291217094),
      onPrimary: Color(4279637526),
      primaryContainer: Color(4287730065),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291546059),
      onSecondary: Color(4279637526),
      secondaryContainer: Color(4287730065),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291546059),
      onTertiary: Color(4279637526),
      tertiaryContainer: Color(4287730065),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440147),
      onSurface: Color(4294704123),
      onSurfaceVariant: Color(4292069577),
      outline: Color(4289372322),
      outlineVariant: Color(4287267202),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059298),
      inversePrimary: Color(4282927176),
      primaryFixed: Color(4293059298),
      onPrimaryFixed: Color(4279308561),
      primaryFixedDim: Color(4291217094),
      onPrimaryFixedVariant: Color(4281742902),
      secondaryFixed: Color(4293059298),
      onSecondaryFixed: Color(4279308561),
      secondaryFixedDim: Color(4291217094),
      onSecondaryFixedVariant: Color(4281742902),
      tertiaryFixed: Color(4293059298),
      onTertiaryFixed: Color(4279308561),
      tertiaryFixedDim: Color(4291217094),
      onTertiaryFixedVariant: Color(4281742902),
      surfaceDim: Color(4279440147),
      surfaceBright: Color(4281940281),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4279966491),
      surfaceContainer: Color(4280229663),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281677109),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294704123),
      surfaceTint: Color(4291217094),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4291546059),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294704123),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291546059),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294704123),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291546059),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440147),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965753),
      outline: Color(4292069577),
      outlineVariant: Color(4292069577),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059298),
      inversePrimary: Color(4280953386),
      primaryFixed: Color(4293388263),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4291546059),
      onPrimaryFixedVariant: Color(4279637526),
      secondaryFixed: Color(4293388263),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291546059),
      onSecondaryFixedVariant: Color(4279637526),
      tertiaryFixed: Color(4293388263),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291546059),
      onTertiaryFixedVariant: Color(4279637526),
      surfaceDim: Color(4279440147),
      surfaceBright: Color(4281940281),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4279966491),
      surfaceContainer: Color(4280229663),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281677109),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
