import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wellness/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://www.pinterest.com/pin/6544361953512132/', // Placeholder
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadim Rai',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Aadimrai884@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'MAKE IT YOURS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 10.h),
            _buildProfileOptionTile(context, 'Content preferences', Icons.book_outlined, () {
              // TODO: Navigate to Content Preferences
              print('Content preferences tapped');
            }),
            SizedBox(height: 30.h),
            Text(
              'ACCOUNT',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 10.h),
            _buildProfileOptionTile(context, 'Theme', Icons.palette_outlined, () {
              // TODO: Implement Theme selection
              print('Theme tapped');
            }),
            SizedBox(height: 10.h),
            _buildProfileOptionTile(context, 'Forgot Password', Icons.lock_open_outlined, () {
              // TODO: Navigate to Forgot Password
              print('Forgot Password tapped');
            }),
            SizedBox(height: 10.h),
            _buildProfileOptionTile(context, 'Logout', Icons.logout, () {
              // TODO: Implement Logout logic
              print('Logout tapped');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false, // Clear all previous routes
              );
            }),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptionTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 24.sp),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp),
        onTap: onTap,
      ),
    );
  }
}
