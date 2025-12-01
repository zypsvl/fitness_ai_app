import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/widgets/glass_container.dart';

void main() {
  group('GlassContainer Widget', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      // Arrange
      const testKey = Key('test_child');
      const testChild = Text('Test Content', key: testKey);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies custom width and height', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              width: 200,
              height: 100,
              child: SizedBox(),
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(container.constraints?.maxWidth, 200);
      expect(container.constraints?.maxHeight, 100);
    });

    testWidgets('applies custom padding when provided', (WidgetTester tester) async {
      // Arrange
      const customPadding = EdgeInsets.all(24.0);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              padding: customPadding,
              child: Text('Padded'),
            ),
          ),
        ),
      );

      // Assert - Widget should render without errors
      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('creates widget with default border radius', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Assert - Should render successfully with default borderRadius = 16
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('GlassCard Widget', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Card Content');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      void onTap() {
        tapped = true;
      }

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: onTap,
              child: const Text('Tappable'),
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.text('Tappable'));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('shows selected state', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              isSelected: true,
              child: Text('Selected'),
            ),
          ),
        ),
      );

      // Assert - Should render without errors when selected
      expect(find.text('Selected'), findsOneWidget);
    });

    testWidgets('animates on tap', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: () {},
              child: const Text('Animated'),
            ),
          ),
        ),
      );

      // Act - Simulate tap down
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Animated')),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Widget should still be visible during animation
      expect(find.text('Animated'), findsOneWidget);

      // Clean up
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
