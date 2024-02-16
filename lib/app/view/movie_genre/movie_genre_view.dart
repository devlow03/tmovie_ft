import 'package:app_ft_movies/app/controller/movie_genre/movie_genre_controller.dart';
import 'package:app_ft_movies/app/core/global_color.dart';
import 'package:app_ft_movies/app/view/detail/detail_view.dart';
import 'package:app_ft_movies/app/view/filter/filter_page.dart';
import 'package:app_ft_movies/app/view/home/card_cinema/card_cinema.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MovieGenreview extends StatelessWidget {
  final String slug;
  
  final String country;
  final String year;
  const MovieGenreview({super.key, required this.slug,  int? selectedYear, required this.country,    required this.year});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final controller = Get.put(MovieGenreController());
    controller.getMovieGenre(slug: slug, country: country, year: year);
    return RefreshIndicator(
      backgroundColor: GlobalColor.backgroundColor,
      color: GlobalColor.primary,
        onRefresh: ()async=>controller.getMovieGenre(slug: slug, country: country, year: year),
      child: Scaffold(
        
          backgroundColor: GlobalColor.backgroundColor,
          
          appBar: AppBar(
            backgroundColor: GlobalColor.backgroundColor,
            foregroundColor: Colors.white,
            title: Obx(() => Text(controller.movieGenre.value?.pageProps?.data?.titlePage??""),),
            actions: [
              InkWell(
              onTap: (){
                
                Get.to(const FilterPage(),transition: Transition.rightToLeft);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal:8.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
            ],
          ),
          body: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx((){
                final isLoading = controller.movieGenre.value==null;
                 final data = controller.movieGenre.value?.pageProps?.data;
                
                // if(data?.items==null){
                //   return Center(
                //     child: CircularProgressIndicator(
                //       strokeWidth: 5,
                //       backgroundColor: GlobalColor.primary,
                //     ),
                //   );
                // }
                if(data?.items?.isEmpty==true){
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Center(
                      child: Text("Rất tiếc không có phim!")
                    ),
                  );
                }
                
                return GridView.builder(
                padding: const EdgeInsets.all(5),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isLoading?16:data?.items?.length ?? 0,
                itemBuilder: (context, index) {
                  final items = data?.items?[index];
                  return Visibility(
                    visible: !isLoading,
                    replacement: SizedBox(
                     width: MediaQuery.of(context).size.width*.4,
                     child: Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: Colors.grey.shade600,
                                child: Container(
                                  decoration: const BoxDecoration(
                                   
                                    color: Colors.grey,
                                  ),
                                ),
                    )
                                
                  ),
                    child: CardCinema(
                      imageLink: items?.thumbUrl ?? "",
                      nameProduct: items?.name,
                      originName: items?.originName ?? "",
                      slug: items?.slug ?? "",
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   childAspectRatio: 5 / 10,
                  crossAxisCount: 8,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
              );
              }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          bottomNavigationBar: Obx((){
            
            
            
            return Visibility(
            visible: controller.totalPage.value!=0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.totalPage.value??0,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return InkWell(
                        onTap: () async{
                          controller.selectIndex.value = index;
                          print(">>>>>>>>>>>>>${controller.selectIndex.value}");
                          controller.movieGenre.value=null;
                          await controller.getMovieGenre(slug: slug,country: country,year: year);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              //  border: Border.all(color: GlobalColor.primary)
                              color: const Color(0xff252836),
                              border: Border.all(
                                  color: controller.selectIndex.value == index
                                      ? GlobalColor.primary
                                      : Colors.transparent)),
                          child: Text("${index + 1}",style: const TextStyle(fontSize: 13),),
                        ),
                      );
                    });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 20,
                    );
                  },
                ),
              ),
            ),
          );
          })
        ),
    );
  }
}