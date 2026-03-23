import 'package:athlete_hub/helpers/imports.dart';

class ModalHud extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? loader;
  final Color? barrierColor;

  const ModalHud({
    super.key,
    required this.child,
    required this.isLoading,
    this.loader,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          ModalBarrier(dismissible: false, color: barrierColor),
          Center(child: loader ?? const LoadingIndicator()),
        ],
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 90,
      height: 90,
      child: Card(
        elevation: 6,
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(child: SpinKitPouringHourGlass(color: colors.primary)),
      ),
    );
  }
}
