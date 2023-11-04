import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:search_app/address.dart';
import 'package:search_app/address_for_detail.dart';

class DetailsScreen extends StatefulWidget {
  final Address address;
  static const routeName = 'details_screen';

  const DetailsScreen({
    super.key,
    required this.address,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final dio = Dio();
  String name = '';
  String website = '';

  @override
  void initState() {
    _loadPlaceId(widget.address);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Name: $name'),
            Text('Website: $website'),
          ],
        ),
      ),
    );
  }

  Future<void> _loadPlaceId(Address address) async {
    try {
      final placeId = address.placeId;

      if (address.placeId.isNotEmpty) {
        final url =
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyDSc3bK2uacejfepEMiJlrVw9DFC8WVonI';
        final response = await dio.get(url);

        final Map<String, dynamic> jsonResponse = Map.castFrom(response.data);

        final result = jsonResponse['result'];

        final details = AddressForDetail(
          name: result['formatted_address'],
          website: result['website'],
          placeId: result['place_id'],
        );

        print(details.name);
        print(details.website);
        print(details.placeId);

        setState(() {
          name = details.name;
          website = details.website;
        });
      } else {}
    } on Object catch (e) {
      print('Error: $e');
    }
  }
}
