import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>> >((ref) {
  final actorsRepository = ref.watch( actorRepositoryProvider );
  return ActorsByMovieNotifier( getActors: actorsRepository.getActorByMovie );
});

/* 
  {
    '505642': <Actor>[],
    '505643': <Actor>[],
  }
*/

typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>>{
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors,
  }): super({});

  Future<void> loadActors( String movieId ) async {
    if( state[movieId] != null ) return;

    // print('Realizando peticion http');
    final List<Actor> actors = await getActors( movieId );
    state = { ...state, movieId:actors };
  } 
}