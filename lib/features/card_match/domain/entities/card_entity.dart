import 'package:equatable/equatable.dart';

class CardEntity extends Equatable {
  final int id;
  final String value;
  final bool isFlipped;
  final bool isMatched;

  const CardEntity({
    required this.id,
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardEntity copyWith({bool? isFlipped, bool? isMatched}) {
    return CardEntity(
      id: id,
      value: value,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  List<Object?> get props => [id, value, isFlipped, isMatched];
}
