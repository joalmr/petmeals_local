import 'package:petmeals_local/src/features/pet/data/datasources/attention_local.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/attention.dart';
import 'package:petmeals_local/src/features/pet/domain/repositories/attention_repository.dart';

class AttentionRepositoryImpl implements AttentionRepository {
  final AttentionLocalDataSource remoteDataSource;

  AttentionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AttentionEntity> addAttention(AttentionEntity attention) async {
    AttentionEntity response = await remoteDataSource.addAttention(attention);
    return response;
  }

  @override
  Future<void> deleteAttention(String id) async {
    return await remoteDataSource.deleteAttention(id);
  }

  @override
  Future<List<AttentionEntity>> getAttentions(String petId) async {
    List<AttentionEntity> response =
        await remoteDataSource.getAttentions(petId);
    return response;
  }

  @override
  Future<List<AttentionEntity>> getNextAttentions(String petId) async {
    List<AttentionEntity> response =
        await remoteDataSource.getNextAttentions(petId);
    return response;
  }
}
