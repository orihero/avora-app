import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String phoneNumber, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userJson = await remoteDataSource.login(phoneNumber, password);
        await localDataSource.cacheUser(userJson);
        final user = UserModel.fromJson(userJson);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String phoneNumber,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userJson = await remoteDataSource.register(
          name,
          phoneNumber,
          password,
        );
        await localDataSource.cacheUser(userJson);
        final user = UserModel.fromJson(userJson);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final user = UserModel.fromJson(cachedUser);
        return Right(user);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
