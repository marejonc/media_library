import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key, required this.loggedInUser}) : super(key: key);

  final loggedInUser;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _firestore = FirebaseFirestore.instance;
  late User _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loggedInUser = widget.loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('movies').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              );
            }
            final savedMovies = snapshot.data?.docs;
            List<ListTile> movieTiles = [];
            savedMovies!.map((movie) {
              if (movie['user'] == _loggedInUser.email) {
                final movieTile = ListTile(
                  title: Text(movie['title']),
                  subtitle: Text(movie['year']),
                  trailing: Checkbox(
                    value: movie['isSeen'],
                    onChanged: (value) {
                      setState(() {
                        _firestore
                            .collection('movies')
                            .doc(movie.id)
                            .update({'isSeen': !movie['isSeen']});
                      });
                    },
                  ),
                  onLongPress: () {
                    setState(() {
                      _firestore.collection('movies').doc(movie.id).delete();
                    });
                  },
                );
                movieTiles.add(movieTile);
              }
            }).toList();
            return ListView.separated(
              itemBuilder: (context, index) => movieTiles[index],
              separatorBuilder: (context, index) => const Divider(),
              itemCount: movieTiles.length,
            );
          },
        ));
  }
}
