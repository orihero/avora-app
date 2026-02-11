import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String phone,
    required String password,
  }) =>
      repository.login(phone: phone, password: password);
}
