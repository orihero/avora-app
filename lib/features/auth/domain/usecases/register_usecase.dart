import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String name,
    String phoneNumber,
    String password,
  ) async {
    return await repository.register(name, phoneNumber, password);
  }
}
