import 'package:flutter/material.dart';
import '../../responsive/breakpoints.dart';
import '../../responsive/responsive_utils.dart';
import '../../responsive/responsive_widget.dart';

/// A responsive form field that adapts its layout based on screen size and orientation
class ResponsiveFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final InputDecoration? decoration;
  final TextStyle? style;
  final EdgeInsets? contentPadding;
  final double? borderRadius;
  
  const ResponsiveFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.decoration,
    this.style,
    this.contentPadding,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) _buildLabel(context),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
        _buildTextField(context, isLandscape, screenSize),
        if (helperText != null) _buildHelperText(context),
        if (errorText != null) _buildErrorText(context),
      ],
    );
  }
  
  Widget _buildLabel(BuildContext context) {
    return ResponsiveText(
      labelText!,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
      ),
    );
  }
  
  Widget _buildTextField(BuildContext context, bool isLandscape, ScreenSize screenSize) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      style: style ?? TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
      ),
      decoration: decoration ?? _buildDefaultDecoration(context, isLandscape),
    );
  }
  
  InputDecoration _buildDefaultDecoration(BuildContext context, bool isLandscape) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
      contentPadding: contentPadding ?? EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      errorText: errorText,
    );
  }
  
  Widget _buildHelperText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      child: ResponsiveText(
        helperText!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
        ),
      ),
    );
  }
  
  Widget _buildErrorText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      child: ResponsiveText(
        errorText!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
        ),
      ),
    );
  }
}

/// A responsive form that adapts its layout based on screen size and orientation
class ResponsiveForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final List<Widget> children;
  final bool enableLandscapeLayout;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  
  const ResponsiveForm({
    super.key,
    this.formKey,
    required this.children,
    this.enableLandscapeLayout = true,
    this.padding,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    
    return Container(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      child: Form(
        key: formKey,
        child: enableLandscapeLayout && isLandscape
            ? _buildLandscapeLayout(context)
            : _buildPortraitLayout(context),
      ),
    );
  }
  
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ResponsiveColumn(
            children: children,
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 24)),
        Expanded(
          flex: 1,
          child: _buildLandscapeSideContent(context),
        ),
      ],
    );
  }
  
  Widget _buildPortraitLayout(BuildContext context) {
    return ResponsiveColumn(
      children: children,
    );
  }
  
  Widget _buildLandscapeSideContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: ResponsiveUtils.getResponsiveFontSize(context, 32),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          ResponsiveText(
            'Form Tips',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          ResponsiveText(
            'Fill in all required fields to continue',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
