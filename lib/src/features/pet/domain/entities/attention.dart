import 'package:equatable/equatable.dart';

class AttentionEntity extends Equatable {
  final String? id;
  final DateTime? date;
  final int? nextDate;
  final DateTime? nextDateDuration;
  final String? product;
  final String? type;
  final String? petId;

  const AttentionEntity({
    this.id,
    this.date,
    this.nextDate,
    this.nextDateDuration,
    this.petId,
    this.product,
    this.type,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        nextDate,
        nextDateDuration,
        petId,
        product,
        type,
      ];
}
