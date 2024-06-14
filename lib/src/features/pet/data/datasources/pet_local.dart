import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petmeals_local/src/core/error/failure.dart';
import 'package:petmeals_local/src/features/pet/data/datasources/_image_storage.dart';
import 'package:petmeals_local/src/features/pet/data/models/pet_model.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:uuid/uuid.dart';

abstract class PetLocalDataSource {
  Stream<List<PetModel>> loadPets(String userId);
  Future<List<PetModel>> getPets(String userId);
  Future<PetModel> addPet(PetEntity newPet, File image);
  Future<PetModel> updatePet(PetEntity pet, File? image);
  Future<void> deletePet(String petId, String pathImage);
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  // PetLocalDataSourceImpl() {
  //   Hive.initFlutter();
  // }

  @override
  Future<PetModel> addPet(PetEntity newPet, File image) async {
    try {
      String uuid = const Uuid().v4();

      final addPet = PetModel.fromEntity(newPet).copyWith(id: uuid);

      final addedPet = await updatePet(addPet, image);

      return addedPet;
    } on Exception catch (e) {
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<void> deletePet(String petId, String pathImage) async {
    try {
      Box<dynamic> box = await Hive.openBox('myPets');

      box.delete(petId);
      deleteImage(pathImage);
    } on Exception catch (e) {
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<List<PetModel>> getPets(String userId) async {
    Box<dynamic> box = await Hive.openBox('myPets');

    final myPets = box.values.map((pet) => PetModel.fromJson(pet)).toList();

    return myPets;
  }

  @override
  Stream<List<PetModel>> loadPets(String userId) async* {
    Box<dynamic> box = await Hive.openBox('myPets');

    box.watch();

    yield box.values.map((pet) => PetModel.fromJson(pet)).toList();
  }

  @override
  Future<PetModel> updatePet(PetEntity pet, File? image) async {
    try {
      String? stringPath;

      Box<dynamic> box = await Hive.openBox('myPets');

      if (image != null) {
        stringPath = await uploadImage(image, pet.id!);
        pet = PetModel.fromEntity(pet).copyWith(photo: stringPath);
      }

      box.put(pet.id, PetModel.fromEntity(pet).toJson());

      return PetModel.fromEntity(pet);
    } on Exception catch (e) {
      throw LocalFailure(message: e.toString());
    }
  }
}
