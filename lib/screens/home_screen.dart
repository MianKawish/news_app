import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categoryNewsModel.dart';
import 'package:news_app/models/newsChannelHeadlinesModel.dart';
import 'package:news_app/screens/news_details_screen.dart';
import 'package:news_app/view_model/news_view.dart';

enum FilterList {
  bbcNews,
  aryNews,
  independent,
  reuters,
  cnn,
  alJazeera,
  buisenessInsider,
  wired,
  theNextWeb
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('yyyy-MM-dd');
  FilterList? selectedMenu;
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/categoriesScreen");
          },
          icon: Image.asset(
            "assets/category_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (FilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                if (FilterList.buisenessInsider.name == item.name) {
                  name = 'business-insider';
                }
                if (FilterList.wired.name == item.name) {
                  name = 'wired';
                }
                if (FilterList.theNextWeb.name == item.name) {
                  name = 'the-next-web';
                }
                setState(() {});
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                        value: FilterList.bbcNews, child: Text("BBC News")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.buisenessInsider,
                        child: Text("Business Insider")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.aryNews, child: Text("ARY News")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.wired, child: Text("Wired")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.theNextWeb,
                        child: Text("The Next Web")),
                  ])
        ],
        title: Center(
          child: Text(
            "News",
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitCircle(
                    color: Colors.blue,
                    size: 60,
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles?.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailsScreen(
                                    author: snapshot.data!.articles![index].author
                                        .toString(),
                                    content: snapshot.data!.articles![index].content
                                        .toString(),
                                    disription: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    newsDate: snapshot
                                        .data!.articles![index].publishedAt
                                        .toString(),
                                    newsImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newsTitle: snapshot.data!.articles![index].title
                                        .toString(),
                                    source: snapshot.data!.articles![index].source!.name
                                        .toString()),
                              ));
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * .02),
                                height: height * .6,
                                width: width * .9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return Container(
                                        child: const SpinKitCircle(
                                          color: Colors.amber,
                                          size: 50,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          248, 234, 90, .7),
                                      borderRadius: BorderRadius.circular(16)),
                                  width: width * .8,
                                  height: height * .2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * .02),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * .02,
                                        vertical: height * .01),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (context, snapshot) {
                // if (snapshot.hasData == null) {
                //   return SpinKitCircle();
                // }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitCircle(
                    color: Colors.blue,
                    size: 60,
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles?.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailsScreen(
                                    author: snapshot.data!.articles![index].author
                                        .toString(),
                                    content: snapshot.data!.articles![index].content
                                        .toString(),
                                    disription: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    newsDate: snapshot
                                        .data!.articles![index].publishedAt
                                        .toString(),
                                    newsImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newsTitle: snapshot.data!.articles![index].title
                                        .toString(),
                                    source: snapshot.data!.articles![index].source!.name
                                        .toString()),
                              ));

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  height: height * .18,
                                  width: width * .3,
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return Container(
                                      child: const SpinKitCircle(
                                        color: Colors.amber,
                                        size: 50,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      height: height * .18,
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title
                                                .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  format.format(dateTime),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
