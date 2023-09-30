import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}


class HomeViewState extends ConsumerState<HomeView>
with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);
    if( initialLoading ) return const FullScreenLoader();

    final slideshowMovies  = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final upcomingMovies   = ref.watch( upcomingMoviesProvider );
    final topRatedMovies   = ref.watch( topRatedMoviesProvider );

    if( slideshowMovies.isEmpty ) return const Center( child :CircularProgressIndicator() );

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            // centerTitle: true,
            titlePadding: EdgeInsets.all(0),
            title: CustomAppbar()
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  // const CustomAppbar(),

                    MoviesSlideshow(movies: slideshowMovies),

                    MovieHorizontalListView(
                        movies: nowPlayingMovies,
                        title: 'En cines',
                        subTitle: 'Actuales',
                        loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                    ),

                    MovieHorizontalListView(
                        movies: upcomingMovies,
                        title: 'Proximamente',
                        subTitle: 'En este mes',
                        loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                    ),

                //   MovieHorizontalListView(
                //     movies: popularMovies,
                //     title: 'Populares',
                //     loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                //   ),

                    MovieHorizontalListView(
                        movies: topRatedMovies,
                        title: 'Mejor calificadas',
                        subTitle: 'Desde siempre',
                        loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                    ),

                    const SizedBox( height: 50,)
                ],
              );
            },
            childCount: 1
          )
        )
      ],
    );
  }

    @override
    bool get wantKeepAlive => true;
}


