import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:movies_flutter/ui/home/home_bloc.dart';
import 'package:movies_flutter/ui/home/models/movie_item.dart';
import 'package:movies_flutter/ui/home/models/tv_item.dart';
import 'package:movies_flutter/ui/movie_detail/movie_detail_page.dart';
import 'package:movies_flutter/ui/state.dart';
import 'package:movies_flutter/widgets/movie_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = Provider.of<HomeBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        initialData: Loading(),
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.data is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data is Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading movies. Please try again.'),
                  ElevatedButton(
                    onPressed: () => bloc.retry(),
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(
                  bottom: false,
                  child: SizedBox(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Movies',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.nightlight_round),
                      onPressed: () {},
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'Popular Movies',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 284,
                  child: StreamBuilder(
                      initialData: List<MovieItemUiModel>.empty(),
                      stream: bloc.popularMovies,
                      builder: (context, snapshot) {
                        final _data = snapshot.data as List<MovieItemUiModel>;

                        return ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            return MovieWidget(
                              _data[index].id,
                              _data[index].name,
                              _data[index].poster,
                              DateFormat.yMMMMd('en_US')
                                  .format(_data[index].date),
                              onClickListener: (movieId) =>
                                  Navigator.of(context).pushNamed(
                                MovieDetailPage.routeName,
                                arguments: MovieDetailParams(
                                  _data[index].id,
                                  _data[index].name,
                                  _data[index].backdrop,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(width: 8),
                        );
                      }),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'TV Shows',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 284,
                  child: StreamBuilder(
                    initialData: List<TvShowUiModel>.empty(),
                    stream: bloc.popularTvShows,
                    builder: (context, snapshot) {
                      final _data = snapshot.data as List<TvShowUiModel>;

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return MovieWidget(
                            _data[index].id,
                            _data[index].name,
                            _data[index].poster,
                            DateFormat.yMMMMd('en_US')
                                .format(_data[index].date),
                            onClickListener: (movieId) =>
                                Navigator.of(context).pushNamed(
                              MovieDetailPage.routeName,
                              arguments: MovieDetailParams(
                                _data[index].id,
                                _data[index].name,
                                _data[index].backdrop,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(width: 8),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'TV Shows',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                /* SizedBox(
                  height: 284,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      return MovieWidget(
                        _movies[index].id,
                        _movies[index].name,
                        _movies[index].poster,
                        DateFormat.yMMMMd('en_US').format(_movies[index].date),
                        onClickListener: (movieId) =>
                            Navigator.of(context).pushNamed(
                          MovieDetailPage.routeName,
                          arguments: MovieDetailParams(
                            _movies[index].id,
                            _movies[index].name,
                            _movies[index].backdrop,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(width: 8),
                  ),
                ), */
                SafeArea(
                  top: false,
                  child: SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}