import 'package:flutter/material.dart';
import 'breakpoints.dart';
import '../constants/sizes.dart';

/// Responsive utility class for handling different screen sizes and orientations
class ResponsiveUtils {
  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    if (isLandscape) {
      return EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      );
    }
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return const EdgeInsets.all(Sizes.paddingSm);
      case ScreenSize.mobileMedium:
        return const EdgeInsets.all(Sizes.paddingSm);
      case ScreenSize.mobileLarge:
        return const EdgeInsets.all(Sizes.paddingMd);
      case ScreenSize.tabletSmall:
        return const EdgeInsets.all(Sizes.paddingMd);
      case ScreenSize.tabletLarge:
        return const EdgeInsets.all(Sizes.paddingLg);
      case ScreenSize.desktopSmall:
        return const EdgeInsets.all(Sizes.paddingLg);
      case ScreenSize.desktopMedium:
        return const EdgeInsets.all(Sizes.paddingXl);
      case ScreenSize.desktopLarge:
        return const EdgeInsets.all(Sizes.paddingXl);
    }
  }
  
  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    if (isLandscape) {
      return EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      );
    }
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return const EdgeInsets.all(Sizes.paddingSm);
      case ScreenSize.mobileMedium:
        return const EdgeInsets.all(Sizes.paddingMd);
      case ScreenSize.mobileLarge:
        return const EdgeInsets.all(Sizes.paddingMd);
      case ScreenSize.tabletSmall:
        return const EdgeInsets.all(Sizes.paddingLg);
      case ScreenSize.tabletLarge:
        return const EdgeInsets.all(Sizes.paddingLg);
      case ScreenSize.desktopSmall:
        return const EdgeInsets.all(Sizes.paddingXl);
      case ScreenSize.desktopMedium:
        return const EdgeInsets.all(Sizes.paddingXl);
      case ScreenSize.desktopLarge:
        return const EdgeInsets.all(Sizes.paddingXl);
    }
  }
  
  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    double multiplier = 1.0;
    
    if (isLandscape) {
      multiplier = 0.9; // Slightly smaller fonts in landscape
    } else {
      switch (screenSize) {
        case ScreenSize.mobileSmall:
          multiplier = 0.85;
          break;
        case ScreenSize.mobileMedium:
          multiplier = 0.9;
          break;
        case ScreenSize.mobileLarge:
          multiplier = 1.0;
          break;
        case ScreenSize.tabletSmall:
          multiplier = 1.1;
          break;
        case ScreenSize.tabletLarge:
          multiplier = 1.2;
          break;
        case ScreenSize.desktopSmall:
          multiplier = 1.3;
          break;
        case ScreenSize.desktopMedium:
          multiplier = 1.4;
          break;
        case ScreenSize.desktopLarge:
          multiplier = 1.5;
          break;
      }
    }
    
    return baseFontSize * multiplier;
  }
  
  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    double multiplier = 1.0;
    
    if (isLandscape) {
      multiplier = 0.8; // Tighter spacing in landscape
    } else {
      switch (screenSize) {
        case ScreenSize.mobileSmall:
          multiplier = 0.8;
          break;
        case ScreenSize.mobileMedium:
          multiplier = 0.9;
          break;
        case ScreenSize.mobileLarge:
          multiplier = 1.0;
          break;
        case ScreenSize.tabletSmall:
          multiplier = 1.2;
          break;
        case ScreenSize.tabletLarge:
          multiplier = 1.4;
          break;
        case ScreenSize.desktopSmall:
          multiplier = 1.6;
          break;
        case ScreenSize.desktopMedium:
          multiplier = 1.8;
          break;
        case ScreenSize.desktopLarge:
          multiplier = 2.0;
          break;
      }
    }
    
    return baseSpacing * multiplier;
  }
  
  /// Get responsive width based on screen size
  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    if (isLandscape) {
      return size.width * 0.4; // Use 40% of screen width in landscape
    }
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return size.width * 0.9;
      case ScreenSize.mobileMedium:
        return size.width * 0.85;
      case ScreenSize.mobileLarge:
        return size.width * 0.8;
      case ScreenSize.tabletSmall:
        return size.width * 0.6;
      case ScreenSize.tabletLarge:
        return size.width * 0.5;
      case ScreenSize.desktopSmall:
        return size.width * 0.4;
      case ScreenSize.desktopMedium:
        return size.width * 0.35;
      case ScreenSize.desktopLarge:
        return size.width * 0.3;
    }
  }
  
  /// Get responsive height based on screen size
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    if (isLandscape) {
      return size.height * 0.8; // Use 80% of screen height in landscape
    }
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return size.height * 0.7;
      case ScreenSize.mobileMedium:
        return size.height * 0.75;
      case ScreenSize.mobileLarge:
        return size.height * 0.8;
      case ScreenSize.tabletSmall:
        return size.height * 0.85;
      case ScreenSize.tabletLarge:
        return size.height * 0.9;
      case ScreenSize.desktopSmall:
        return size.height * 0.95;
      case ScreenSize.desktopMedium:
        return size.height * 0.95;
      case ScreenSize.desktopLarge:
        return size.height * 0.95;
    }
  }
  
  /// Check if current screen is in landscape mode
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBreakpoint.isLandscape(size.width, size.height);
  }
  
  /// Check if current screen is in portrait mode
  static bool isPortrait(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBreakpoint.isPortrait(size.width, size.height);
  }
  
  /// Get current screen size category
  static ScreenSize getCurrentScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBreakpoint.getScreenSize(size.width);
  }
  
  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    double multiplier = 1.0;
    
    if (isLandscape) {
      multiplier = 0.8;
    } else {
      switch (screenSize) {
        case ScreenSize.mobileSmall:
          multiplier = 0.8;
          break;
        case ScreenSize.mobileMedium:
          multiplier = 0.9;
          break;
        case ScreenSize.mobileLarge:
          multiplier = 1.0;
          break;
        case ScreenSize.tabletSmall:
          multiplier = 1.1;
          break;
        case ScreenSize.tabletLarge:
          multiplier = 1.2;
          break;
        case ScreenSize.desktopSmall:
          multiplier = 1.3;
          break;
        case ScreenSize.desktopMedium:
          multiplier = 1.4;
          break;
        case ScreenSize.desktopLarge:
          multiplier = 1.5;
          break;
      }
    }
    
    return baseRadius * multiplier;
  }
  
  /// Get responsive border radius using core sizes
  static double getResponsiveBorderRadiusFromSize(BuildContext context, double sizeType) {
    double baseRadius;
    
    switch (sizeType) {
      case Sizes.borderRadiusSm:
        baseRadius = Sizes.borderRadiusSm;
        break;
      case Sizes.borderRadiusMd:
        baseRadius = Sizes.borderRadiusMd;
        break;
      case Sizes.borderRadiusLg:
        baseRadius = Sizes.borderRadiusLg;
        break;
      default:
        baseRadius = Sizes.borderRadiusMd;
    }
    
    return getResponsiveBorderRadius(context, baseRadius);
  }
}
