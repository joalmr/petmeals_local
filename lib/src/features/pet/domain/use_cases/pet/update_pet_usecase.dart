import 'dart:io';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:petmeals_local/src/features/pet/domain/repositories/pet_repository.dart';

class UpdatePetUsecase {
  final PetRepository repository;

  UpdatePetUsecase({required this.repository});

  Future<PetEntity> call(PetEntity pet, File? img) {
    return repository.updatePet(pet, img);
  }
}
