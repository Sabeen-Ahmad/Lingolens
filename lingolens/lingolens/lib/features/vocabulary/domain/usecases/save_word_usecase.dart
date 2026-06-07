import 'package:lingolens/features/vocabulary/domain/entities/word.dart';
import 'package:lingolens/features/vocabulary/domain/repositories/vocabulary_repository.dart';

class SaveWordUseCase {
  final VocabularyRepository _repository;
  const SaveWordUseCase(this._repository);

  Future<Word> call({
    required String word,
    required String meaning,
    required String translation,
  }) => _repository.saveWord(
    word: word,
    meaning: meaning,
    translation: translation,
  );
}
