import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SplashDesktop extends StatefulWidget {
  const SplashDesktop({super.key});

  @override
  State<SplashDesktop> createState() => _SplashDesktopState();
}

class _SplashDesktopState extends State<SplashDesktop> {
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF071427),
                      Color(0xFF0B2148),
                      Color(0xFF020612),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: -160,
              left: -80,
              child: _DesktopSplashOrb(size: 320, color: Color(0x883B82F6)),
            ),
            const Positioned(
              bottom: -180,
              right: -100,
              child: _DesktopSplashOrb(size: 360, color: Color(0x5522D3EE)),
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 860),
                padding: const EdgeInsets.all(36),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 132,
                            height: 132,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(34),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x55148CFF),
                                  blurRadius: 28,
                                  offset: Offset(0, 18),
                                ),
                              ],
                            ),
                            child: Image.asset(Images.logo2),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Athlete Hub',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Performance, health and athlete progress in one beautiful workspace.',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white.withAlpha(184),
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 36),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white.withAlpha(15),
                        border: Border.all(color: Colors.white.withAlpha(26)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Checking your session',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We are validating your saved login and preparing the correct route.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withAlpha(173),
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 20),
                          const LinearProgressIndicator(minHeight: 6),
                        ],
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

class _DesktopSplashOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _DesktopSplashOrb({required this.size, required this.color});

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
