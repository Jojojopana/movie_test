import 'package:async/async.dart' as async;
import 'package:movies_flutter/api/models/movie.dart';
import 'package:movies_flutter/api/models/movie_credits.dart';
import 'package:movies_flutter/api/tmdb_api.dart';
import 'package:movies_flutter/configs.dart';
import 'package:movies_flutter/ui/movie_detail/models/movie_detail.dart';
import 'package:movies_flutter/ui/movie_detail/models/cast.dart' as ui;
import 'package:movies_flutter/ui/movie_detail/movie_detail_page.dart';
import 'package:movies_flutter/ui/state.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final MovieDetailParams params;
  final TmdbApi tmdbApi;

  UiState<MovieDetailUiModel> get initialState => Success(
        MovieDetailUiModel(
          params.id,
          params.title,
          params.backdropUrl,
          null,
          null,
          null,
          null,
          null,
          null,
        ),
      );

  final _state = PublishSubject<UiState<MovieDetailUiModel>>();
  Stream<UiState<MovieDetailUiModel>> get state => _state.stream;

  final _error = PublishSubject<String>();
  Stream<String> get error => _error.stream;

  MovieDetailBloc(this.params, this.tmdbApi) {
    _load(params.id);
  }

  void _load(int id) async {
    final movieResult = await async.Result.capture(tmdbApi.getMovie(params.id));
    final creditsResult =
        await async.Result.capture(tmdbApi.getMovieCredits(params.id));

    if (movieResult.isError || creditsResult.isError) {
      _error.add('Error loading movie details. Please try again.');
      return;
    }

    final movie = movieResult.asValue!.value;
    final credits = creditsResult.asValue!.value;

    _state.add(Success(_createMovieDetailUiModel(movie, credits)));
  }

  void retry() {
    _load(params.id);
  }

  static MovieDetailUiModel _createMovieDetailUiModel(
    Movie movie,
    Credits credits,
  ) {
    return MovieDetailUiModel(
      movie.id,
      movie.title,
      '${BuildConfigs.BaseImageUrlOriginal}${movie.backdropPath}',
      movie.overview,
      movie.voteAverage,
      movie.genres?.map((e) => e.name).toList() ?? List.empty(),
      movie.runtime,
      credits.cast
          .map((e) => ui.Cast(
                e.name,
                '${BuildConfigs.BaseImageUrlW200}${e.profilePath}',
              ))
          .toList(),
      movie.releaseDate,
    );
  }

  void dispose() {
    _state.close();
    _error.close();
  }
}
