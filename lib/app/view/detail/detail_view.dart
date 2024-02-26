import 'package:app_ft_movies/app/controller/detail/detail_controller.dart';
import 'package:app_ft_movies/app/core/global_color.dart';
import 'package:app_ft_movies/app/view/detail/episode/episode.dart';
import 'package:app_ft_movies/app/view/detail/info/info.dart';
import 'package:app_ft_movies/app/view/detail/info_details/info_details.dart';
import 'package:app_ft_movies/app/view/detail/other_film/other_film.dart';
import 'package:app_ft_movies/app/view/filter/filter_page.dart';
import 'package:app_ft_movies/app/view/home/film_by_category/film_by_category.dart';
import 'package:app_ft_movies/app/widgets/global_image.dart';

import 'package:app_ft_movies/app/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:html' as html;

class DetailView extends StatelessWidget {
  const DetailView({super.key, this.slug, this.name, this.path});
  final String? slug;
  final String? name;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController());
    controller.getFilmDetail(slug: slug ?? "");

    return Visibility(
      visible: MediaQuery.of(context).size.width > 600,
      replacement: ResponsiveApp(
        name: name,
        slug: slug,
        path: path,
      ),
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: GlobalColor.backgroundColor,
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Get.back(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff252836)),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.to(const FilterPage(),
                      transition: Transition.rightToLeft);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff252836)),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            foregroundColor: Colors.white,
            elevation: 0.0,
            backgroundColor: GlobalColor.backgroundColor,
          ),
          // appBar: AppBar(
          //   backgroundColor: GlobalColor.backgroundColor,
          //   centerTitle: true,
          //   title: Text(name??"--",
          //   style: const TextStyle(
          //     color: Colors.white,
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold
          //   ),
          //   ),
          //   foregroundColor: Colors.white,
          // ),
          body: Obx(() {
            final data = controller.filmDetail.value?.pageProps?.data?.item;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: GlobalColor.primary,
                  color: Colors.white,
                ),
              );
            }
            return RefreshIndicator(
              backgroundColor: GlobalColor.backgroundColor,
              color: GlobalColor.primary,
              onRefresh: () async => controller.getFilmDetail(slug: slug ?? ""),
              child: Center(
                child: Container(
                    color: GlobalColor.backgroundColor,
                    width: MediaQuery.of(context).size.width * .85,
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalImage(
                              imageUrl: data.posterUrl,
                              width: MediaQuery.of(context).size.width * .4,
                              height: MediaQuery.of(context).size.height * .5,
                              boxFit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Info(),
                                const SizedBox(
                                  height: 20,
                                ),
                                const InfoDetail(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nội dung phim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            HtmlWidget("${data.content}")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: data.status != "trailer",
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tập phim",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 10,
                              ),
                              Espisode(),
                              
                            ],
                          ),
                        ),
                         const SizedBox(
                                height: 30,
                              ),
                              Visibility(
                                visible: path!=null,
                                child: OtherFilmView(path: path??"",))
                      ],
                    )),
              ),
            );
          })),
    );
  }
}

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key, this.slug, this.name, this.path});
  final String? slug;
  final String? name;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController());
    controller.getFilmDetail(slug: slug ?? "");

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: GlobalColor.backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: GlobalColor.backgroundColor,
        //   centerTitle: true,
        //   title: Text(name??"--",
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold
        //   ),
        //   ),
        //   foregroundColor: Colors.white,
        // ),
        body: Obx(() {
          final data = controller.filmDetail.value?.pageProps?.data?.item;
          if (data == null) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: GlobalColor.primary,
                color: Colors.white,
              ),
            );
          }
          return RefreshIndicator(
            backgroundColor: GlobalColor.backgroundColor,
            color: GlobalColor.primary,
            onRefresh: () async => controller.getFilmDetail(slug: slug ?? ""),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff252836)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Get.to(const FilterPage(),
                            transition: Transition.rightToLeft);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xff252836)),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  centerTitle: true,
                  foregroundColor: Colors.white,
                  elevation: 0.0,
                  backgroundColor: GlobalColor.backgroundColor,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark),
                  expandedHeight: MediaQuery.of(context).size.height * .6,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalImage(
                        imageUrl: data.thumbUrl ?? "",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .6,
                        boxFit: BoxFit.fill,
                      ),
                    ],
                  )),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Info(),
                        // const SizedBox(height: 20,),
                        Visibility(
                          visible: data.status != "trailer",
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              width: MediaQuery.of(context).size.width * .95,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: GlobalColor.primary),
                              child: InkWell(
                                onTap: () async {
                                  await controller.createToken(
                                      name: data.name ?? "",
                                      description: data.content ?? "",
                                      originName: data.originName ?? "",
                                      slug: data.slug ?? "",
                                      thumbnail: data.thumbUrl ?? "",
                                      episode: data.episodes?.first.serverData
                                              ?.first.name ??
                                          "");
                                  Get.to(ChewieVideoPlayer(
                                    slug: data.slug ?? "",
                                    fileName: data.name ?? "--",
                                    episode: data.episodes?.first.serverData
                                            ?.first.name ??
                                        "",
                                    videoUrl: data?.episodes?.first.serverData
                                            ?.first.linkM3u8 ??
                                        "",
                                  ));
                                },
                                child: const Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Xem phim",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const InfoDetail(),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nội dung phim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            HtmlWidget("${data.content}")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: data.status != "trailer",
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tập phim",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 10,
                              ),
                              Espisode(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                            visible: path != null,
                            child: OtherFilmView(
                              path: path ?? "",
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
