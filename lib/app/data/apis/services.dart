import 'dart:io';
import 'package:app_ft_movies/app/core/global_data.dart';
import 'package:app_ft_movies/app/data/repository/get_film_by_category.dart';
import 'package:app_ft_movies/app/data/repository/get_film_details.dart';
import 'package:app_ft_movies/app/data/repository/get_new_film.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'services.g.dart';

@RestApi(baseUrl: GlobalData.baseUrl)
abstract class Services {
  factory Services(Dio dio, {String baseUrl}) = _Services;
  @GET("/danh-sach/phim-moi-cap-nhat")
  Future<GetNewFilm> getNewFilm({@Query("page") required String? page});

  @GET("/phim/{slug}")
  Future<GetFilmDetails>getFilmDetails({@Path('slug') required String slug});
}

@RestApi(baseUrl: GlobalData.baseUrlCc)
abstract class Services2 {
  factory Services2(Dio dio, {String baseUrl}) = _Services2;
  @GET("/_next/data/s4OlXy8jONoHVWAT5vg7b/danh-sach/{path}.json")
  Future<GetFilmByCategory> getFilmByCategory(
      {@Path('path') required String path,
      @Query('slug') required String slug,
      @Query('page') required int? page
      });
  
  @GET("/_next/data/s4OlXy8jONoHVWAT5vg7b/the-loai/{path}.json")
  Future<GetFilmByCategory> getMovieGenre(
      {@Path('path') required String path,
      @Query('slug') required String slug,
      @Query('page') required int? page
      });

  @GET("/_next/data/s4OlXy8jONoHVWAT5vg7b/phim/{path}.json")
  Future<GetFilmDetails>getFilmDetails({@Path('path') required String path, @Query('slug') required String slug});

  @GET("/_next/data/s4OlXy8jONoHVWAT5vg7b/tim-kiem.json")
  Future<GetFilmByCategory>getSearch({@Query("keyword") required String keyWord});
}
