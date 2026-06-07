import 'package:flutter/material.dart';
import 'package:lingolens/core/theme/app_theme.dart';

class EmptyVocabularyState extends StatelessWidget {
  final VoidCallback onAddWord;
  const EmptyVocabularyState({super.key, required this.onAddWord});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppTheme.accentLight,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No words yet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "You haven't saved any words yet.\nStart building your vocabulary!",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAddWord,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Your First Word'),
            ),
          ],
        ),
      ),
    );
  }
}
