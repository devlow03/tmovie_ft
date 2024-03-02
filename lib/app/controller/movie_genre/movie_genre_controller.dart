import 'package:app_ft_movies/app/data/apis/services.dart';
import 'package:app_ft_movies/app/data/repository/get_film_by_category.dart';
import 'package:get/get.dart';

class MovieGenreController extends GetxController{
  
  final Services api = Get.find();
  
  Rxn<GetFilmByCategory>movieGenre = Rxn();
 Rxn<int> selectPage = Rxn(0);
  Rxn<int> selectIndex = Rxn(0);
  Rxn<int> totalPage = Rxn();
  RxBool isFocusPage = RxBool(false);
  RxBool isFocusMenu = RxBool(false);
  

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    
    
  }

  
  
  Future<GetFilmByCategory?>getMovieGenre({String? slug, String? countries, String? years})async{
    if(slug!=null){
      movieGenre.value = await api.getMovieGenre(path: slug, page: (selectIndex.value??0)+1,country: countries,year: years);
    movieGenre.refresh();
    final double itemLength = (movieGenre.value?.pageProps?.data?.params?.pagination?.totalItems??0) / (movieGenre.value?.pageProps?.data?.params?.pagination?.totalItemsPerPage??0);
    totalPage.value = itemLength.round();
    return movieGenre.value;
    }
    
    else{final category = Get.parameters['category'];
    final country = Get.parameters['country'];
    final year = Get.parameters['year'];
    movieGenre.value = await api.getMovieGenre(path: category??"", page: (selectIndex.value??0)+1,country: country,year: year);
    movieGenre.refresh();
    final double itemLength = (movieGenre.value?.pageProps?.data?.params?.pagination?.totalItems??0) / (movieGenre.value?.pageProps?.data?.params?.pagination?.totalItemsPerPage??0);
    totalPage.value = itemLength.round();
    return movieGenre.value;}
  }
}