import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:search_app/details_screen.dart';
import 'package:search_app/features/search/data/search_repository.dart';
import 'package:search_app/features/search/data/search_service.dart';
import 'package:search_app/features/search/domain/model/prediction_model.dart';
import 'package:search_app/features/search/domain/search_use_case.dart';
import 'package:search_app/features/search/ui/screens/search/search_list_item.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchService service;
  late SearchRepository repository;
  late SearchUseCase useCase;

  final list = <PredictionModel>[];

  Timer? timer;
  StreamSubscription? subscription;

  @override
  void initState() {
    service = SearchService(dio: Dio());
    repository = SearchRepository(service: service);
    useCase = SearchUseCase(repository: repository);

    super.initState();
  }

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
                  final prediction = list[index];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DetailsScreen.routeName,
                        arguments: null,
                      );
                    },
                    child: SearchListItem(
                      name: prediction.fullText,
                      desc: '',
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
          final predictions = useCase.getPredictions(text: text);
          subscription =
              Stream.fromFuture(predictions).listen((predictionList) async {
            setState(() {
              list.clear();
              list.addAll(predictionList);
            });
          });
        } else {
          setState(() {
            list.clear();
          });
        }
      });
    } on Object catch (e) {
      print('Error: $e');
    }
  }
}
