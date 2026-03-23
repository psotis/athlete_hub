import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsChartsView extends StatelessWidget {
  const ErgometricsChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErgometricsCubit, ErgometricsState>(
      builder: (context, state) {
        if (state.status == ErgometricsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ErgometricsStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Something went wrong'),
          );
        }

        final ergometrics = state.data.ergometrics;

        if (ergometrics.isEmpty) {
          return const Center(child: Text('No ergometrics found'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SomatometricsCharts(items: ergometrics),
            const SizedBox(height: 24),
            GoniometricsCharts(items: ergometrics),
            const SizedBox(height: 24),
            DynamometricsCharts(items: ergometrics),
            const SizedBox(height: 24),
            JumpingCharts(items: ergometrics),
            const SizedBox(height: 24),
            AgilityCharts(items: ergometrics),
            const SizedBox(height: 24),
            EnduranceCharts(items: ergometrics),
            const SizedBox(height: 24),
            OverheadSquatCharts(items: ergometrics),
          ],
        );
      },
    );
  }
}
