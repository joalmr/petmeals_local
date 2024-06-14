import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/attention.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/attention/add_attention_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/attention/delete_attention_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/attention/get_attentions_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/attention/get_next_attentions_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/pet/add_pet_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/pet/delete_pet_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/pet/get_pets_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/pet/load_pets_usecase.dart';
import 'package:petmeals_local/src/features/pet/domain/use_cases/pet/update_pet_usecase.dart';

class PetProvider extends ChangeNotifier {
  final AddPetUsecase addPetUsecase;
  final DeletePetUsecase deletePetUsecase;
  final GetPetsUsecase getPetsUsecase;
  final LoadPetsUsecase loadPetsUsecase;
  final UpdatePetUsecase updatePetUsecase; //
  final AddAttentionUseCase addAttentionUseCase;
  final DeleteAttentionUsecase deleteAttentionUsecase;
  final GetAttentionsUsecase getAttentionsUsecase;
  final GetNextAttentionsUsecase getNextAttentionsUsecase;

  PetProvider(
    this.addPetUsecase,
    this.deletePetUsecase,
    this.getPetsUsecase,
    this.loadPetsUsecase,
    this.updatePetUsecase, //
    this.addAttentionUseCase,
    this.deleteAttentionUsecase,
    this.getAttentionsUsecase,
    this.getNextAttentionsUsecase,
  );

  String userId = "";

  PetEntity? pet;
  List<PetEntity> myPets = [];

  List<AttentionEntity> attentions = [];
  List<AttentionEntity> nextAttentions = [];

  Stream<List<PetEntity>> loadStream() {
    return loadPetsUsecase(userId);
  }

  getMyPets() async {
    myPets = [];

    myPets = await getPetsUsecase(userId);
    notifyListeners();
  }

  Future<bool> addPet(PetEntity newPet, File img) {
    return addPetUsecase(newPet, img)
        .then((value) => value.id != null ? true : false);
  }

  Future<PetEntity?> updatePet(PetEntity updatePet, File? img) async {
    final update = await updatePetUsecase(updatePet, img);
    return update;
  }

  Future<PetEntity?> foodPet(PetEntity updatePet) async {
    final petUpdated = await updatePetUsecase(updatePet, null);
    return petUpdated;
  }

  Future<PetEntity?> actionPet(PetEntity updatePet) async {
    final petUpdated = await updatePetUsecase(updatePet, null);
    return petUpdated;
  }

  deletePet(PetEntity pet) async {
    deletePetUsecase(pet.id!, pet.photo!);
  }

  getAttentions(String petId) async {
    attentions = [];

    attentions = await getAttentionsUsecase(petId);
    notifyListeners();
  }

  getNextAttentions(String petId) async {
    nextAttentions = [];

    nextAttentions = await getNextAttentionsUsecase(petId);
    notifyListeners();
  }

  addAttention(AttentionEntity attention) async {
    await addAttentionUseCase(attention);

    await getMyPets();
    runAttentions(attention.petId!);
  }

  deleteAttention(String id, String petId) async {
    await deleteAttentionUsecase(id);
    runAttentions(petId);
  }

  //Mascotas
  runPet(PetEntity myPet) {
    setPet(myPet);
    getNextAttentions(myPet.id!);
  }

  setPet(PetEntity myPet) {
    pet = myPet;
    notifyListeners();
  }

  //Atenciones
  runAttentions(String petId) {
    getAttentions(petId);
    getNextAttentions(petId);
  }

  notAttention(int index) {
    attentions.removeAt(index);
    notifyListeners();
  }
}
