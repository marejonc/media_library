import 'dart:convert';
import 'package:media_library/model/movie.dart';

class MovieResponse {
  MovieResponse({
    required this.search,
    required this.totalResults,
    required this.response,
  });

  List<Movie> search;
  String totalResults;
  String response;

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        search: List<Movie>.from(json["Search"].map((x) => Movie.fromJson(x))),
        totalResults: json["totalResults"],
        response: json["Response"],
      );

  Map<String, dynamic> toJson() => {
        "Search": List<dynamic>.from(search.map((x) => x.toJson())),
        "totalResults": totalResults,
        "Response": response,
      };

  static MovieResponse movieResponseFromJson(String str) =>
      MovieResponse.fromJson(json.decode(str));
  static String movieResponseToJson(MovieResponse data) => json.encode(data.toJson());
}
