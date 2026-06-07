import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingolens/core/theme/app_theme.dart';
import 'package:lingolens/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:lingolens/features/vocabulary/presentation/widgets/add_word_bottom_sheet.dart';
import 'package:lingolens/features/vocabulary/presentation/widgets/empty_vocabulary_state.dart';
import 'package:lingolens/features/vocabulary/presentation/widgets/error_state.dart';
import 'package:lingolens/features/vocabulary/presentation/widgets/word_card.dart';
import 'package:lingolens/features/vocabulary/presentation/widgets/word_card_skeleton.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Expanded(child: _Body()),
          ],
        ),
      ),
      floatingActionButton: _AddButton(),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppTheme.accentLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'LingoLens',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.divider,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'My Vocabulary',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 4),
          BlocBuilder<VocabularyBloc, VocabularyState>(
            builder: (context, state) {
              int? count;
              if (state is VocabularyLoaded) count = state.words.length;
              if (state is WordSaved) count = state.words.length;
              if (state is WordSaving) count = state.currentWords.length;
              if (state is WordSaveError) count = state.currentWords.length;

              return Text(
                count != null
                    ? '$count ${count == 1 ? 'word' : 'words'} saved'
                    : 'Build your word collection',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(color: AppTheme.divider, height: 1),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        // Loading skeleton
        if (state is VocabularyLoading) {
          return const VocabularyLoadingList();
        }

        // Error
        if (state is VocabularyError) {
          return VocabularyErrorState(
            message: state.message,
            onRetry: () =>
                context.read<VocabularyBloc>().add(const LoadWordsEvent()),
          );
        }

        // Resolve word list from current state
        final words = switch (state) {
          VocabularyLoaded s => s.words,
          WordSaving s => s.currentWords,
          WordSaved s => s.words,
          WordSaveError s => s.currentWords,
          _ => <dynamic>[],
        };

        // Empty state
        if (words.isEmpty) {
          return EmptyVocabularyState(
            onAddWord: () => AddWordBottomSheet.show(context),
          );
        }

        // Word list with pull-to-refresh
        return RefreshIndicator(
          color: AppTheme.accent,
          backgroundColor: AppTheme.surface,
          onRefresh: () async {
            context.read<VocabularyBloc>().add(const LoadWordsEvent());
            // Wait until not in loading state
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return WordCard(word: words[index], index: index);
            },
          ),
        );
      },
    );
  }
}

// ─── FAB ──────────────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        final isSaving = state is WordSaving;
        return FloatingActionButton.extended(
          onPressed: isSaving ? null : () => AddWordBottomSheet.show(context),
          backgroundColor: AppTheme.accent,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add_rounded),
          label: Text(
            isSaving ? 'Saving…' : 'Add Word',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
