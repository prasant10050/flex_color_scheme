import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/controllers/theme_controller.dart';
import '../shared/services/theme_service_mem.dart';
import '../shared/utils/app_scroll_behavior.dart';
import 'home_page.dart';

// -----------------------------------------------------------------------------
// EXAMPLE 3 - Four Themes
//
// This example shows how to use three built in color schemes and a custom
// scheme, as selectable FlexColorScheme based theme options in an
// application. The example also uses primary color surface alpha blends.
//
// The Google font Noto Sans is used to show how to use custom fonts.
//
// In this example we use a ThemeService and ThemeController to manage our
// theme settings. This follows the example architecture you get when you
// create a Flutter template application architecture with:
//
// flutter create -t skeleton my_flutter_app
//
// The theme controller is used to change the theme mode, to toggle
// opting in and out of FlexColorScheme's opinionated sub-themes, and to
// change the enum value of the used FlexScheme that creates a new theme
// with the enum related color scheme.
// -----------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use a ThemeController, which glues our theme settings to Flutter Widgets.
  final ThemeController themeController = ThemeController(ThemeServiceMem());

  // Load the the preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await themeController.loadAll();

  // Run the app and pass in the ThemeController. The app listens to the
  // ThemeController for changes, then passes it further down to the HomePage.
  runApp(DemoApp(themeController: themeController));
}

// Create a custom FlexSchemeData with name, description and a light and dark
// FlexSchemeColors. These are the same example colors used in example 2.
const FlexSchemeData _myFlexScheme = FlexSchemeData(
  name: 'Midnight blue',
  description: 'Midnight blue theme, custom definition of all colors',
  light: FlexSchemeColor(
    primary: Color(0xFF00296B),
    primaryVariant: Color(0xFF2F5C91),
    secondary: Color(0xFFFF7B00),
    secondaryVariant: Color(0xFFFDB100),
  ),
  dark: FlexSchemeColor(
    primary: Color(0xFF6B8BC3),
    primaryVariant: Color(0xFF4874AA),
    secondary: Color(0xffff7155),
    secondaryVariant: Color(0xFFF1CB9D),
  ),
);

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key, required this.themeController}) : super(key: key);
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    // Whenever the user updates theme settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: themeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          title: 'Four Themes',
          // Select used light theme for the app by using the ThemeController
          // usedScheme, that contains the value of currently selected
          // FlexScheme enum. If it is the custom scheme, we use the above
          // custom scheme colors, if it is any other scheme, we get the
          // corresponding colors from the FlexColor.schemes map.
          theme: FlexThemeData.light(
            colors: themeController.usedScheme == FlexScheme.custom
                ? _myFlexScheme.light
                : FlexColor.schemes[themeController.usedScheme]!.light,
            // We use a surface color mode where all Material surfaces use
            // the same primary color branding, but scaffold background
            // uses much less.
            surfaceMode: FlexSurfaceMode.lowScaffold,
            // We set the blend level strength to 20.
            blendLevel: 20,
            appBarElevation: 0.5,
            useSubThemes: themeController.useSubThemes,
            // Returns comfortable density on desktops, instead of compact,
            /// like the `VisualDensity.adaptivePlatformDensity` does.
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          // We do the exact same definition for the dark theme, but using
          // FlexThemeData.dark() and the dark FlexSchemeColors instead.
          darkTheme: FlexThemeData.dark(
            colors: themeController.usedScheme == FlexScheme.custom
                ? _myFlexScheme.dark
                : FlexColor.schemes[themeController.usedScheme]!.dark,
            // We don't have to use the same surface mode in dark mode, for an
            // interesting effect here we use a mode where scaffold background
            // color gets a much higher blend value than surface and background.
            surfaceMode: FlexSurfaceMode.highScaffold,
            // You don't have to use same blend level or mode in light
            // and dark mode, here we use a lower value in dark mode, that
            // goes better together with the highScaffold mode.
            blendLevel: 15,
            appBarElevation: 1,
            useSubThemes: themeController.useSubThemes,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          // Use the dark or light theme based on controller setting.
          themeMode: themeController.themeMode,
          // This simple example app has only one page.
          home: HomePage(
            // Pass in the FlexSchemeData we used for the active theme. Not
            // really needed to use FlexColorScheme, but we will use it to
            // show the active theme's name, descriptions and colors in the
            // example. We also use it for the theme mode switch that shows the
            // theme's colors in the different theme modes.
            flexSchemeData: themeController.usedScheme == FlexScheme.custom
                ? _myFlexScheme
                : FlexColor.schemes[themeController.usedScheme]!,
            // Pass in the theme controller to the home page.
            controller: themeController,
          ),
        );
      },
    );
  }
}
