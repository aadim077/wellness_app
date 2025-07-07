import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wellness/profile_screen.dart';
import 'package:wellness/quotes_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: CachedNetworkImageProvider(
                  'https://placehold.co/100x100/000000/FFFFFF/png?text=User',

                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print('My favorites tapped');
                    },
                    icon: Icon(Icons.favorite_border, size: 20.sp),
                    label: Text('My favorites'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print('Remind Me tapped');
                    },
                    icon: Icon(Icons.notifications_none, size: 20.sp),
                    label: Text('Remind Me'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Text(
              "Today's Quotes",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"Your wellness is an investment,\nnot an expense."',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '- Author Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'Quotes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            _buildQuoteCategoryTile(context, 'Feeling blessed', Icons.wb_sunny_outlined),
            SizedBox(height: 10.h),
            _buildQuoteCategoryTile(context, 'Pride Month', Icons.favorite_border),
            SizedBox(height: 10.h),
            _buildQuoteCategoryTile(context, 'Self-worth', Icons.star_border),
            SizedBox(height: 10.h),
            _buildQuoteCategoryTile(context, 'Love', Icons.favorite_outline),
            SizedBox(height: 30.h),
            Text(
              'Health Tips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            _buildHealthTipTile(context, 'Breathe to Reset', Icons.wb_sunny_outlined),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCategoryTile(BuildContext context, String title, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(iconData, color: Colors.white, size: 24.sp),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuotesDetailScreen()),
          );
        },
      ),
    );
  }

  Widget _buildHealthTipTile(BuildContext context, String title, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(iconData, color: Colors.white, size: 24.sp),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp),
        onTap: () {
          // TODO: Navigate to Health Tip detail screen
          print('$title tapped');
        },
      ),
    );
  }
}
