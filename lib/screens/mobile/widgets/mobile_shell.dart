import 'dart:ui';

import 'package:athlete_hub/helpers/imports.dart';

class MobileGlowScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final bool useSafeArea;
  final Color? backgroundColor;

  const MobileGlowScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? const Color(0xFF030817),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF06142B),
                  Color(0xFF081B3E),
                  Color(0xFF020612),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: -120,
          left: -50,
          child: _GlowOrb(size: 240, color: Color(0xAA3B82F6)),
        ),
        const Positioned(
          top: 90,
          right: -90,
          child: _GlowOrb(size: 220, color: Color(0x6622D3EE)),
        ),
        const Positioned(
          bottom: -120,
          left: -80,
          child: _GlowOrb(size: 260, color: Color(0x5522D3EE)),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF10C9F5).withAlpha(46),
                  Colors.transparent,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(child: useSafeArea ? SafeArea(child: child) : child),
      ],
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

class MobilePageScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const MobilePageScrollView({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 20, 18, 120),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: padding, child: child);
  }
}

class MobilePageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget? bottom;

  const MobilePageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MobileGlassCard(
      borderRadius: BorderRadius.circular(30),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(179),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 14), trailing!],
            ],
          ),
          if (bottom != null) ...[const SizedBox(height: 18), bottom!],
        ],
      ),
    );
  }
}

class MobileTopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const MobileTopIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x55148CFF),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class MobileSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const MobileSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.black.withAlpha(20),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withAlpha(117)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF7DEBFF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class MobileInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MobileInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF6EE7FF).withAlpha(31),
          ),
          child: Icon(icon, color: const Color(0xFF7DEBFF)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(173),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ] else if (onTap != null) ...[
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ],
    );

    return MobileGlassCard(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(16),
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onTap,
              child: content,
            ),
    );
  }
}

class MobileScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const MobileScreenAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.chevron_left, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }
}

class MobileGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;

  const MobileGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(36), Colors.white.withAlpha(15)],
        ),
        border: Border.all(color: Colors.white.withAlpha(36)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(18),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MobileSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const MobileSectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(179),
            ),
          ),
        ],
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withAlpha(0)]),
        ),
      ),
    );
  }
}
