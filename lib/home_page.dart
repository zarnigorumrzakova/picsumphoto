import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'details_page.dart';
import 'photo.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photo> photos = [];
  bool isLoading = false;
  late RefreshController refreshController;
  int page = 0;
  bool isupwardEnabled = false;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = RefreshController();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if(scrollController.offset>=500) {
        setState(() {
          isupwardEnabled = true;
        });
      }
      else {
        setState(() {
          isupwardEnabled = false;
        });
      }
    });
    _initialFetchPhotos();
  }

  Future<void> _initialFetchPhotos() async {
    setState(() {
      isLoading = true;
    });
    final Uri url =
    Uri.https('picsum.photos', '/v2/list', {'page': '${++page}'});
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      photos = jsonList.map((json) => Photo.fromJson(json)).toList();
      isLoading = false;
    });
  }

  Future<void> _moreFetchPhotos() async {
    final Uri url =
    Uri.https('picsum.photos', '/v2/list', {'page': '${++page}','limit' : '15'});
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      photos.addAll(jsonList.map((json) => Photo.fromJson(json)).toList());
    });
    refreshController.loadComplete();
  }

  Future<void> refrefshPhotos() async {
    page = 0;
    final Uri url =
    Uri.https('picsum.photos', '/v2/list', {'page': '${++page}','limit' : '15'});
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      photos = jsonList.map((json) => Photo.fromJson(json)).toList();
    });
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    refreshController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(

        ),
      )
          : SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onLoading: _moreFetchPhotos,
        onRefresh: refrefshPhotos,
        child: ListView.builder(
            itemCount: photos.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPage(photo: photos[index])));
                },
                child: Column(children: [
                  // Image.network('${photos[index].downloadUrl}'),
                  CachedNetworkImage(
                    imageUrl: '${photos[index].downloadUrl}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Text('${photos[index].author}'),
                ]),
              );
            }),
      ),
      floatingActionButton: isupwardEnabled ? FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(0, duration: Duration(milliseconds: 700), curve: Curves.easeInOut);
        },
        child: Icon(Icons.keyboard_arrow_up,size: 40,),
      ) : null,
    );
  }
}
