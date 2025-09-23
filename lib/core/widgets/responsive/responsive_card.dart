import 'package:flutter/material.dart';
import '../../responsive/breakpoints.dart';
import '../../responsive/responsive_utils.dart';

/// A responsive card widget that adapts its layout based on screen size and orientation
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;
  final bool enableLandscapeLayout;
  
  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.shadow,
    this.enableLandscapeLayout = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return Container(
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      child: Card(
        color: color,
        elevation: elevation ?? _getResponsiveElevation(screenSize, isLandscape),
        shadowColor: shadow?.color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12),
          ),
        ),
        child: Container(
          padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
          child: enableLandscapeLayout && isLandscape
              ? _buildLandscapeLayout(context)
              : child,
        ),
      ),
    );
  }
  
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: child,
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        Expanded(
          flex: 1,
          child: _buildLandscapeSideContent(context),
        ),
      ],
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
          size: ResponsiveUtils.getResponsiveFontSize(context, 24),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
  
  double _getResponsiveElevation(ScreenSize screenSize, bool isLandscape) {
    if (isLandscape) return 2.0;
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return 1.0;
      case ScreenSize.mobileMedium:
        return 2.0;
      case ScreenSize.mobileLarge:
        return 3.0;
      case ScreenSize.tabletSmall:
        return 4.0;
      case ScreenSize.tabletLarge:
        return 5.0;
      case ScreenSize.desktopSmall:
        return 6.0;
      case ScreenSize.desktopMedium:
        return 7.0;
      case ScreenSize.desktopLarge:
        return 8.0;
    }
  }
}
