import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:equatable/equatable.dart';

class StatisticsState extends Equatable {
  final GameStatistics statistics;
  final bool isLoading;

  const StatisticsState({
    this.statistics = const GameStatistics(),
    this.isLoading = false,
  });

  StatisticsState copyWith({GameStatistics? statistics, bool? isLoading}) {
    return StatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [statistics, isLoading];
}
