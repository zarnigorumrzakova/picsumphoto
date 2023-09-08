import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'photo.dart';


class DetailsPage extends StatefulWidget {
  final Photo photo;

  const DetailsPage({super.key, required this.photo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('${widget.photo.author}', style: const TextStyle(fontSize: 20),),
      ),
      body: Column(
        children: [
           CachedNetworkImage(
            imageUrl: '${widget.photo.downloadUrl}',

          ),
          SizedBox(height: 60,),
          ElevatedButton(

            onPressed: () async {
              launchUrl(Uri.parse('${widget.photo.url}'));
            },

            child: Text('Show', style: TextStyle(fontSize: 20,

                color: Colors.black,
                decoration: TextDecoration.underline),


            ),
          ),

        ],
      ),


    );
  }
}
