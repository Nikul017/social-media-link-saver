import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_saver/core/theme/theme_provider.dart';

class BrutalistPress extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? shadowColor;
  final Offset shadowOffset;
  final bool isCard;
  final EdgeInsetsGeometry padding;
  final double scaleDownTo;
  final Duration duration;

  const BrutalistPress({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius = 12.0,
    this.shadowColor,
    this.shadowOffset = const Offset(3.0, 3.0),
    this.isCard = false,
    this.padding = EdgeInsets.zero,
    this.scaleDownTo = 0.96,
    this.duration = const Duration(milliseconds: 80),
  });

  @override
  ConsumerState<BrutalistPress> createState() => _BrutalistPressState();
}

class _BrutalistPressState extends ConsumerState<BrutalistPress> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 380),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      HapticFeedback.lightImpact();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return _buildRawStyleWidget(context, progress: 0.0);
    }

    final themeStyle = ref.watch(themeStyleNotifierProvider);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = _animation.value;
          
          if (themeStyle == ThemeStyle.classic) {
            final scale = 1.0 - (progress * (1.0 - widget.scaleDownTo));
            return Transform.scale(
              scale: scale,
              child: _buildRawStyleWidget(context, progress: progress),
            );
          } else {
            final translateOffset = Offset(
              widget.shadowOffset.dx * progress,
              widget.shadowOffset.dy * progress,
            );
            return Transform.translate(
              offset: translateOffset,
              child: _buildRawStyleWidget(context, progress: progress),
            );
          }
        },
      ),
    );
  }

  Widget _buildRawStyleWidget(BuildContext context, {required double progress}) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);

    if (themeStyle == ThemeStyle.classic || !widget.isCard) {
      return Padding(
        padding: widget.padding,
        child: widget.child,
      );
    }

    final isDark = theme.brightness == Brightness.dark;
    final bg = widget.backgroundColor ?? (isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface);
    final borderCol = widget.borderColor ?? theme.colorScheme.outline;
    final shCol = widget.shadowColor ?? (isDark ? Colors.white.withOpacity(0.15) : Colors.black);

    final currentShadowOffset = Offset(
      widget.shadowOffset.dx * (1.0 - progress),
      widget.shadowOffset.dy * (1.0 - progress),
    );

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: borderCol, width: widget.borderWidth),
        boxShadow: [
          if (currentShadowOffset != Offset.zero)
            BoxShadow(
              color: shCol,
              offset: currentShadowOffset,
              blurRadius: 0,
            ),
        ],
      ),
      child: widget.child,
    );
  }
}
