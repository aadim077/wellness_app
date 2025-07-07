import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wellness/login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil at the root of your widget tree.
    // This ensures it's initialized once and available throughout the app.
    // The designSize should match the base design dimensions.
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjust this based on your design's base width and height
      minTextAdapt: true, // Adapts text size for small screens
      splitScreenMode: true, // Enables responsive adaptation for split screen
      builder: (context, child) {
        return MaterialApp(
          title: 'Wellness App',
          debugShowCheckedModeBanner: false, // Optional: Set to false to remove the debug banner
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.dark(secondary: const Color(0xFF262626)),
            // Define IconButtonThemeData
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            // Define AppBarTheme
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
              // Ensure consistent icon color for back buttons etc.
              iconTheme: IconThemeData(color: Colors.white),
            ),
            // Define BottomSheetThemeData
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.black,
              elevation: 3,
            ),
            // Define InputDecorationTheme for TextFields
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w), // Responsive padding
            ),
            // Define TimePickerThemeData
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
              hourMinuteTextColor: const Color(0xFF1E1E1E),
              hourMinuteColor: Colors.grey,
              dayPeriodTextColor: Colors.white70,
              dialBackgroundColor: Colors.black,
              dialHandColor: Colors.white,
              dialTextColor: Colors.white,
              entryModeIconColor: Colors.white,
              helpTextStyle: TextStyle(color: Colors.white),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
            // Define TextTheme
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              // Add other text styles as needed, e.g., for headlines, titles
              headlineLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
              bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            hoverColor: Colors.transparent,
            // Button styles for ElevatedButton and TextButton
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF262626), // Default button background
                foregroundColor: Colors.white, // Default text/icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Default text color for text buttons
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          home: const LoginScreen(), // The initial screen for your app
        );
      },
    );
  }
}
