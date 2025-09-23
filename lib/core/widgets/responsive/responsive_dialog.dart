import 'package:flutter/material.dart';
import '../../responsive/responsive_utils.dart';
import '../../responsive/responsive_widget.dart';

/// A responsive dialog that adapts its size and layout based on screen size and orientation
class ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? backgroundColor;
  final EdgeInsets? insetPadding;
  final double? maxWidth;
  final double? maxHeight;
  
  const ResponsiveDialog({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.barrierDismissible = true,
    this.backgroundColor,
    this.insetPadding,
    this.maxWidth,
    this.maxHeight,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: insetPadding ?? _getResponsiveInsetPadding(context, isLandscape),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? _getResponsiveMaxWidth(context, isLandscape),
          maxHeight: maxHeight ?? _getResponsiveMaxHeight(context, isLandscape),
        ),
        child: _buildDialogContent(context, isLandscape),
      ),
    );
  }
  
  Widget _buildDialogContent(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return _buildLandscapeDialog(context);
    } else {
      return _buildPortraitDialog(context);
    }
  }
  
  Widget _buildPortraitDialog(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) _buildDialogTitle(context),
        Flexible(child: child),
        if (actions != null) _buildDialogActions(context),
      ],
    );
  }
  
  Widget _buildLandscapeDialog(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) _buildDialogTitle(context),
              Flexible(child: child),
              if (actions != null) _buildDialogActions(context),
            ],
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        Expanded(
          flex: 1,
          child: _buildLandscapeSideContent(context),
        ),
      ],
    );
  }
  
  Widget _buildDialogTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
          topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
        ),
      ),
      child: ResponsiveText(
        title!,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Widget _buildDialogActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
      child: ResponsiveRow(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      ),
    );
  }
  
  Widget _buildLandscapeSideContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 8),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.info_outline,
          size: ResponsiveUtils.getResponsiveFontSize(context, 32),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
  
  EdgeInsets _getResponsiveInsetPadding(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.height * 0.05,
      );
    }
    
    return EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.getResponsiveSpacing(context, 24),
      vertical: ResponsiveUtils.getResponsiveSpacing(context, 48),
    );
  }
  
  double _getResponsiveMaxWidth(BuildContext context, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isLandscape) {
      return screenWidth * 0.6;
    }
    
    return screenWidth * 0.9;
  }
  
  double _getResponsiveMaxHeight(BuildContext context, bool isLandscape) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (isLandscape) {
      return screenHeight * 0.8;
    }
    
    return screenHeight * 0.7;
  }
}

/// A responsive alert dialog
class ResponsiveAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? backgroundColor;
  
  const ResponsiveAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.barrierDismissible = true,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: title,
      actions: actions,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      child: content != null
          ? Padding(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
              child: ResponsiveText(
                content!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                ),
                textAlign: TextAlign.center,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// A responsive bottom sheet
class ResponsiveBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool isScrollControlled;
  final bool enableDrag;
  final Color? backgroundColor;
  final double? maxHeight;
  
  const ResponsiveBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.isScrollControlled = true,
    this.enableDrag = true,
    this.backgroundColor,
    this.maxHeight,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? _getResponsiveMaxHeight(context, isLandscape),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) _buildBottomSheetTitle(context),
          Flexible(child: child),
        ],
      ),
    );
  }
  
  Widget _buildBottomSheetTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
          topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
        ),
      ),
      child: ResponsiveText(
        title!,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  double _getResponsiveMaxHeight(BuildContext context, bool isLandscape) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (isLandscape) {
      return screenHeight * 0.9;
    }
    
    return screenHeight * 0.8;
  }
}
