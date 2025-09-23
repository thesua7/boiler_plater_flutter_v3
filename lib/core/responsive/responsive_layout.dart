import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'responsive_utils.dart';
import 'responsive_widget.dart';

/// A responsive layout wrapper that handles orientation changes and screen size adaptations
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool enableOrientationLock;
  final List<ResponsiveOrientation> supportedOrientations;
  final Widget? loadingWidget;
  final bool showLandscapeSidePanels;
  
  const ResponsiveLayout({
    super.key,
    required this.child,
    this.enableOrientationLock = false,
    this.supportedOrientations = const [
      ResponsiveOrientation.portrait,
      ResponsiveOrientation.landscape,
    ],
    this.loadingWidget,
    this.showLandscapeSidePanels = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return _buildResponsiveContent(context, constraints, orientation);
            },
          );
        },
      ),
    );
  }
  
  Widget _buildResponsiveContent(
    BuildContext context,
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    final size = MediaQuery.of(context).size;
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    
    // Check if current orientation is supported
    final currentOrientation = isLandscape 
        ? ResponsiveOrientation.landscape 
        : ResponsiveOrientation.portrait;
    
    if (!supportedOrientations.contains(currentOrientation)) {
      return _buildUnsupportedOrientation(context);
    }
    
    return _buildAdaptiveLayout(context, size, screenSize, isLandscape);
  }
  
  Widget _buildAdaptiveLayout(
    BuildContext context,
    Size size,
    ScreenSize screenSize,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return _buildLandscapeLayout(context, size, screenSize);
    } else {
      return _buildPortraitLayout(context, size, screenSize);
    }
  }
  
  Widget _buildLandscapeLayout(BuildContext context, Size size, ScreenSize screenSize) {
    // Landscape-specific layout adjustments
    if (showLandscapeSidePanels && (ResponsiveBreakpoint.isTablet(size.width) || ResponsiveBreakpoint.isDesktop(size.width))) {
      return Container(
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            // Left side - can be used for navigation or additional content
            Container(
              width: size.width * 0.3,
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: _buildLandscapeSideContent(context),
            ),
            
            // Main content area
            Expanded(
              child: child,
            ),
            
            // Right side - can be used for additional content
            if (ResponsiveBreakpoint.isDesktop(size.width))
              Container(
                width: size.width * 0.2,
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: _buildLandscapeSideContent(context),
              ),
          ],
        ),
      );
    } else {
      // Simple landscape layout without side panels
      return Container(
        width: size.width,
        height: size.height,
        child: child,
      );
    }
  }
  
  Widget _buildPortraitLayout(BuildContext context, Size size, ScreenSize screenSize) {
    // Portrait-specific layout adjustments
    return Container(
      width: size.width,
      height: size.height,
      child: child,
    );
  }
  
  Widget _buildLandscapeSideContent(BuildContext context) {
    // Placeholder for landscape side content
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 12),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.info_outline,
          size: ResponsiveUtils.getResponsiveFontSize(context, 24),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
  
  Widget _buildUnsupportedOrientation(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.screen_rotation,
              size: ResponsiveUtils.getResponsiveFontSize(context, 64),
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
            ResponsiveText(
              'Please rotate your device',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            ResponsiveText(
              'This app is optimized for ${supportedOrientations.map((o) => o.name).join(' and ')} orientation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A responsive scaffold that adapts its layout based on screen size and orientation
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}

/// A responsive page view that adapts its layout based on screen size
class ResponsivePageView extends StatelessWidget {
  final List<Widget> children;
  final PageController? controller;
  final bool reverse;
  final ScrollPhysics? physics;
  final int? itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  
  const ResponsivePageView({
    super.key,
    required this.children,
    this.controller,
    this.reverse = false,
    this.physics,
    this.itemCount,
    this.itemBuilder,
  });
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    if (isLandscape) {
      return _buildLandscapePageView(context);
    } else {
      return _buildPortraitPageView(context);
    }
  }
  
  Widget _buildLandscapePageView(BuildContext context) {
    return PageView.builder(
      controller: controller,
      reverse: reverse,
      physics: physics,
      itemCount: itemCount ?? children.length,
      itemBuilder: itemBuilder ?? (context, index) => children[index],
    );
  }
  
  Widget _buildPortraitPageView(BuildContext context) {
    return PageView.builder(
      controller: controller,
      reverse: reverse,
      physics: physics,
      itemCount: itemCount ?? children.length,
      itemBuilder: itemBuilder ?? (context, index) => children[index],
    );
  }
}
