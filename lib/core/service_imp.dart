import 'package:dio/dio.dart';
import 'package:fenix_mobile_case_study/core/base_remote_source.dart';
import 'package:fenix_mobile_case_study/constant/constans.dart';
import 'package:fenix_mobile_case_study/model/movies_list_model.dart';

class ServiceImp extends BaseRemoteSource  {

  Future<MoviesListModel> getMoviesList() {
    var dioCall = dioClient.get(Constans.SEARCH_MOVIE_URL,queryParameters: {"api_key": Constans.API_KEY,  "query": "watchmen"});
     try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseMovieListResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  MoviesListModel _parseMovieListResponse(
      Response<dynamic> response) {
    return MoviesListModel.fromJson(response.data);
  }
}