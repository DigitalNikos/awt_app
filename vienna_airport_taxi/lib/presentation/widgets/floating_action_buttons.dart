// lib/presentation/widgets/floating_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/to_airport_screen.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/from_airport/from_airport_screen.dart';

class FloatingActionButtons extends StatefulWidget {
  final bool isVisible;

  const FloatingActionButtons({
    super.key,
    required this.isVisible,
  });

  @override
  State<FloatingActionButtons> createState() => _FloatingActionButtonsState();
}

class _FloatingActionButtonsState extends State<FloatingActionButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(FloatingActionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.only(
                right: 20,
                bottom: 100, // Space above bottom nav
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // To Airport Button (top)
                  _RoundFloatingButton(
                    svgAsset:
                        'assets/images/hero_section/to-aiport-floating.svg',
                    isRotated: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ToAirportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // From Airport Button (bottom)
                  _RoundFloatingButton(
                    svgAsset:
                        'assets/images/hero_section/to-aiport-floating.svg',
                    isRotated: true, // Rotate this one 180 degrees
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FromAirportScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoundFloatingButton extends StatefulWidget {
  final String svgAsset;
  final bool isRotated;
  final VoidCallback onPressed;

  const _RoundFloatingButton({
    required this.svgAsset,
    required this.isRotated,
    required this.onPressed,
  });

  @override
  State<_RoundFloatingButton> createState() => _RoundFloatingButtonState();
}

class _RoundFloatingButtonState extends State<_RoundFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              elevation: _isPressed ? 8 : 6,
              shape: const CircleBorder(),
              shadowColor: Colors.black.withValues(alpha: 0.3),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(
                    color: _isPressed
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: widget.isRotated
                        ? 0.84159
                        : 0, // 180 degrees in radians
                    child: SvgPicture.asset(
                      widget.svgAsset,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      // colorFilter: const ColorFilter.mode(
                      //   Colors.black,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
