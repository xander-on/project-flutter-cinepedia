import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider = FutureProvider.family((ref, int movieId){
    final movieRepository = ref.watch( moviesRespositoryProvider );
    return movieRepository.getYoutubeVideosById(movieId);
});


class VideosFromMovie extends ConsumerWidget{

    final int movieId;

    const VideosFromMovie({
        super.key,
        required this.movieId
    });

    @override
    Widget build(BuildContext context, WidgetRef ref){
        final moviesFromVideo = ref.watch( videosFromMovieProvider(movieId) );

        return moviesFromVideo.when(
            data    : (videos) => _VideosList( videos:videos ),
            error   : (_,__) => const Center(
                child: Text('No se pudo cargar peliculas similares'),
            ),
            loading : () => const Center( child: CircularProgressIndicator(strokeWidth: 2,))
        );
    }
}


Video selectVideoToShow(List<Video> videos) {

    final filteredWithTrailer = videos.where(
        (video) =>
            video.name.toLowerCase().contains("trailer") ||
            video.name.toLowerCase().contains("tráiler")
    );

    final filteredWithTrailerAndDoblado = filteredWithTrailer.where(
        (video) =>video.name.toLowerCase().contains("doblado")
    );

    return filteredWithTrailerAndDoblado.isNotEmpty
            ? filteredWithTrailerAndDoblado.first
            : filteredWithTrailer.isNotEmpty
                ? filteredWithTrailer.first
                : videos.first;
}


class _VideosList extends StatelessWidget {
    final List<Video> videos;

    const _VideosList({
        required this.videos,
    });

    @override
    Widget build(BuildContext context) {

        //* Nada que mostrar
        if ( videos.isEmpty ) return const SizedBox();

        Video videoToShow = selectVideoToShow(videos);

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal:10),
                    child: Text(
                        'Videos',
                        style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)
                    ),
                ),

                _YouTubeVideoPlayer(
                    youtubeId : videoToShow.youtubeKey,
                    name      : videoToShow.name,
                ),
            ]
        );
    }
}


class _YouTubeVideoPlayer extends StatefulWidget {

    final String youtubeId;
    final String name;

    const _YouTubeVideoPlayer({
        required this.youtubeId,
        required this.name
    });

    @override
    State<_YouTubeVideoPlayer> createState() => __YouTubeVideoPlayerState();
}

class __YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {

    late YoutubePlayerController _controller;

    @override
    void initState() {
        super.initState();

        _controller = YoutubePlayerController(
            initialVideoId: widget.youtubeId,
            flags: const YoutubePlayerFlags(
                showLiveFullscreenButton: false,
                mute            : false,
                autoPlay        : false,
                disableDragSeek : true,
                loop            : false,
                isLive          : false,
                forceHD         : false,
                enableCaption   : false,
            )
        );
    }


    @override
    void dispose(){
        _controller.dispose();
        super.dispose();
    }


    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(widget.name),
                    YoutubePlayer(controller: _controller)
                ],
            )
        );
    }
}
