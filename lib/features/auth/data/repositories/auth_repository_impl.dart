import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/phone_to_email.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final email = phoneToSyntheticEmail(phone);
      await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name.isNotEmpty ? name : null,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Sign up failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final email = phoneToSyntheticEmail(phone);
      await remoteDataSource.login(email: email, password: password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final hasSession = await remoteDataSource.hasSession();
      return Right(hasSession);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Auth check failed: ${e.toString()}'));
    }
  }
}
