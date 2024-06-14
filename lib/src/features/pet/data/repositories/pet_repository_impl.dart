import 'dart:async';
import 'dart:io';
import 'package:petmeals_local/src/features/pet/data/datasources/pet_local.dart';
import 'package:petmeals_local/src/features/pet/data/models/pet_model.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:petmeals_local/src/features/pet/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetLocalDataSource remoteDataSource;

  PetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PetEntity> addPet(PetEntity newPet, File image) async {
    final response = await remoteDataSource.addPet(newPet, image);
    return response as PetEntity;
  }

  @override
  Future<void> deleteImage(String petId, String pathImage) async {
    return await remoteDataSource.deletePet(petId, '');
  }

  @override
  Future<List<PetEntity>> getPets(String userId) async {
    final response = await remoteDataSource.getPets(userId);
    return response as List<PetEntity>;
  }

  @override
  Stream<List<PetEntity>> loadPets(String userId) {
    final transformer =
        StreamTransformer<List<PetModel>, List<PetEntity>>.fromHandlers(
      handleData: (data, sink) =>
          sink.add(data.map((model) => PetEntity.toEntity(model)).toList()),
    );

    return remoteDataSource.loadPets(userId).transform(transformer);
  }

  @override
  Future<PetEntity> updatePet(PetEntity pet, File? img) async {
    final response = await remoteDataSource.updatePet(pet, img);
    return response as PetEntity;
  }
}
