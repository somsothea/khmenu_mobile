import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

String movieModelToJson(MovieModel data) => json.encode(data.toJson());

class MovieModel {
  late List<Search> search;
  late String totalResults;
  late String response;

  MovieModel({
    required this.search,
    required this.totalResults,
    required this.response,
  });

  // factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
  //     search: List<Search>.from(json["Search"].map((x) => Search.fromJson(x))),
  //     totalResults: json["totalResults"],
  //     response: json["Response"],
  // );

  MovieModel.fromJson(Map<String, dynamic> json) {
    response = json["Response"];
    if (response == "True") {
      search = List<Search>.from(json["Search"].map((x) => Search.fromJson(x)));
      totalResults = json["totalResults"];
    } else {
      search = [];
      totalResults = "0";
    }
  }

  Map<String, dynamic> toJson() => {
        "Search": List<dynamic>.from(search.map((x) => x.toJson())),
        "totalResults": totalResults,
        "Response": response,
      };
}

class Search {
  String title;
  String year;
  String imdbId;
  String type;
  String poster;

  Search({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        title: json["Title"],
        year: json["Year"],
        imdbId: json["imdbID"],
        type: json["Type"],
        poster: json["Poster"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Year": year,
        "imdbID": imdbId,
        "Type": type,
        "Poster": poster,
      };
}
