class Movie {
  Movie({
    required this.title,
    required this.year,
  });

  String title;
  String year;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        title: json["Title"],
        year: json["Year"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Year": year,
      };
}
