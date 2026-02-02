import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/get_products_by_category.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/model_viewer/data/datasources/model_asset_datasource.dart';
import '../../features/model_viewer/data/repositories/model_repository_impl.dart';
import '../../features/model_viewer/domain/repositories/model_repository.dart';
import '../../features/model_viewer/domain/usecases/load_model_asset.dart';
import '../../features/model_viewer/presentation/bloc/model_viewer_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection container
Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // Features - Products
  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetProductsByCategory(getIt()));

  // Bloc
  getIt.registerFactory(
    () => ProductBloc(
      getProducts: getIt(),
      getProductsByCategory: getIt(),
    ),
  );

  // Features - Onboarding
  // Repository
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sharedPreferences: getIt()),
  );

  // Bloc
  getIt.registerFactory(() => OnboardingBloc(getIt()));

  // Features - Model Viewer
  // Data source
  getIt.registerLazySingleton<ModelAssetDataSource>(
    () => ModelAssetDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ModelRepository>(
    () => ModelRepositoryImpl(dataSource: getIt()),
  );

  // Use case
  getIt.registerLazySingleton(() => LoadModelAsset(getIt()));

  // Bloc
  getIt.registerFactory(() => ModelViewerBloc(loadModelAsset: getIt()));

  // Features - Auth
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));

  // Bloc
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
}
