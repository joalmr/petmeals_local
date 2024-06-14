import 'package:hive_flutter/hive_flutter.dart';
import 'package:petmeals_local/src/core/error/failure.dart';
import 'package:petmeals_local/src/features/pet/data/models/attention_model.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/attention.dart';
import 'package:uuid/uuid.dart';

abstract class AttentionLocalDataSource {
  Future<List<AttentionModel>> getAttentions(String petId);
  Future<AttentionModel> addAttention(AttentionEntity attention);
  Future<void> deleteAttention(String id);
  Future<List<AttentionModel>> getNextAttentions(String petId);
}

class AttentionLocalDataSourceImpl implements AttentionLocalDataSource {
  @override
  Future<AttentionModel> addAttention(AttentionEntity attention) async {
    try {
      Box<dynamic> boxAttentions = await Hive.openBox('myAttentions');

      String uuid = const Uuid().v4();

      attention = AttentionModel.fromEntity(attention).copyWith(id: uuid);

      boxAttentions.put(
          attention.id, AttentionModel.fromEntity(attention).toJson());

      return AttentionModel.fromEntity(attention);
    } on Exception catch (e) {
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteAttention(String id) async {
    try {
      Box<dynamic> boxAttentions = await Hive.openBox('myAttentions');

      boxAttentions.delete(id);
    } on Exception catch (e) {
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<List<AttentionModel>> getAttentions(String petId) async {
    Box<dynamic> boxAttentions = await Hive.openBox('myAttentions');

    final myAttentions = boxAttentions.values
        .where((element) => element['petId'] == petId)
        .map((attention) => AttentionModel.fromJson(attention))
        .take(10)
        .toList();

    return myAttentions;
  }

  @override
  Future<List<AttentionModel>> getNextAttentions(String petId) async {
    Box<dynamic> boxAttentions = await Hive.openBox('myAttentions');

    final myAttentions = boxAttentions.values
        .where((element) => element['petId'] == petId)
        .map((attention) => AttentionModel.fromJson(attention))
        .toList();

    AttentionModel? deworming;
    AttentionModel? grooming;
    AttentionModel? vaccination;
    List<AttentionModel> nextlist = [];

    if (myAttentions.isNotEmpty) {
      for (var element in myAttentions) {
        final DateTime next = element.nextDateDuration!;
        switch (element.type) {
          case 'deworming':
            {
              if (deworming == null) {
                deworming = element;
              } else {
                if (next.isBefore(deworming.nextDateDuration!) &&
                    next.isAfter(
                        DateTime.now().add(const Duration(days: -7)))) {
                  deworming = element;
                }
              }
            }
            break;
          case 'grooming':
            {
              if (grooming == null) {
                grooming = element;
              } else {
                if (next.isBefore(grooming.nextDateDuration!) &&
                    next.isAfter(
                        DateTime.now().add(const Duration(days: -7)))) {
                  grooming = element;
                }
              }
            }
            break;
          case 'vaccine':
            {
              if (vaccination == null) {
                vaccination = element;
              } else {
                if (next.isBefore(vaccination.nextDateDuration!) &&
                    next.isAfter(
                        DateTime.now().add(const Duration(days: -7)))) {
                  vaccination = element;
                }
              }
            }
            break;
          // default:
          //   return [];
        }
      }
    }

    if (deworming != null) {
      nextlist.add(deworming);
    }
    if (grooming != null) {
      nextlist.add(grooming);
    }
    if (vaccination != null) {
      nextlist.add(vaccination);
    }

    return nextlist;
  }
}
