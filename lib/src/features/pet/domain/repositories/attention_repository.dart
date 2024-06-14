import 'package:petmeals_local/src/features/pet/domain/entities/attention.dart';

abstract class AttentionRepository {
  Future<List<AttentionEntity>> getAttentions(String petId);
  Future<List<AttentionEntity>> getNextAttentions(String petId);
  Future<AttentionEntity> addAttention(AttentionEntity attention);
  Future<void> deleteAttention(String id);
}
