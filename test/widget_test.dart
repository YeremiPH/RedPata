// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:red_pata/main.dart';

void main() {
  testWidgets('La app muestra el título principal', (
    WidgetTester tester,
  ) async {
    // Construimos solo la pantalla principal en modo "skipInit" para evitar
    // llamadas a plugins de plataforma durante la prueba.
    await tester.pumpWidget(
      const MaterialApp(home: WifiInfoScreen(skipInit: true)),
    );

    // Verificamos que el título de la AppBar está presente.
    expect(find.text('Analizador WiFi'), findsOneWidget);
  });
}
