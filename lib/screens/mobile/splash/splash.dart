import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SplashMobile extends StatefulWidget {
  const SplashMobile({super.key});

  @override
  State<SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends State<SplashMobile> {
  Timer? _delayTimer;
  bool _minimumDelayPassed = false;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();

    _delayTimer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      _minimumDelayPassed = true;
      _tryNavigate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryNavigate();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void _tryNavigate() {
    if (_didNavigate || !_minimumDelayPassed) return;

    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      _didNavigate = true;
      context.go(Routes.dashboard);
      return;
    }

    if (state is AuthUnauthenticated || state is AuthFailure) {
      _didNavigate = true;
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _tryNavigate(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
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
              left: -60,
              child: _SplashOrb(size: 240, color: Color(0xAA3B82F6)),
            ),
            const Positioned(
              top: 100,
              right: -100,
              child: _SplashOrb(size: 220, color: Color(0x6622D3EE)),
            ),
            const Positioned(
              bottom: -120,
              left: -60,
              child: _SplashOrb(size: 260, color: Color(0x5522D3EE)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: 112,
                      height: 112,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x55148CFF),
                            blurRadius: 22,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Image.asset(Images.logo2),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Athlete Hub',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Performance, health and athlete progress in one beautiful workspace.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withAlpha(184),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withAlpha(15),
                        border: Border.all(color: Colors.white.withAlpha(26)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Checking your session...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Built for athletes, coaches and performance teams',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(158),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _SplashOrb({required this.size, required this.color});

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
