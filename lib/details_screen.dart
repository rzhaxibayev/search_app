import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String name;
  static const routeName = 'details_screen';

  const DetailsScreen({
    super.key,
    required this.name,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: const Center(
        child: Text('Second screen'),
      ),
    );
  }
}
