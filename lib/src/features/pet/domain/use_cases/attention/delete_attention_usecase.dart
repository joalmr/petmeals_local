import 'package:petmeals_local/src/features/pet/domain/repositories/attention_repository.dart';

class DeleteAttentionUsecase {
  final AttentionRepository repository;

  DeleteAttentionUsecase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteAttention(id);
  }
}
