import 'package:integratorproject/features/domain/entities/user/user_entity.dart';
import 'package:integratorproject/features/domain/repository/firebase_repository.dart';

class GetUsersUseCase {
  final FirebaseRepository repository;

  GetUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity userEntity) {
    return repository.getUsers(userEntity);
  }
}