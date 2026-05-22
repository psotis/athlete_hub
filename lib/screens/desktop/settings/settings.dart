import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SettingsDesktop extends StatefulWidget {
  const SettingsDesktop({super.key});

  @override
  State<SettingsDesktop> createState() => _SettingsDesktopState();
}

class _SettingsDesktopState extends State<SettingsDesktop> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _picture;
  String? _version;

  final Uri _url = Uri.parse('mailto:psotakos@gmail.com');

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _launchUrl() async {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }

  Future<void> _getFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    final imageByte = await imageFile.readAsBytes();

    setState(() {
      _imageFile = imageFile;
      _picture = base64.encode(imageByte);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    final actionTiles = [
        _DesktopActionTile(
          title: 'My profile',
          subtitle: 'Open full account information and edit it on desktop.',
          icon: Icons.person_outline_rounded,
          onTap: () => context.push(Routes.profile),
        ),
      _DesktopActionTile(
        title: 'My health',
        subtitle: 'Review medical history and records.',
        icon: Icons.favorite_outline_rounded,
        onTap: () => context.push(Routes.health),
      ),
      if (context.isAdmin)
        _DesktopActionTile(
          title: 'Athletes profile',
          subtitle: 'Search athletes, edit profile details and review history.',
          icon: Icons.manage_accounts_outlined,
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileCustomerSearchDesktopPage(),
              ),
            );
          },
        ),
      _DesktopActionTile(
        title: 'Logout',
        subtitle: 'Sign out from the current workspace.',
        icon: Icons.logout_rounded,
        color: const Color(0xFFFEE2E2),
        accent: const Color(0xFFB91C1C),
        onTap: () {
          context.read<ErgometricsCubit>().clearErgometrics();
          context.read<AuthBloc>().add(AuthLoggedOut());
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: DesktopSurfaceCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                        ),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(Images.logo2),
                            ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Athlete Hub',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user?.email ?? 'No email',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: const Color(0xFF475569)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _version != null
                                ? 'Version $_version'
                                : 'Loading version...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => context.push(Routes.profile),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit profile'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _getFromGallery,
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Update image'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _launchUrl,
                                icon: const Icon(Icons.mail_outline_rounded),
                                label: const Text('Contact support'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DesktopSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DesktopSectionTitle(
                      title: 'Account snapshot',
                      subtitle:
                          'Desktop gives these profile details more room to breathe.',
                    ),
                    const SizedBox(height: 18),
                    _SettingsLine(label: 'Phone', value: user?.phone ?? '-'),
                    _SettingsLine(label: 'Sport', value: user?.sport ?? '-'),
                    _SettingsLine(label: 'Team', value: user?.team ?? '-'),
                    _SettingsLine(
                      label: 'Status',
                      value: (user?.isActive ?? false) ? 'Active' : 'Inactive',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: actionTiles
              .map(
                (tile) => SizedBox(
                  width: 320,
                  child: tile,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DesktopActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color accent;

  const _DesktopActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFFFFFFFF),
    this.accent = const Color(0xFF1D4ED8),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: DesktopSurfaceCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color == Colors.white ? const Color(0xFFDBEAFE) : color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String label;
  final String value;

  const _SettingsLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
