import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/statistics/statistics_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/statistics/statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatisticsUseCase _getStatisticsUseCase;

  StatisticsBloc({required GetStatisticsUseCase getStatisticsUseCase})
    : _getStatisticsUseCase = getStatisticsUseCase,
      super(const StatisticsState()) {
    on<LoadStatistics>(_onLoadStatistics);
  }

  void _onLoadStatistics(LoadStatistics event, Emitter<StatisticsState> emit) {
    emit(state.copyWith(isLoading: true));

    var statistics = GameStatistics();

    for (final difficulty in GameDifficulty.values) {
      final difficultyStats = _getStatisticsUseCase(difficulty);

      statistics = statistics.copyWithDifficulty(difficultyStats);
    }

    emit(state.copyWith(statistics: statistics, isLoading: false));
  }
}
