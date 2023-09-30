


import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( moviesRespositoryProvider).getNowPlaying;
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  final fetchMoreMovies = ref.watch( moviesRespositoryProvider).getPopular;
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  final fetchMoreMovies = ref.watch( moviesRespositoryProvider).getUpcoming;
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  final fetchMoreMovies = ref.watch( moviesRespositoryProvider).getTopRated;
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


typedef MovieCallback = Future<List<Movie>> Function({ int page });

class MoviesNotifier extends StateNotifier<List<Movie>>{

  int currentPage = 0;
  bool isLoading  = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies
  }): super([]);

  Future<void> loadNextPage() async{

    if( isLoading ) return;

    isLoading = true;
    // print('loading more movies');
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies( page: currentPage );
    state = [...state, ...movies];
    await Future.delayed(const Duration(microseconds: 300));
    isLoading = false;
  }
}