import 'dart:io';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';

abstract class PetRepository {
  Future<PetEntity> addPet(PetEntity newPet, File image);
  Future<void> deleteImage(String petId, String pathImage);
  Stream<List<PetEntity>> loadPets(String userId);
  Future<List<PetEntity>> getPets(String userId);
  Future<PetEntity> updatePet(PetEntity pet, File? img);
}
