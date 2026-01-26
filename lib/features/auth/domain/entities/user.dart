import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [id, phoneNumber, name, email];
}
