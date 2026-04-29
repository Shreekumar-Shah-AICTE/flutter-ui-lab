import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'catalog_screen.dart';

void main() => runApp(const CatalogApp());

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Catalog', debugShowCheckedModeBanner: false, theme: AppTheme.light(), home: const CatalogScreen());
  }
}
