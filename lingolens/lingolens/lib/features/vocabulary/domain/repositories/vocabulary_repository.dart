import 'package:lingolens/features/vocabulary/domain/entities/word.dart';

abstract class VocabularyRepository {
  /// Fetches words from the remote API (GET /words)
  Future<List<Word>> getWords();

  /// Saves a new word to Firestore
  Future<Word> saveWord({
    required String word,
    required String meaning,
    required String translation,
  });
}
