import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wife_gift/common/api/auth_interceptor.dart';
import 'package:wife_gift/common/api/dio_client.dart';
import 'package:wife_gift/common/config/env_config.dart';
import 'package:wife_gift/common/storage/token_storage.dart';
import 'package:wife_gift/features/auth/data/data_sources/auth_data_source_impl.dart';
import 'package:wife_gift/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wife_gift/features/auth/logic/auth_bloc.dart';
import 'package:wife_gift/features/auth/widgets/authentication_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.validate();

  final tokenStorage = TokenStorage(const FlutterSecureStorage());
  final authInterceptor = AuthInterceptor(tokenStorage, EnvConfig.baseUrl);
  final dioClient = DioClient(authInterceptor);
  final authDataSource = AuthDataSourceImpl(dioClient.dio);
  final authRepository = AuthRepositoryImpl(authDataSource, tokenStorage);

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository)..add(AuthEvent$StatusChecked()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdjectiveIo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AuthenticationGate(),
    );
  }
}
