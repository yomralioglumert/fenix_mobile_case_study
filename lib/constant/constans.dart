class Constans {
  // https://api.themoviedb.org/3/search/movie?
  // api_key=ae304e3f4d3830d95075ae6914b55ddf&query=watchmen
  static String get BASE_URL => 'https://api.themoviedb.org/3';
  static String get SEARCH_MOVIE_URL => '/search/movie';
  static String get API_KEY => 'ae304e3f4d3830d95075ae6914b55ddf';
  static String IMAGE_URL(double width, double height,String? path) => "https://image.tmdb.org/t/p/w220_and_h330_face/$path"; 
}
