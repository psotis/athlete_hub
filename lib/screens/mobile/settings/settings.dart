import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SettingsMobile extends StatefulWidget {
  const SettingsMobile({super.key});

  @override
  State<SettingsMobile> createState() => _SettingsMobileState();
}

class _SettingsMobileState extends State<SettingsMobile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _picture;
  String? _version;

  final Uri url = Uri.parse('mailto:psotakos@gmail.com');

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await showVersion();
    setState(() {
      _version = version;
    });
  }

  Future<void> _launchUrl() async {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<String> showVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  Future<void> _getFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile == null) return;
    File imageFile = File(pickedFile.path);
    Uint8List imageByte = await imageFile.readAsBytes();

    setState(() {
      _imageFile = imageFile;
      _picture = base64.encode(imageByte);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: MobileTopIconButton(
                icon: Icons.photo_library_outlined,
                onTap: _getFromGallery,
              ),
            ),
            const SizedBox(height: 12),
            MobileGlassCard(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 320) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _BrandLogo(),
                        const SizedBox(height: 14),
                        _BrandInfo(version: _version),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      const _BrandLogo(),
                      const SizedBox(width: 16),
                      Expanded(child: _BrandInfo(version: _version)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _SettingsActionTile(
              title: 'My profile',
              subtitle: 'View and manage your account information.',
              icon: FontAwesomeIcons.circleUser,
              onTap: () => context.push(Routes.profile),
            ),
            if (context.isAdmin) ...[
              const SizedBox(height: 12),
              _SettingsActionTile(
                title: 'Athletes profile',
                subtitle: 'Search athletes, edit profile details and review medical history.',
                icon: Icons.manage_accounts_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileCustomerSearchPage(),
                    ),
                  );
                },
              ),
            ],
            if (context.isAdmin || context.isTrainer) ...[
              const SizedBox(height: 12),
              _SettingsActionTile(
                title: 'Exercise library',
                subtitle: 'Create and manage categories, muscle groups and exercises.',
                icon: Icons.fitness_center_rounded,
                onTap: () => context.push(Routes.exerciseLibrary),
              ),
            ],
            const SizedBox(height: 12),
            _SettingsActionTile(
              title: 'My health',
              subtitle: 'Open your medical history and active records.',
              icon: FontAwesomeIcons.heartPulse,
              onTap: () => context.push(Routes.health),
            ),
            const SizedBox(height: 12),
            _SettingsActionTile(
              title: 'Contact us',
              subtitle: 'Send a message straight to support.',
              icon: FontAwesomeIcons.at,
              onTap: _launchUrl,
            ),
            const SizedBox(height: 18),
            MobileGlassCard(
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ErgometricsCubit>().clearErgometrics();
                    context.read<AuthBloc>().add(AuthLoggedOut());
                  },
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB91C1C),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
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

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(Images.logo2),
      ),
    );
  }
}

class _BrandInfo extends StatelessWidget {
  final String? version;

  const _BrandInfo({required this.version});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Athlete Hub',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          version != null ? 'Version $version' : 'Loading version...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(173),
          ),
        ),
      ],
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MobileInfoCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
    );
  }
}
