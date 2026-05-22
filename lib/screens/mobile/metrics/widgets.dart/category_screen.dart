import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

enum ErgometricsCategory {
  somatometrics,
  goniometrics,
  dynamometrics,
  jumping,
  agility,
  endurance,
  overheadSquat,
}

class ErgometricsCategoryScreen extends StatelessWidget {
  final String title;
  final ErgometricsCategory category;
  final bool embedded;

  const ErgometricsCategoryScreen({
    super.key,
    required this.title,
    required this.category,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = BlocBuilder<ErgometricsCubit, ErgometricsState>(
      builder: (context, state) {
        if (state.status == ErgometricsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ErgometricsStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final ergometrics = state.data.ergometrics;

        if (ergometrics.isEmpty) {
          return const Center(
            child: Text(
              'No ergometrics found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(16, embedded ? 0 : 8, 16, embedded ? 24 : 120),
          children: [
            _buildCategoryWidget(ergometrics),
          ],
        );
      },
    );

    if (embedded) {
      return MobileGlowScaffold(child: content);
    }

    return MobileGlowScaffold(
      appBar: MobileScreenAppBar(title: title),
      child: content,
    );
  }

  Widget _buildCategoryWidget(List<ErgometricsDetails> items) {
    switch (category) {
      case ErgometricsCategory.somatometrics:
        return SomatometricsCharts(items: items);
      case ErgometricsCategory.goniometrics:
        return GoniometricsCharts(items: items);
      case ErgometricsCategory.dynamometrics:
        return DynamometricsCharts(items: items);
      case ErgometricsCategory.jumping:
        return JumpingCharts(items: items);
      case ErgometricsCategory.agility:
        return AgilityCharts(items: items);
      case ErgometricsCategory.endurance:
        return EnduranceCharts(items: items);
      case ErgometricsCategory.overheadSquat:
        return OverheadSquatCharts(items: items);
    }
  }
}
