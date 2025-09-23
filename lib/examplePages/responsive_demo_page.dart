import 'package:flutter/material.dart';
import '../core/responsive/responsive.dart';
import '../core/widgets/responsive/responsive_widgets.dart';

/// A demo page showcasing responsive design features
class ResponsiveDemoPage extends StatefulWidget {
  const ResponsiveDemoPage({super.key});

  @override
  State<ResponsiveDemoPage> createState() => _ResponsiveDemoPageState();
}

class _ResponsiveDemoPageState extends State<ResponsiveDemoPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Demo'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: ResponsiveUtils.getResponsiveFontSize(context, 24),
            ),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, screenSize, isLandscape) {
          return SingleChildScrollView(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: ResponsiveColumn(
              children: [
                _buildHeader(context, isLandscape),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
                _buildDemoCards(context, isLandscape),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
                _buildDemoForm(context, isLandscape),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
                _buildDemoButtons(context, isLandscape),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
                _buildScreenInfo(context, screenSize, isLandscape),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, bool isLandscape) {
    return ResponsiveCard(
      child: ResponsiveColumn(
        children: [
          Icon(
            Icons.phone_android,
            size: ResponsiveUtils.getResponsiveFontSize(context, 64),
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          ResponsiveText(
            'Responsive Design Demo',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          ResponsiveText(
            'This page demonstrates responsive design features including landscape support',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
            textAlign: TextAlign.center,
          ),
          if (isLandscape) ...[
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            ResponsiveText(
              '🌄 Landscape Mode Active',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDemoCards(BuildContext context, bool isLandscape) {
    return ResponsiveWidget(
      mobile: ResponsiveColumn(
        children: [
          _buildDemoCard(context, 'Mobile Layout', Icons.phone_android, Colors.blue),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          _buildDemoCard(context, 'Responsive Features', Icons.rectangle, Colors.green),
        ],
      ),
      landscape: ResponsiveRow(
        children: [
          Expanded(
            child: _buildDemoCard(context, 'Landscape Layout', Icons.phone_android, Colors.orange),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Expanded(
            child: _buildDemoCard(context, 'Responsive Features', Icons.rectangle, Colors.purple),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDemoCard(BuildContext context, String title, IconData icon, Color color) {
    return ResponsiveCard(
      child: ResponsiveColumn(
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getResponsiveFontSize(context, 48),
            color: color,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          ResponsiveText(
            'This card adapts to different screen sizes and orientations',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDemoForm(BuildContext context, bool isLandscape) {
    return ResponsiveForm(
      formKey: _formKey,
      children: [
          ResponsiveText(
            'Demo Form',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          ResponsiveFormField(
            labelText: 'Name',
            hintText: 'Enter your name',
            controller: _nameController,
            prefixIcon: Icon(
              Icons.person,
              size: ResponsiveUtils.getResponsiveFontSize(context, 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          ResponsiveFormField(
            labelText: 'Email',
            hintText: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email,
              size: ResponsiveUtils.getResponsiveFontSize(context, 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          ResponsiveFormField(
            labelText: 'Phone',
            hintText: 'Enter your phone number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(
              Icons.phone,
              size: ResponsiveUtils.getResponsiveFontSize(context, 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          ResponsiveButton(
            onPressed: _submitForm,
            child: ResponsiveText(
              'Submit Form',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
    );
  }
  
  Widget _buildDemoButtons(BuildContext context, bool isLandscape) {
    return ResponsiveCard(
      child: ResponsiveColumn(
        children: [
          ResponsiveText(
            'Interactive Elements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 30),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          ResponsiveRow(
            children: [
              Expanded(
                child: ResponsiveButton(
                  onPressed: _showAlertDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: ResponsiveText(
                    'Alert Dialog',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              Expanded(
                child: ResponsiveButton(
                  onPressed: _showBottomSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: ResponsiveText(
                    'Bottom Sheet',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildScreenInfo(BuildContext context, ScreenSize screenSize, bool isLandscape) {
    return ResponsiveCard(
      child: ResponsiveColumn(
        children: [
          ResponsiveText(
            'Screen Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          _buildInfoRow(context, 'Screen Size', screenSize.name),
          _buildInfoRow(context, 'Orientation', isLandscape ? 'Landscape' : 'Portrait'),
          _buildInfoRow(context, 'Screen Width', '${MediaQuery.of(context).size.width.toInt()}px'),
          _buildInfoRow(context, 'Screen Height', '${MediaQuery.of(context).size.height.toInt()}px'),
          _buildInfoRow(context, 'Device Type', _getDeviceType(screenSize)),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveText(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
          ResponsiveText(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getDeviceType(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobileSmall:
      case ScreenSize.mobileMedium:
      case ScreenSize.mobileLarge:
        return 'Mobile';
      case ScreenSize.tabletSmall:
      case ScreenSize.tabletLarge:
        return 'Tablet';
      case ScreenSize.desktopSmall:
      case ScreenSize.desktopMedium:
      case ScreenSize.desktopLarge:
        return 'Desktop';
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _showSuccessDialog();
    }
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => ResponsiveAlertDialog(
        title: 'Responsive Design Info',
        content: 'This app features comprehensive responsive design with landscape support, adaptive layouts, and professional UI components.',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: ResponsiveText(
              'OK',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => ResponsiveAlertDialog(
        title: 'Alert Dialog',
        content: 'This is a responsive alert dialog that adapts to different screen sizes and orientations.',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: ResponsiveText(
              'Cancel',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: ResponsiveText(
              'OK',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ResponsiveBottomSheet(
        title: 'Responsive Bottom Sheet',
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
          child: ResponsiveColumn(
            children: [
              ResponsiveText(
                'This is a responsive bottom sheet that adapts to different screen sizes and orientations.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
              ResponsiveButton(
                onPressed: () => Navigator.of(context).pop(),
                child: ResponsiveText(
                  'Close',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => ResponsiveAlertDialog(
        title: 'Success!',
        content: 'Form submitted successfully. The responsive design is working perfectly!',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: ResponsiveText(
              'OK',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
