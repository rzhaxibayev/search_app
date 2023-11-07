import 'package:search_app/features/search/data/search_repository.dart';
import 'package:search_app/features/search/domain/model/prediction_model.dart';

// SearchInteractor
class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase({required this.repository});

  Future<List<PredictionModel>> getPredictions({
    required String text,
  }) async {
    return repository.getPredictions(text: text);
  }
}
