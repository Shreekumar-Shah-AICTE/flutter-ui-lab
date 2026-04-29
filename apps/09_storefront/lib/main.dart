import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'store_screen.dart';

void main() => runApp(const StorefrontApp());

class StorefrontApp extends StatelessWidget {
  const StorefrontApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Storefront', debugShowCheckedModeBanner: false, theme: AppTheme.light(), home: const StoreScreen());
  }
}
