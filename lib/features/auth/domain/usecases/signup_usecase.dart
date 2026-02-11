import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String phone,
    required String password,
  }) =>
      repository.signUp(name: name, phone: phone, password: password);
}