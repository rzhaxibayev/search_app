import 'package:search_app/features/search/data/models/structured_formatting.dart';

class Prediction {
  final String placeId;
  final StructuredFormatting structuredFormatting;

  Prediction({
    required this.placeId,
    required this.structuredFormatting,
  });
}
