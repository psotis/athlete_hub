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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            child: Text(
              fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Chip(label: Text(role)),
              Chip(label: Text(isActive ? 'Active' : 'Inactive')),
            ],
          ),
        ],
      ),
    );
  }
}
