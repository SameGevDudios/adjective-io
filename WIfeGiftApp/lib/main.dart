import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wife_gift/common/api/auth_interceptor.dart';
import 'package:wife_gift/common/api/dio_client.dart';
import 'package:wife_gift/common/config/env_config.dart';
import 'package:wife_gift/common/services/asset_loader_service.dart';
import 'package:wife_gift/common/storage/token_storage.dart';
import 'package:wife_gift/features/auth/data/data_sources/auth_data_source_impl.dart';
import 'package:wife_gift/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/authentication_gate.dart';
import 'package:wife_gift/features/mood_screen/data/data_sources/data_sources.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository_impl.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/prefix_repository_impl.dart';
import 'package:wife_gift/features/mood_screen/logic/prefix_bloc/prefix_bloc.dart';
import 'package:wife_gift/features/mood_screen/logic/preference_bloc/preference_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.validate();

  final tokenStorage = TokenStorage(const FlutterSecureStorage());
  final authInterceptor = AuthInterceptor(tokenStorage, EnvConfig.baseUrl);
  final dioClient = DioClient(authInterceptor);

  final authDataSource = AuthDataSourceImpl(dioClient.dio);
  final authRepository = AuthRepositoryImpl(authDataSource, tokenStorage);

  final preferenceDataSource = PreferenceDataSourceImpl(dioClient.dio);
  final preferenceRepository = PreferenceRepositoryImpl(preferenceDataSource);

  final prefixDataSource = PrefixDataSourceImpl(dioClient.dio);
  final prefixRepository = PrefixRepositoryImpl(prefixDataSource);

  final assetLoader = AssetLoaderService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<PreferenceRepositoryImpl>.value(value: preferenceRepository),
        RepositoryProvider<PrefixRepositoryImpl>.value(value: prefixRepository),
        RepositoryProvider<AssetLoaderService>.value(value: assetLoader),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              repository: authRepository,
              preferenceRepository: preferenceRepository,
              prefixRepository: prefixRepository,
              assetLoader: assetLoader,
              dio: dioClient.dio,
            )..add(AuthEvent$StatusChecked()),
          ),
          BlocProvider(
            create: (context) =>
                PreferenceBloc(preferenceRepository)..add(PreferenceEvent$PreferencesRequested()),
          ),
          BlocProvider(
            create: (context) => PrefixBloc(prefixRepository)..add(PrefixEvent$PrefixesRequested()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdjectiveIo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const AuthenticationGate(),
    );
  }
}
