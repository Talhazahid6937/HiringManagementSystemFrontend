// auth_layout.dart
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String? desktopTitle;
  final String? desktopSubtitle;
  final double? containerMaxWidth;
  final double? containerMinHeight;
  final EdgeInsetsGeometry? containerPadding;
  final Widget? customIcon;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthLayout({
    super.key,
    required this.child,
    this.desktopTitle,
    this.desktopSubtitle,
    this.containerMaxWidth = 450,
    this.containerMinHeight = 500,
    this.containerPadding,
    this.customIcon,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;
    final isMobile = screenSize.width < 480;
    final isTablet = screenSize.width >= 480 && screenSize.width <= 768;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            if (showBackButton)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                child: IconButton(
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1F2937),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: const Color(0xFF1F2937),
                  ),
                ),
              ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile
                        ? 24
                        : isTablet
                            ? 32
                            : 48,
                    vertical: 24,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isDesktop &&
                          (desktopTitle != null ||
                              desktopSubtitle != null)) ...[
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (desktopTitle != null)
                                  Text(
                                    desktopTitle!,
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                if (desktopTitle != null &&
                                    desktopSubtitle != null)
                                  const SizedBox(height: 16),
                                if (desktopSubtitle != null)
                                  Text(
                                    desktopSubtitle!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF6B7280),
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                      Expanded(
                        flex: isDesktop ? 1 : 1,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: containerMaxWidth!,
                            minHeight: containerMinHeight!,
                          ),
                          padding: containerPadding ??
                              EdgeInsets.symmetric(
                                horizontal: isMobile ? 24 : 32,
                                vertical: 50,
                              ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(43),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  (0.1 * 255).toInt(),
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      ),
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
}
