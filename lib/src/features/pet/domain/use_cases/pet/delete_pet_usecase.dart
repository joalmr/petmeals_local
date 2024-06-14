import 'package:petmeals_local/src/features/pet/domain/repositories/pet_repository.dart';

class DeletePetUsecase {
  final PetRepository repository;

  DeletePetUsecase({required this.repository});

  Future<void> call(String petId, String pathImage) {
    return repository.deleteImage(petId, pathImage);
  }
}
