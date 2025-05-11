import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugaslayout3/main.dart';

void main() {
  testWidgets('HomeScreen UI Test', (WidgetTester tester) async {
    // Build the HomeScreen widget
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    // Verify app bar title
    expect(find.text("Koperasi Undiksha"), findsOneWidget);

    // Verify presence of user information
    expect(find.text("Nasabah\nI Ketut Resika Arthana"), findsOneWidget);
    expect(find.text("Total Saldo Anda\nRp. 1200.0000"), findsOneWidget);

    // Verify presence of menu items
    expect(find.text("Cek Saldo"), findsOneWidget);
    expect(find.text("Transfer"), findsOneWidget);
    expect(find.text("Deposito"), findsOneWidget);
    expect(find.text("Pembayaran"), findsOneWidget);
    expect(find.text("Pinjaman"), findsOneWidget);
    expect(find.text("Mutasi"), findsOneWidget);

    // Verify presence of help section
    expect(find.text("Butuh Bantuan?"), findsOneWidget);
    expect(find.text("0878-1234-1024"), findsOneWidget);

    // Verify presence of bottom menu items
    expect(find.text("Setting"), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);
  });
}