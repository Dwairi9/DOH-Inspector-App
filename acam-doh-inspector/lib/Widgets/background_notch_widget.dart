import 'package:aca_mobile_app/Widgets/painters.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundNotch extends ConsumerWidget {
  const BackgroundNotch({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeNotifier = ref.watch(themeProvider);
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: themeNotifier.notchWidth,
        child: Transform.scale(
          scaleX: -1,
          child: CustomPaint(
            size: Size(340, themeNotifier.notchHeight),
            painter: BackgroundEffectPainter(themeNotifier.notchColor, 0.4),
          ),
        ),
      ),
    );
  }
}
