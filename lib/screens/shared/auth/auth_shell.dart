import 'package:athlete_hub/helpers/imports.dart';

class AuthShell extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final double maxWidth;

  const AuthShell({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    this.maxWidth = 430,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < DeviceSizes.mobileSize;

    if (isMobile) {
      return _MobileAuthShell(
        eyebrow: eyebrow,
        title: title,
        subtitle: subtitle,
        maxWidth: maxWidth,
        child: child,
      );
    }

    return _DesktopAuthShell(
      eyebrow: eyebrow,
      title: title,
      subtitle: subtitle,
      maxWidth: maxWidth,
      child: child,
    );
  }
}

class _DesktopAuthShell extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final double maxWidth;

  const _DesktopAuthShell({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7DB4FF), Color(0xFFA9D0FF), Color(0xFFF1F7FF)],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -40,
              child: _GlowBubble(size: 220, color: Colors.white.withAlpha(70)),
            ),
            Positioned(
              bottom: -90,
              left: -50,
              child: _GlowBubble(
                size: 260,
                color: theme.colorScheme.primary.withAlpha(35),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _BrandHeader(),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 6,
                          shadowColor: const Color(0x220F172A),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  eyebrow,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(height: 1.15),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                child,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _MobileAuthShell extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final double maxWidth;

  const _MobileAuthShell({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MobileGlowScaffold(
      useSafeArea: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _MobileBrandHeader(),
                  const SizedBox(height: 22),
                  MobileGlassCard(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AuthEyebrow(text: eyebrow),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(189),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        child,
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _MobileInfoStrip(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 108,
          height: 108,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A0F172A),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Image.asset(Images.logo2, fit: BoxFit.contain),
        ),
        const SizedBox(height: 16),
        Text(
          'Athlete Hub',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Performance, health and athlete progress in one place.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}

class _MobileBrandHeader extends StatelessWidget {
  const _MobileBrandHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 58,
              height: 58,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF163C80), Color(0xFF0A1E47)],
                ),
                border: Border.all(color: Colors.white.withAlpha(41)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(Images.logo2, fit: BoxFit.contain),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Athlete Hub',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Performance and health, beautifully organized.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(173),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x261EC7FF), Color(0x121C3D72)],
            ),
            border: Border.all(color: Colors.white.withAlpha(26)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _HighlightStat(
                  value: '24/7',
                  label: 'Access to athlete records',
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: Colors.white.withAlpha(31),
              ),
              Expanded(
                child: _HighlightStat(
                  value: 'Live',
                  label: 'Metrics and progress snapshots',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightStat extends StatelessWidget {
  final String value;
  final String label;

  const _HighlightStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(173),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthEyebrow extends StatelessWidget {
  final String text;

  const _AuthEyebrow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0x331EC7FF),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF86E6FF),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MobileInfoStrip extends StatelessWidget {
  const _MobileInfoStrip();

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Smart Tracking', Icons.insights_rounded),
      ('Health History', Icons.favorite_outline_rounded),
      ('Fast Access', Icons.bolt_rounded),
    ];

    return MobileGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .map(
              (item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _InfoPill(label: item.$1, icon: item.$2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withAlpha(10),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7DEBFF), size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withAlpha(199),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
