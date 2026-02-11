import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appwrite/appwrite.dart';
import '../network/network_info.dart';
import '../network/appwrite_config.dart';
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
import '../../features/auction/data/datasources/auction_remote_datasource.dart';
import '../../features/auction/data/datasources/auction_remote_datasource_impl.dart';
import '../../features/auction/data/repositories/auction_repository_impl.dart';
import '../../features/auction/data/repositories/bid_repository_impl.dart';
import '../../features/auction/data/repositories/participation_request_repository_impl.dart';
import '../../features/auction/data/repositories/vote_repository_impl.dart';
import '../../features/auction/data/repositories/winner_confirmation_repository_impl.dart';
import '../../features/auction/domain/repositories/auction_repository.dart';
import '../../features/auction/domain/repositories/bid_repository.dart';
import '../../features/auction/domain/repositories/participation_request_repository.dart';
import '../../features/auction/domain/repositories/vote_repository.dart';
import '../../features/auction/domain/repositories/winner_confirmation_repository.dart';
import '../../features/auction/domain/usecases/get_auction_by_id.dart';
import '../../features/auction/domain/usecases/get_auction_products.dart';
import '../../features/auction/domain/usecases/get_auction_variable.dart';
import '../../features/auction/domain/usecases/get_bids_for_product.dart';
import '../../features/auction/domain/usecases/get_featured_auction.dart';
import '../../features/auction/domain/usecases/get_my_participation_requests.dart';
import '../../features/auction/domain/usecases/get_my_votes.dart';
import '../../features/auction/domain/usecases/get_winner_confirmations_for_product.dart';
import '../../features/auction/domain/usecases/place_bid.dart';
import '../../features/auction/domain/usecases/request_participation.dart';
import '../../features/auction/domain/usecases/submit_vote.dart';
import '../../features/auction/presentation/bloc/auction_hub_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
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

  getIt.registerLazySingleton<AppwriteConfig>(
    () => AppwriteConfig.fromEnvironment(),
  );

  // Shared Appwrite client and Account (session is stored on this client)
  getIt.registerLazySingleton<Client>(() {
    final config = getIt<AppwriteConfig>();
    final client = Client();
    if (config.isConfigured) {
      client.setEndpoint(config.endpoint);
      client.setProject(config.projectId);
    }
    return client;
  });
  getIt.registerLazySingleton<Account>(() => Account(getIt<Client>()));

  // Features - Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: getIt<Client>(),
      account: getIt<Account>(),
      config: getIt<AppwriteConfig>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));

  // Bloc
  getIt.registerFactory(
    () => AuthBloc(checkAuthStatusUseCase: getIt()),
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

  // Features - Auction
  // Data source (shared Client so auction requests use the logged-in user's session)
  getIt.registerLazySingleton<AuctionRemoteDataSource>(
    () => AuctionRemoteDataSourceImpl(
      config: getIt<AppwriteConfig>(),
      client: getIt<Client>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuctionRepository>(
    () => AuctionRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<VoteRepository>(
    () => VoteRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ParticipationRequestRepository>(
    () => ParticipationRequestRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<BidRepository>(
    () => BidRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<WinnerConfirmationRepository>(
    () => WinnerConfirmationRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetFeaturedAuction(getIt()));
  getIt.registerLazySingleton(() => GetAuctionById(getIt()));
  getIt.registerLazySingleton(() => GetAuctionProducts(getIt()));
  getIt.registerLazySingleton(() => GetAuctionVariable(getIt()));
  getIt.registerLazySingleton(() => GetMyVotes(getIt()));
  getIt.registerLazySingleton(() => SubmitVote(getIt()));
  getIt.registerLazySingleton(() => GetMyParticipationRequests(getIt()));
  getIt.registerLazySingleton(() => RequestParticipation(getIt()));
  getIt.registerLazySingleton(() => GetBidsForProduct(getIt()));
  getIt.registerLazySingleton(() => PlaceBid(getIt()));
  getIt.registerLazySingleton(() => GetWinnerConfirmationsForProduct(getIt()));

  // Bloc
  getIt.registerFactory(
    () => AuctionHubBloc(
      getFeaturedAuction: getIt(),
      getAuctionProducts: getIt(),
      getAuctionVariable: getIt(),
      getMyVotes: getIt(),
      getMyParticipationRequests: getIt(),
      getBidsForProduct: getIt(),
      getWinnerConfirmationsForProduct: getIt(),
      submitVote: getIt(),
      requestParticipation: getIt(),
      placeBid: getIt(),
    ),
  );
}
