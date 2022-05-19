import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:media_library/utilities/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/movie.dart';
import '../model/movie_response.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.loggedInUser}) : super(key: key);

  final loggedInUser;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _firestore = FirebaseFirestore.instance;
  late User _loggedInUser;
  int _currentPage = 1;
  int _totalPages = 1;
  String _title = 'abc';
  String _newTitle = '';
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _loggedInUser = widget.loggedInUser;
  }

  final _refreshController = RefreshController(initialRefresh: true);
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  Future<bool> _getMovieData(title, {isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    } else if (_currentPage >= _totalPages) {
      _refreshController.loadNoData();
      return false;
    }

    final uri =
        Uri.parse('$kRestApiMainUrl?apikey=$kRestApiKey&s=$title&type=movie&page=$_currentPage');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = MovieResponse.movieResponseFromJson(response.body);
      if (isRefresh) {
        _movies = result.search;
      } else {
        _movies.addAll(result.search);
      }
      _currentPage++;
      _totalPages = int.parse(result.totalResults) % 10;

      setState(() {});

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            elevation: 5.0,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _newTitle = value,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter Movie Title',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    _title = _newTitle;
                    final result = await _getMovieData(_title, isRefresh: true);
                    if (result) {
                      _refreshController.refreshCompleted();
                    } else {
                      _refreshController.refreshFailed();
                    }
                    _searchController.clear();

                    await Future.delayed(const Duration(milliseconds: 300));
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              onRefresh: () async {
                final result = await _getMovieData(_title, isRefresh: true);
                if (result) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
                _searchController.clear();
              },
              onLoading: () async {
                final result = await _getMovieData(_title);
                if (result) {
                  _refreshController.loadComplete();
                } else {
                  _refreshController.loadFailed();
                }
              },
              child: ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return ListTile(
                      title: Text(movie.title),
                      subtitle: Text(movie.year),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          _firestore.collection('movies').add({
                            'title': movie.title,
                            'year': movie.year,
                            'user': _loggedInUser.email,
                            'isSeen': false,
                          });
                        },
                      ));
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _movies.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
