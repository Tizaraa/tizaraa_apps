import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedEcommerceHeader extends StatefulWidget {
  final String title;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onMenuTap;
  final int cartItemCount;

  const AnimatedEcommerceHeader({
    Key? key,
    this.title = "Tizaraa",
    this.onSearchTap,
    this.onCartTap,
    this.onMenuTap,
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  _AnimatedEcommerceHeaderState createState() => _AnimatedEcommerceHeaderState();
}

class _AnimatedEcommerceHeaderState extends State<AnimatedEcommerceHeader>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        height: 80 + MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A237E), // Deep indigo
              const Color(0xFF283593),
              const Color(0xFF303F9F),
              const Color(0xFF3949AB),
              const Color(0xFF3F51B5), // Indigo
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Subtle background animations
              _buildBackgroundAnimations(),

              // Main app bar content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _isSearchExpanded
                    ? _buildMainAppBar()
                    : _buildMainAppBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundAnimations() {
    return Stack(
      children: [
        // Subtle animated elements
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Positioned(
              top: -20,
              right: -10,
              child: Transform.rotate(
                angle: _shimmerController.value * 2 * pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Positioned(
              bottom: 10 + (_floatingController.value * 5),
              left: 40,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: widget.onMenuTap,
        ),

        // Brand name with subtle animation
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.02),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white,
                        Colors.white.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(_shimmerController.value * 0.1),
                    ).createShader(bounds),
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          "Shop • Save • Smile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Action buttons
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.message, color: Colors.white),
              onPressed: _toggleSearch,
            ),
            IconButton(
              icon: const Icon(Icons.notification_add, color: Colors.white),
              onPressed: _toggleSearch,
            ),

          ],
        ),
      ],
    );
  }
}