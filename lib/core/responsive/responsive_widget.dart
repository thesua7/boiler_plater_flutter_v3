import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'responsive_utils.dart';

/// A responsive widget that adapts its child based on screen size and orientation
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? landscape;
  final Widget? portrait;
  
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.landscape,
    this.portrait,
  });
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    final isPortrait = ResponsiveBreakpoint.isPortrait(size.width, size.height);
    
    // Check for orientation-specific widgets first
    if (isLandscape && landscape != null) {
      return landscape!;
    }
    
    if (isPortrait && portrait != null) {
      return portrait!;
    }
    
    // Then check for device-specific widgets
    if (ResponsiveBreakpoint.isDesktop(size.width) && desktop != null) {
      return desktop!;
    }
    
    if (ResponsiveBreakpoint.isTablet(size.width) && tablet != null) {
      return tablet!;
    }
    
    return mobile;
  }
}

/// A responsive builder that provides context-aware building
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize, bool isLandscape) builder;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = ResponsiveBreakpoint.getScreenSize(size.width);
    final isLandscape = ResponsiveBreakpoint.isLandscape(size.width, size.height);
    
    return builder(context, screenSize, isLandscape);
  }
}

/// A responsive container that adapts its properties based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final BoxDecoration? decoration;
  final AlignmentGeometry? alignment;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.alignment,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? ResponsiveUtils.getResponsivePadding(context);
    final responsiveMargin = margin ?? ResponsiveUtils.getResponsiveMargin(context);
    final responsiveWidth = width != null ? ResponsiveUtils.getResponsiveWidth(context, width!) : null;
    final responsiveHeight = height != null ? ResponsiveUtils.getResponsiveHeight(context, height!) : null;
    
    return Container(
      padding: responsivePadding,
      margin: responsiveMargin,
      width: responsiveWidth,
      height: responsiveHeight,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}

/// A responsive column that adapts its spacing based on screen size
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? spacing;
  
  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = spacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16);
    
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildrenWithSpacing(context, responsiveSpacing),
    );
  }
  
  List<Widget> _buildChildrenWithSpacing(BuildContext context, double spacing) {
    if (children.isEmpty) return [];
    
    final List<Widget> spacedChildren = [children.first];
    
    for (int i = 1; i < children.length; i++) {
      spacedChildren.add(SizedBox(height: spacing));
      spacedChildren.add(children[i]);
    }
    
    return spacedChildren;
  }
}

/// A responsive row that adapts its spacing based on screen size
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? spacing;
  
  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = spacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16);
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildrenWithSpacing(context, responsiveSpacing),
    );
  }
  
  List<Widget> _buildChildrenWithSpacing(BuildContext context, double spacing) {
    if (children.isEmpty) return [];
    
    final List<Widget> spacedChildren = [children.first];
    
    for (int i = 1; i < children.length; i++) {
      spacedChildren.add(SizedBox(width: spacing));
      spacedChildren.add(children[i]);
    }
    
    return spacedChildren;
  }
}

/// A responsive text widget that adapts its style based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });
  
  @override
  Widget build(BuildContext context) {
    final baseFontSize = style?.fontSize ?? 14.0;
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(context, baseFontSize);
    
    final responsiveStyle = style?.copyWith(fontSize: responsiveFontSize) ?? 
        TextStyle(fontSize: responsiveFontSize);
    
    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A responsive button that adapts its size based on screen size
class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final double? minHeight;
  
  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.padding,
    this.minWidth,
    this.minHeight,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.getResponsiveSpacing(context, 24),
      vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
    );
    
    final responsiveMinWidth = minWidth ?? ResponsiveUtils.getResponsiveWidth(context, 200);
    final responsiveMinHeight = minHeight ?? ResponsiveUtils.getResponsiveSpacing(context, 48);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: style?.copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(responsiveMinWidth, responsiveMinHeight),
        ),
        padding: WidgetStateProperty.all(responsivePadding),
      ) ?? ElevatedButton.styleFrom(
        minimumSize: Size(responsiveMinWidth, responsiveMinHeight),
        padding: responsivePadding,
      ),
      child: child,
    );
  }
}
