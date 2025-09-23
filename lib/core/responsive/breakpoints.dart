/// Breakpoint definitions for responsive design
class Breakpoints {
  // Mobile breakpoints
  static const double mobileSmall = 320;
  static const double mobileMedium = 375;
  static const double mobileLarge = 414;
  
  // Tablet breakpoints
  static const double tabletSmall = 768;
  static const double tabletLarge = 1024;
  
  // Desktop breakpoints
  static const double desktopSmall = 1200;
  static const double desktopMedium = 1440;
  static const double desktopLarge = 1920;
  
  // Landscape specific breakpoints
  static const double landscapeMobile = 667; // iPhone landscape
  static const double landscapeTablet = 1024; // iPad landscape
}

/// Screen size categories
enum ScreenSize {
  mobileSmall,
  mobileMedium,
  mobileLarge,
  tabletSmall,
  tabletLarge,
  desktopSmall,
  desktopMedium,
  desktopLarge,
}

/// Device orientation
enum ResponsiveOrientation {
  portrait,
  landscape,
}

/// Responsive breakpoint helper
class ResponsiveBreakpoint {
  static ScreenSize getScreenSize(double width) {
    if (width < Breakpoints.mobileMedium) {
      return ScreenSize.mobileSmall;
    } else if (width < Breakpoints.mobileLarge) {
      return ScreenSize.mobileMedium;
    } else if (width < Breakpoints.tabletSmall) {
      return ScreenSize.mobileLarge;
    } else if (width < Breakpoints.tabletLarge) {
      return ScreenSize.tabletSmall;
    } else if (width < Breakpoints.desktopSmall) {
      return ScreenSize.tabletLarge;
    } else if (width < Breakpoints.desktopMedium) {
      return ScreenSize.desktopSmall;
    } else if (width < Breakpoints.desktopLarge) {
      return ScreenSize.desktopMedium;
    } else {
      return ScreenSize.desktopLarge;
    }
  }
  
  static bool isMobile(double width) {
    return width < Breakpoints.tabletSmall;
  }
  
  static bool isTablet(double width) {
    return width >= Breakpoints.tabletSmall && width < Breakpoints.desktopSmall;
  }
  
  static bool isDesktop(double width) {
    return width >= Breakpoints.desktopSmall;
  }
  
  static bool isLandscape(double width, double height) {
    return width > height;
  }
  
  static bool isPortrait(double width, double height) {
    return height > width;
  }
}
