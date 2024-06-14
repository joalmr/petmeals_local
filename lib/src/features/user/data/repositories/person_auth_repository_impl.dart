import 'package:petmeals_local/src/features/user/data/datasources/person_auth_remote.dart';
import 'package:petmeals_local/src/features/user/domain/repositories/person_auth_repository.dart';

class PersonAuthRepositoryImpl implements PersonAuthRepository {
  final PersonAuthRemoteDataSource remoteDataSource;
  PersonAuthRepositoryImpl({required this.remoteDataSource});
}
