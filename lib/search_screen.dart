import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:search_app/address.dart';
import 'package:search_app/details_screen.dart';
import 'package:search_app/search_list_item.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final dio = Dio();
  final list = <Address>[];

  Timer? timer;
  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where do you live?',
              style: TextStyle(
                color: Color.fromRGBO(15, 26, 56, 1),
                fontSize: 34,
                fontWeight: FontWeight.w400,
                height: 36 / 34,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your residential address in the UAE',
              style: TextStyle(
                color: Color.fromRGBO(15, 26, 56, 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 22 / 16,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: 'Search your building',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(15, 26, 56, 0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 22 / 16,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(
                      87,
                      0,
                      255,
                      1,
                    ),
                  ),
                ),
              ),
              onChanged: (text) {
                _onTextChanged(text);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final address = list[index];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DetailsScreen.routeName,
                        arguments: address,
                      );
                    },
                    child: SearchListItem(
                      name: address.name,
                      desc: address.desc,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTextChanged(String text) async {
    try {
      subscription?.cancel();
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 400), () async {
        print('loading: $text');
        if (text.isNotEmpty) {
          final response = dio.get(
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=AIzaSyDSc3bK2uacejfepEMiJlrVw9DFC8WVonI');

          subscription = Stream.fromFuture(response).listen((response) {
            final data = response.data as Map<String, dynamic>;
            final predictions = data['predictions'] as List;
            final addresses = predictions.map(
              (e) {
                final addressJson = e as Map<String, dynamic>;

                return Address(
                  name: addressJson['structured_formatting']['main_text'],
                  desc: addressJson['description'],
                  placeId: addressJson['place_id'],
                );
              },
            ).toList();

            list.clear();
            list.addAll(addresses);
          });
        } else {
          list.clear();
        }
      });
    } on Object catch (e) {
      print('Error: $e');
    }

    setState(() {});
  }
}
