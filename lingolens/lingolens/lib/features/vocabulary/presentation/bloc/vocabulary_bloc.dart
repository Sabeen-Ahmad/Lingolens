import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingolens/features/vocabulary/domain/entities/word.dart';
import 'package:lingolens/features/vocabulary/domain/usecases/get_words_usecase.dart';
import 'package:lingolens/features/vocabulary/domain/usecases/save_word_usecase.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();
  @override
  List<Object?> get props => [];
}

class LoadWordsEvent extends VocabularyEvent {
  const LoadWordsEvent();
}

class SaveWordEvent extends VocabularyEvent {
  final String word;
  final String meaning;
  final String translation;

  const SaveWordEvent({
    required this.word,
    required this.meaning,
    required this.translation,
  });

  @override
  List<Object?> get props => [word, meaning, translation];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class VocabularyState extends Equatable {
  const VocabularyState();
  @override
  List<Object?> get props => [];
}

class VocabularyInitial extends VocabularyState {}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final List<Word> words;
  const VocabularyLoaded(this.words);

  @override
  List<Object?> get props => [words];
}

class VocabularyError extends VocabularyState {
  final String message;
  const VocabularyError(this.message);

  @override
  List<Object?> get props => [message];
}

class WordSaving extends VocabularyState {
  final List<Word> currentWords;
  const WordSaving(this.currentWords);

  @override
  List<Object?> get props => [currentWords];
}

class WordSaved extends VocabularyState {
  final List<Word> words;
  const WordSaved(this.words);

  @override
  List<Object?> get props => [words];
}

class WordSaveError extends VocabularyState {
  final String message;
  final List<Word> currentWords;
  const WordSaveError(this.message, this.currentWords);

  @override
  List<Object?> get props => [message, currentWords];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final GetWordsUseCase getWordsUseCase;
  final SaveWordUseCase saveWordUseCase;

  VocabularyBloc({required this.getWordsUseCase, required this.saveWordUseCase})
    : super(VocabularyInitial()) {
    on<LoadWordsEvent>(_onLoadWords);
    on<SaveWordEvent>(_onSaveWord);
  }

  Future<void> _onLoadWords(
    LoadWordsEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    try {
      final words = await getWordsUseCase();
      emit(VocabularyLoaded(words));
    } catch (e) {
      emit(VocabularyError('Failed to load words. Please try again.'));
    }
  }

  Future<void> _onSaveWord(
    SaveWordEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final currentWords = state is VocabularyLoaded
        ? (state as VocabularyLoaded).words
        : <Word>[];

    emit(WordSaving(currentWords));
    try {
      final saved = await saveWordUseCase(
        word: event.word,
        meaning: event.meaning,
        translation: event.translation,
      );
      final updated = [saved, ...currentWords];
      emit(WordSaved(updated));
    } catch (e) {
      emit(
        WordSaveError('Failed to save word. Please try again.', currentWords),
      );
    }
  }
}
