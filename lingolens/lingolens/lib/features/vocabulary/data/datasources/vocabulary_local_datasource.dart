import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingolens/features/vocabulary/data/models/word_model.dart';

abstract class VocabularyLocalDataSource {
  Future<List<WordModel>> getWords();
  Future<WordModel> saveWord(WordModel word);
}

class VocabularyLocalDataSourceImpl implements VocabularyLocalDataSource {
  final FirebaseFirestore firestore;
  VocabularyLocalDataSourceImpl({required this.firestore});

  CollectionReference get _collection => firestore.collection('words');

  @override
  Future<List<WordModel>> getWords() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => WordModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<WordModel> saveWord(WordModel word) async {
    final docRef = await _collection.add(word.toJson());
    final doc = await docRef.get();

    return WordModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }
}
