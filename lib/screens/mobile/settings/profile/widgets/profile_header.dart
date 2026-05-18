import 'package:athlete_hub/helpers/imports.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String role;
  final bool isActive;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MobileGlassCard(
      borderRadius: BorderRadius.circular(28),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55148CFF),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(179),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _StatusChip(label: role),
              _StatusChip(
                label: isActive ? 'Active' : 'Inactive',
                isPositive: isActive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isPositive;

  const _StatusChip({
    required this.label,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isPositive
            ? const Color(0x3322C55E)
            : Colors.white.withAlpha(15),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isPositive ? const Color(0xFF86EFAC) : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
