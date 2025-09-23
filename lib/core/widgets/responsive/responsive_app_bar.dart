import 'package:flutter/material.dart';
import '../../responsive/breakpoints.dart';
import '../../responsive/responsive_utils.dart';
import '../../responsive/responsive_widget.dart';

/// A responsive app bar that adapts its layout based on screen size and orientation
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final double? titleSpacing;
  final double? leadingWidth;
  final PreferredSizeWidget? bottom;
  final bool enableLandscapeLayout;
  
  const ResponsiveAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.titleSpacing,
    this.leadingWidth,
    this.bottom,
    this.enableLandscapeLayout = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return AppBar(
      title: titleWidget ?? (title != null ? _buildResponsiveTitle(context, isLandscape) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? _getResponsiveElevation(screenSize, isLandscape),
      centerTitle: centerTitle,
      titleSpacing: titleSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16),
      leadingWidth: leadingWidth ?? ResponsiveUtils.getResponsiveSpacing(context, 56),
      bottom: bottom,
      toolbarHeight: _getResponsiveToolbarHeight(context, isLandscape),
    );
  }
  
  Widget _buildResponsiveTitle(BuildContext context, bool isLandscape) {
    return ResponsiveText(
      title!,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  double _getResponsiveElevation(ScreenSize screenSize, bool isLandscape) {
    if (isLandscape) return 1.0;
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return 2.0;
      case ScreenSize.mobileMedium:
        return 3.0;
      case ScreenSize.mobileLarge:
        return 4.0;
      case ScreenSize.tabletSmall:
        return 5.0;
      case ScreenSize.tabletLarge:
        return 6.0;
      case ScreenSize.desktopSmall:
        return 7.0;
      case ScreenSize.desktopMedium:
        return 8.0;
      case ScreenSize.desktopLarge:
        return 9.0;
    }
  }
  
  double _getResponsiveToolbarHeight(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return ResponsiveUtils.getResponsiveSpacing(context, 48);
    }
    
    return ResponsiveUtils.getResponsiveSpacing(context, 56);
  }
  
  @override
  Size get preferredSize {
    // Return a default height since we can't access context here
    // The actual height will be set in the build() method
    return const Size.fromHeight(56.0);
  }
}

/// A responsive bottom app bar that adapts its layout based on screen size and orientation
class ResponsiveBottomAppBar extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final double? elevation;
  final bool enableLandscapeLayout;
  
  const ResponsiveBottomAppBar({
    super.key,
    required this.children,
    this.color,
    this.elevation,
    this.enableLandscapeLayout = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return BottomAppBar(
      color: color,
      elevation: elevation ?? _getResponsiveElevation(screenSize, isLandscape),
      height: _getResponsiveHeight(context, isLandscape),
      child: enableLandscapeLayout && isLandscape
          ? _buildLandscapeLayout(context)
          : _buildPortraitLayout(context),
    );
  }
  
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }
  
  Widget _buildPortraitLayout(BuildContext context) {
    return ResponsiveRow(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }
  
  double _getResponsiveElevation(ScreenSize screenSize, bool isLandscape) {
    if (isLandscape) return 1.0;
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return 2.0;
      case ScreenSize.mobileMedium:
        return 3.0;
      case ScreenSize.mobileLarge:
        return 4.0;
      case ScreenSize.tabletSmall:
        return 5.0;
      case ScreenSize.tabletLarge:
        return 6.0;
      case ScreenSize.desktopSmall:
        return 7.0;
      case ScreenSize.desktopMedium:
        return 8.0;
      case ScreenSize.desktopLarge:
        return 9.0;
    }
  }
  
  double _getResponsiveHeight(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return ResponsiveUtils.getResponsiveSpacing(context, 48);
    }
    
    return ResponsiveUtils.getResponsiveSpacing(context, 64);
  }
}

/// A responsive navigation bar that adapts its layout based on screen size and orientation
class ResponsiveNavigationBar extends StatelessWidget {
  final List<ResponsiveNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Color? backgroundColor;
  final double? elevation;
  final bool enableLandscapeLayout;
  
  const ResponsiveNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.enableLandscapeLayout = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final screenSize = ResponsiveUtils.getCurrentScreenSize(context);
    
    return NavigationBar(
      destinations: destinations.map((dest) => dest.toNavigationDestination(context)).toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor,
      elevation: elevation ?? _getResponsiveElevation(screenSize, isLandscape),
      height: _getResponsiveHeight(context, isLandscape),
    );
  }
  
  double _getResponsiveElevation(ScreenSize screenSize, bool isLandscape) {
    if (isLandscape) return 1.0;
    
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return 2.0;
      case ScreenSize.mobileMedium:
        return 3.0;
      case ScreenSize.mobileLarge:
        return 4.0;
      case ScreenSize.tabletSmall:
        return 5.0;
      case ScreenSize.tabletLarge:
        return 6.0;
      case ScreenSize.desktopSmall:
        return 7.0;
      case ScreenSize.desktopMedium:
        return 8.0;
      case ScreenSize.desktopLarge:
        return 9.0;
    }
  }
  
  double _getResponsiveHeight(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return ResponsiveUtils.getResponsiveSpacing(context, 48);
    }
    
    return ResponsiveUtils.getResponsiveSpacing(context, 64);
  }
}

/// A responsive navigation destination that adapts its icon and label based on screen size
class ResponsiveNavigationDestination {
  final IconData icon;
  final String label;
  final Widget? selectedIcon;
  final bool enableLandscapeLayout;
  
  const ResponsiveNavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.enableLandscapeLayout = true,
  });
  
  NavigationDestination toNavigationDestination(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    
    return NavigationDestination(
      icon: Icon(
        icon,
        size: ResponsiveUtils.getResponsiveFontSize(context, 24),
      ),
      selectedIcon: selectedIcon ?? Icon(
        icon,
        size: ResponsiveUtils.getResponsiveFontSize(context, 24),
      ),
      label: enableLandscapeLayout && isLandscape ? '' : label,
    );
  }
}
