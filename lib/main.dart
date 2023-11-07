import 'package:flutter/material.dart';
import 'package:search_app/core/routes/app_routes.dart';
import 'package:search_app/features/search/ui/screens/search/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchScreen(),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
