import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lingolens/core/network/api_client.dart';
import 'package:lingolens/features/vocabulary/data/datasources/vocabulary_local_datasource.dart';
import 'package:lingolens/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:lingolens/features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'package:lingolens/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:lingolens/features/vocabulary/domain/usecases/get_words_usecase.dart';
import 'package:lingolens/features/vocabulary/domain/usecases/save_word_usecase.dart';
import 'package:lingolens/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── External ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => ApiClient.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ─── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<VocabularyRemoteDataSource>(
    () => VocabularyRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<VocabularyLocalDataSource>(
    () => VocabularyLocalDataSourceImpl(firestore: sl()),
  );

  // ─── Repository ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<VocabularyRepository>(
    () =>
        VocabularyRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ─── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetWordsUseCase(sl()));
  sl.registerLazySingleton(() => SaveWordUseCase(sl()));

  // ─── BLoC ──────────────────────────────────────────────────────────────────
  sl.registerFactory(
    () => VocabularyBloc(getWordsUseCase: sl(), saveWordUseCase: sl()),
  );
}
