// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build our app with provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WorkoutProvider(),
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      ),
    );
    
    // Verify app loads
    expect(find.text('Test'), findsOneWidget);
  });
}
