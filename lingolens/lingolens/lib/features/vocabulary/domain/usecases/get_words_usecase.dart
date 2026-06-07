import 'package:lingolens/features/vocabulary/domain/entities/word.dart';
import 'package:lingolens/features/vocabulary/domain/repositories/vocabulary_repository.dart';

class GetWordsUseCase {
  final VocabularyRepository _repository;
  const GetWordsUseCase(this._repository);

  Future<List<Word>> call() => _repository.getWords();
}
