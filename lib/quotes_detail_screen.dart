import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuotesDetailScreen extends StatelessWidget {
  const QuotesDetailScreen({Key? key}) : super(key: key);

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
          'Motivation', // As per image
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Text(
                '1/15', // Placeholder for quote number
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.volume_up_outlined, color: Colors.white, size: 28.sp),
            onPressed: () {
              // TODO: Implement text-to-speech or sound playback
              print('Volume button tapped');
            },
          ),
          SizedBox(width: 8.w), // Padding for the last icon
        ],
      ),
      body: Stack(
        children: [
          // Main content for the quote
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '“The only way to do great work is to\nlove what you do.”',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24.sp,
                      fontStyle: FontStyle.italic,
                      height: 1.5, // Line height
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '- Steve Jobs',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Swipe up indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100.h), // Adjust as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swipe_up, color: Colors.white, size: 40.sp),
                  SizedBox(height: 8.h),
                  Text(
                    'Swipe up',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          // Bottom action icons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 30.sp),
                    onPressed: () {
                      // TODO: Add to favorites
                      print('Favorite tapped');
                    },
                  ),
                  SizedBox(width: 40.w),
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: Colors.white, size: 30.sp),
                    onPressed: () {
                      // TODO: Share quote
                      print('Share tapped');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
