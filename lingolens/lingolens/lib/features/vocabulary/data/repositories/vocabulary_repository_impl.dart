import 'package:dio/dio.dart';
import 'package:lingolens/features/vocabulary/data/datasources/vocabulary_local_datasource.dart';
import 'package:lingolens/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:lingolens/features/vocabulary/data/models/word_model.dart';
import 'package:lingolens/features/vocabulary/domain/entities/word.dart';
import 'package:lingolens/features/vocabulary/domain/repositories/vocabulary_repository.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyRemoteDataSource remoteDataSource;
  final VocabularyLocalDataSource localDataSource;

  VocabularyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Strategy:
  /// 1. Try to fetch from the Node.js API (GET /words) – single source of truth
  ///    for reading, as required by the spec.
  /// 2. On network failure, fall back to Firestore directly so offline reads
  ///    still work.
  @override
  Future<List<Word>> getWords() async {
    try {
      return await remoteDataSource.getWords();
    } on DioException catch (_) {
      // Fallback to local Firestore
      return await localDataSource.getWords();
    }
  }

  /// Always writes directly to Firestore. The Node.js API exposes a POST /words
  /// endpoint too, but writing through Firestore SDK is simpler and offline-safe.
  @override
  Future<Word> saveWord({
    required String word,
    required String meaning,
    required String translation,
  }) async {
    final model = WordModel(
      id: '',
      word: word.trim(),
      meaning: meaning.trim(),
      translation: translation.trim(),
      createdAt: DateTime.now(),
    );
    return await localDataSource.saveWord(model);
  }
}
