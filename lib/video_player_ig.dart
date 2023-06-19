import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// const String apiUrl =
// 'https://graph.instagram.com/6455384274500205/media?access_token=IGQVJVQmQxUDdld3ZAycXRRaURTaG1ZANUpodThSeXpYUjg2SzhyX1paQnNlR0tzVjQ5UUZA1VUdYd3RJdFcwUWFELTduSmhyZAGpUZAExPNGxtTThFX3hiOEJQY1FuNEM1OXItQVZAJZAXZAR&fields=id,timestamp,media_url,media_type,username';

class InstagramPost {
  final String? id;
  final DateTime? timestamp;
  final String? mediaUrl;
  final String? mediaType;
  final String? username;

  InstagramPost({
    this.id,
    this.timestamp,
    this.mediaUrl,
    this.mediaType,
    this.username,
  });

  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      username: json['username'],
    );
  }
}

class InstagramScreenVideo extends StatefulWidget {
  @override
  _InstagramScreenVideoState createState() => _InstagramScreenVideoState();
}

class _InstagramScreenVideoState extends State<InstagramScreenVideo> {
  List<InstagramPost> posts = [];

  Future<void> fetchInstagramPosts() async {
    final response = await http.get(
      Uri.parse(
          'https://graph.instagram.com/6455384274500205/media?access_token=IGQVJVQmQxUDdld3ZAycXRRaURTaG1ZANUpodThSeXpYUjg2SzhyX1paQnNlR0tzVjQ5UUZA1VUdYd3RJdFcwUWFELTduSmhyZAGpUZAExPNGxtTThFX3hiOEJQY1FuNEM1OXItQVZAJZAXZAR&fields=id,timestamp,media_url,media_type,username'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        posts = (jsonData['data'] as List<dynamic>).map((data) {
          return InstagramPost.fromJson(data);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Posts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => fetchInstagramPosts(),
              child: const Text('Fetch Posts'),
            ),
            const SizedBox(height: 20),
            if (posts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Column(
                      children: [
                        if (post.mediaType == 'IMAGE')
                          Image.network(post.mediaUrl!),
                        if (post.mediaType == 'VIDEO')
                          SizedBox(
                            height: 400,
                            child: Chewie(
                              controller: ChewieController(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        post.mediaUrl!),
                                aspectRatio: 4 / 6,
                                autoInitialize: true,
                                looping: true,
                                autoPlay: false,
                                errorBuilder: (context, errorMessage) {
                                  return Center(
                                    child: Text(
                                      errorMessage,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ID: ${post.id}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Timestamp: ${post.timestamp}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Media Type: ${post.mediaType}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Username: ${post.username}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
