import 'package:lingolens/features/vocabulary/domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.translation,
    super.createdAt,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  factory WordModel.fromFirestore(Map<String, dynamic> data, String id) {
    return WordModel(
      id: id,
      word: data['word'] as String? ?? '',
      meaning: data['meaning'] as String? ?? '',
      translation: data['translation'] as String? ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'word': word,
    'meaning': meaning,
    'translation': translation,
    'createdAt':
        createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
  };
}
