import 'package:athlete_hub/blocs/ergometrics/ergometrics_cubit.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';

enum DesktopErgometricsCategory {
  somatometrics,
  goniometrics,
  dynamometrics,
  jumping,
  agility,
  endurance,
  overheadSquat,
}

class DesktopErgometricsCategoryDetail extends StatelessWidget {
  final String title;
  final DesktopErgometricsCategory category;
  final VoidCallback onBack;

  const DesktopErgometricsCategoryDetail({
    super.key,
    required this.title,
    required this.category,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErgometricsCubit, ErgometricsState>(
      builder: (context, state) {
        if (state.status == ErgometricsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ErgometricsStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              style: const TextStyle(color: Color(0xFF0F172A)),
            ),
          );
        }

        final ergometrics = state.data.ergometrics;
        if (ergometrics.isEmpty) {
          return const Center(
            child: Text(
              'No ergometrics found',
              style: TextStyle(color: Color(0xFF0F172A)),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to categories'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCategoryWidget(ergometrics),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryWidget(List<ErgometricsDetails> items) {
    switch (category) {
      case DesktopErgometricsCategory.somatometrics:
        return SomatometricsCharts(items: items);
      case DesktopErgometricsCategory.goniometrics:
        return GoniometricsCharts(items: items);
      case DesktopErgometricsCategory.dynamometrics:
        return DynamometricsCharts(items: items);
      case DesktopErgometricsCategory.jumping:
        return JumpingCharts(items: items);
      case DesktopErgometricsCategory.agility:
        return AgilityCharts(items: items);
      case DesktopErgometricsCategory.endurance:
        return EnduranceCharts(items: items);
      case DesktopErgometricsCategory.overheadSquat:
        return OverheadSquatCharts(items: items);
    }
  }
}
