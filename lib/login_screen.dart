import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wellness/sign_up_screen.dart'; // Import for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80.h),
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                    ),
                    Text(
                      'Remember me',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to Forgot Password screen
                    print('Forgot Password? tapped');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Login logic
                print('Login button tapped');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.withOpacity(0.5))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Or',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.withOpacity(0.5))),
              ],
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement Google login
                print('Google login tapped');
              },
              icon: SvgPicture.asset(
                'assets/icons/google.svg',
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
                    label : Text('G Google'), // Text style is from ElevatedButtonThemeData
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Create an account',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent, // A distinct color for links
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h), // Bottom padding
          ],
        ),
      ),
    );
  }
}
