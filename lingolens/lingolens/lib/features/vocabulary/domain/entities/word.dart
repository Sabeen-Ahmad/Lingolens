import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String id;
  final String word;
  final String meaning;
  final String translation;
  final DateTime? createdAt;

  const Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, word, meaning, translation, createdAt];
}
