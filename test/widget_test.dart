// Smoke test for the portfolio: the app boots and renders the hero name.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_portfolio/main.dart';
import 'package:my_portfolio/theme/app_theme.dart';

void main() {
  testWidgets('renders hero name and nav CTA', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: AppTheme(),
        child: const PortfolioApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Hero headline split into "Omar " + gradient "Maamoun".
    expect(find.text('Omar '), findsOneWidget);
    expect(find.text('Maamoun'), findsWidgets);
    // A section landmark renders.
    expect(find.text('Apps live in the stores'), findsWidgets);
  });
}
