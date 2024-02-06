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
  @GET("/new-film")
  Future<GetNewFilm> getNewFilm();


   @GET("/list-film")
  Future<GetFilmByCategory> getFilmByCategory(
      {@Query('path') required String path,
      
      @Query('page') required int? page
      });
  
  @GET("/genre")
  Future<GetFilmByCategory> getMovieGenre(
      {@Query('path') required String path,
      @Query('page') required int? page,
      @Query('country') required String? country,
      @Query('year') required String? year
      });

  @GET("/details/{path}")
  Future<GetFilmDetails>getFilmDetails({@Path('path') required String path});

  @GET("/search/{keyword}")
  Future<GetFilmByCategory>getSearch({@Path("keyword") required String keyWord,@Query('page') int? page});

  
}


