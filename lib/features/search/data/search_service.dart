import 'package:dio/dio.dart';
import 'package:search_app/features/search/data/models/prediction.dart';
import 'package:search_app/features/search/data/models/predictions_response.dart';
import 'package:search_app/features/search/data/models/structured_formatting.dart';

class SearchService {
  final Dio dio;

  SearchService({
    required this.dio,
  });

  Future<List<Prediction>> getPredictions({required String text}) async {
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=AIzaSyDSc3bK2uacejfepEMiJlrVw9DFC8WVonI',
    );

    final data = response.data as Map<String, dynamic>;
    final predictionsJson = data['predictions'] as List;

    final predictions = predictionsJson.map((e) {
      final predictionJson = e as Map<String, dynamic>;
      final structuredFormatting =
          predictionJson['structured_formatting'] as Map<String, dynamic>;

      return Prediction(
        placeId: predictionJson['place_id'],
        structuredFormatting: StructuredFormatting(
          mainText: structuredFormatting['main_text'],
          secondaryText: structuredFormatting['secondary_text'],
        ),
      );
    }).toList();

    final predictionsResponse = PredictionsResponse(
      predictions: predictions,
    );

    return predictionsResponse.predictions;
  }
}
