import 'package:petmeals_local/src/features/pet/domain/entities/attention.dart';
import 'package:petmeals_local/src/features/pet/domain/repositories/attention_repository.dart';

class AddAttentionUseCase {
  final AttentionRepository repository;

  AddAttentionUseCase({required this.repository});

  Future<AttentionEntity> call(AttentionEntity attention) {
    return repository.addAttention(attention);
  }
}
