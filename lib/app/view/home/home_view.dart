import 'package:app_ft_movies/app/controller/home/home_controller.dart';
import 'package:app_ft_movies/app/controller/search/search_widget_controller.dart';
import 'package:app_ft_movies/app/core/global_color.dart';
import 'package:app_ft_movies/app/view/filter/filter_page.dart';
import 'package:app_ft_movies/app/view/history/history_view.dart';

import 'package:app_ft_movies/app/view/home/film_by_category/film_by_category.dart';

import 'package:app_ft_movies/app/view/home/slider/slider_cinema.dart';
import 'package:app_ft_movies/app/view/search/search_view.dart';
import 'package:app_ft_movies/app/widgets/search_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabItem = [
      {"slug": "phim-bo", "title": "Phim bộ"},
      {"slug": "phim-le", "title": "Phim lẻ"},
      {"slug": "tv-shows", "title": "TV Shows"},
      {"slug": "hoat-hinh", "title": "Hoạt hình"},
      {"slug": "phim-vietsub", "title": "Phim vietsub"},
      {"slug": "phim-thuyet-minh", "title": "Phim thuyết minh"},
      // {"slug": "phim-long-tieng", "title": "Phim lồng tiếng"},
      {"slug": "phim-bo-dang-chieu", "title": "Phim bộ đang chiếu"},
      {"slug": "phim-hoan-thanh", "title": "Phim trọn bộ"},
      // {"slug": "phim-sap-chieu", "title": "Phim sắp chiếu"},
    ];
    final searchController = Get.put(SearchWidgetController());
    final controller = Get.put(HomeController());
    ScrollController scrollController = ScrollController();
    return GetBuilder<HomeController>(
      init: controller,
      builder: (controller) {
        return DefaultTabController(
          length: tabItem.length,
          initialIndex: controller.tabIndex.value ?? 0,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: GlobalColor.backgroundColor,
            body: RefreshIndicator(
              backgroundColor: GlobalColor.backgroundColor,
              color: GlobalColor.primary,
              onRefresh: () async {
                searchController.isSearch.value=false;
                scrollController.jumpTo(0);
                await controller.getFilm(
                    slug: tabItem[controller.tabIndex.value ?? 0]['slug']);
                controller.getFilmByCategory(
                    slug: tabItem[controller.tabIndex.value ?? 0]['slug']);
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: MediaQuery.of(context).size.width < 600?true:false,
                    centerTitle: false,
                    title: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            indicatorWeight: 1,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            onTap: (ind) async {
                              searchController.isSearch.value=false;
                              controller.pathFilm.value = tabItem[ind]['slug'];
                              controller.tabIndex.value = ind;
                              scrollController.jumpTo(0);
                              await controller.getFilm(
                                  slug: tabItem[ind]['slug']);
                              controller.getFilmByCategory(
                                  slug: tabItem[ind]['slug']);
                            },
                            tabs: List<Widget>.generate(tabItem.length,
                                (int index) {
                              return Tab(
                                text: tabItem[index]["title"],
                              );
                            }),
                          ),
                        ),
                        MediaQuery.of(context).size.width >= 800?Expanded(child: SearchWidget()):SizedBox(),
                      ],
                    ),

                    actions: [
                      IconButton(
                          onPressed: () => Get.to(FilterPage()),
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                          ))
                    ],
                    bottom: MediaQuery.of(context).size.width < 800 ? PreferredSize(
    preferredSize: Size.fromHeight(56.0),
    child: Row(
      children: [
        Expanded(
          child: SearchWidget(),
        ),
      ],
    ),
  ) : null,
                    // elevation: 0.0,
                    backgroundColor: GlobalColor.backgroundColor,
                    // systemOverlayStyle: const SystemUiOverlayStyle(
                    //     statusBarBrightness: Brightness.dark),
                    // expandedHeight: MediaQuery.of(context).size.height * .8,
                    // flexibleSpace: const FlexibleSpaceBar(
                    //   background: SliderCinema(),
                    // ),
                  ),
                  SliverToBoxAdapter(
                    child: SliderCinema(),
                  ),
                  Obx(() => Visibility(
                    visible: searchController.isSearch.value==true,
                    replacement: const FilmByCategory(),
                    child: SearchView(),
                  ),)
                    
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
