import 'package:search_app/features/search/data/search_service.dart';
import 'package:search_app/features/search/domain/model/prediction_model.dart';

class SearchRepository {
  final SearchService service;

  SearchRepository({required this.service});

  Future<List<PredictionModel>> getPredictions({required String text}) async {
    final predictionDtos = await service.getPredictions(text: text);

    final models = predictionDtos
        .map(
          (dto) => PredictionModel(
            fullText:
                '${dto.structuredFormatting.mainText}, ${dto.structuredFormatting.secondaryText}',
          ),
        )
        .toList();

    return models;
  }
}
