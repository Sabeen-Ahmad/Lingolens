import 'package:dio/dio.dart';
import 'package:lingolens/features/vocabulary/data/models/word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<WordModel>> getWords();
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final Dio dio;
  VocabularyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<WordModel>> getWords() async {
    final response = await dio.get('/words');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Failed to load words (${response.statusCode})',
    );
  }
}
