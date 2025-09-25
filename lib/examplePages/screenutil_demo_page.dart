import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A demo page showcasing flutter_screenutil responsive design features
class ScreenUtilDemoPage extends StatefulWidget {
  const ScreenUtilDemoPage({super.key});

  @override
  State<ScreenUtilDemoPage> createState() => _ScreenUtilDemoPageState();
}

class _ScreenUtilDemoPageState extends State<ScreenUtilDemoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ScreenUtil Demo',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // Header Section
            _buildHeaderSection(),
            SizedBox(height: 24.h),
            
            // Screen Info Section
            _buildScreenInfoSection(),
            SizedBox(height: 24.h),
            
            // Responsive Cards Section
            _buildResponsiveCardsSection(),
            SizedBox(height: 24.h),
            
            // Form Section
            _buildFormSection(),
            SizedBox(height: 24.h),
            
            // Button Examples Section
            _buildButtonExamplesSection(),
            SizedBox(height: 24.h),
            
            // Text Examples Section
            _buildTextExamplesSection(),
            SizedBox(height: 24.h),
            
            // Spacing Examples Section
            _buildSpacingExamplesSection(),
          ],
        ),
      );

  }

  Widget _buildLandscapeLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Main content (60% width)
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Compact header for landscape
                      _buildLandscapeHeader(),
                      SizedBox(height: 20.h),
                      _buildScreenInfoSection(),
                      SizedBox(height: 20.h),
                      _buildFormSection(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Divider
            Container(
              width: 1.w,
              height: double.infinity,
              color: Theme.of(context).dividerColor.withOpacity(0.3),
            ),
            
            // Right Column - Examples (40% width)
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 20.w),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.4,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Landscape section title
                      Text(
                        'Interactive Examples',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      _buildLandscapeResponsiveCards(),
                      SizedBox(height: 20.h),
                      _buildLandscapeButtonExamples(),
                      SizedBox(height: 20.h),
                      _buildLandscapeTextExamples(),
                      SizedBox(height: 20.h),
                      _buildLandscapeSpacingExamples(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.phone_android,
            size: 48.sp,
            color: Colors.white,
          ),
          SizedBox(height: 12.h),
          Text(
            'Flutter ScreenUtil Demo',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Responsive design made simple with ScreenUtil',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScreenInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Screen Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Screen Width', '${1.sw}px'),
            _buildInfoRow('Screen Height', '${1.sh}px'),
            _buildInfoRow('Orientation', MediaQuery.of(context).orientation.name.toUpperCase()),
            _buildInfoRow('Device Pixel Ratio', '${ScreenUtil().pixelRatio}'),
            _buildInfoRow('Text Scale Factor', '${ScreenUtil().textScaleFactor}'),
            _buildInfoRow('Status Bar Height', '${ScreenUtil().statusBarHeight}px'),
            _buildInfoRow('Bottom Bar Height', '${ScreenUtil().bottomBarHeight}px'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Cards',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildResponsiveCard(
                'Small',
                Icons.star,
                Colors.orange,
                'This is a small responsive card that adapts to screen size.',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildResponsiveCard(
                'Medium',
                Icons.favorite,
                Colors.red,
                'This is a medium responsive card with different content.',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildResponsiveCard(
          'Large',
          Icons.lightbulb,
          Colors.amber,
          'This is a large responsive card that spans the full width and adapts its height based on screen size.',
        ),
      ],
    );
  }

  Widget _buildResponsiveCard(String title, IconData icon, Color color, String description) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 10.sp, color: color),
                SizedBox(width: 4.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(isLandscape ? 16.w : 20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Responsive Form',
                style: TextStyle(
                  fontSize: isLandscape ? 16.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: isLandscape ? 12.h : 16.h),
              _buildFormField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) => value?.isEmpty == true ? 'Please enter your name' : null,
              ),
              SizedBox(height: isLandscape ? 12.h : 16.h),
              _buildFormField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty == true ? 'Please enter your email' : null,
              ),
              SizedBox(height: isLandscape ? 12.h : 16.h),
              _buildFormField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Please enter your phone' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: isLandscape ? 13.sp : 14.sp),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: isLandscape ? 18.sp : 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: isLandscape ? 10.h : 12.h,
        ),
        isDense: isLandscape, // Makes the field more compact in landscape
      ),
    );
  }

  Widget _buildButtonExamplesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Buttons',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSnackBar('Small Button Pressed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Small',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSnackBar('Medium Button Pressed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Medium',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showSnackBar('Large Button Pressed'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Large Full Width Button',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextExamplesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Text Sizes',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This is 12sp text',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'This is 14sp text',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'This is 16sp text',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'This is 18sp text',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'This is 20sp text',
              style: TextStyle(fontSize: 20.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'This is 24sp text',
              style: TextStyle(fontSize: 24.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingExamplesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Spacing',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            _buildSpacingExample('4.h', 4.h),
            _buildSpacingExample('8.h', 8.h),
            _buildSpacingExample('12.h', 12.h),
            _buildSpacingExample('16.h', 16.h),
            _buildSpacingExample('20.h', 20.h),
            _buildSpacingExample('24.h', 24.h),
            _buildSpacingExample('32.h', 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingExample(String label, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
        ),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  // Landscape-specific methods
  Widget _buildLandscapeHeader() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_android,
            size: 20.sp,
            color: Colors.white,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ScreenUtil Demo',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Landscape Mode',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeResponsiveCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Cards',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        _buildResponsiveCard(
          'Compact',
          Icons.dashboard,
          Colors.blue,
          'Landscape optimized card design.',
        ),
      ],
    );
  }

  Widget _buildLandscapeButtonExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Button Examples',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSnackBar('Landscape Button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'Test',
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSnackBar('Another Button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'Demo',
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLandscapeTextExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Scaling',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '10sp text',
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
        ),
        Text(
          '12sp text',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        Text(
          '14sp text',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLandscapeSpacingExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spacing',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        _buildSpacingExample('6.h', 6.h),
        _buildSpacingExample('8.h', 8.h),
        _buildSpacingExample('12.h', 12.h),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
