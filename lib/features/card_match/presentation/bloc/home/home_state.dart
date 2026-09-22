import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final GameStatistics statistics;
  final bool isLoading;

  const HomeState({
    this.statistics = const GameStatistics(),
    this.isLoading = false,
  });

  HomeState copyWith({GameStatistics? statistics, bool? isLoading}) {
    return HomeState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading];
}
