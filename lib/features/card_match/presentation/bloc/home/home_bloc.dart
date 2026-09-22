import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetStatisticsUseCase _getStatisticsUseCase;

  HomeBloc({required GetStatisticsUseCase getStatisticsUseCase})
    : _getStatisticsUseCase = getStatisticsUseCase,
      super(const HomeState()) {
    on<LoadHomeStats>(_onLoadHomeStats);
  }

  void _onLoadHomeStats(LoadHomeStats event, Emitter<HomeState> emit) {
    emit(state.copyWith(isLoading: true));

    var statistics = GameStatistics();

    for (final difficulty in GameDifficulty.values) {
      final difficultyStats = _getStatisticsUseCase(difficulty);

      statistics = statistics.copyWithDifficulty(difficultyStats);
    }

    emit(state.copyWith(statistics: statistics, isLoading: false));
  }
}
