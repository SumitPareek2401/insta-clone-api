import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// API endpoint
const String loginEndpoint = '';
const String userDetailsEndpoint = '';
const String userPostsEndpoint = '';

class InstagramApiService {
  Future<String?> login(String username, String password) async {
    final response = await http.post(Uri.parse(loginEndpoint), body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String token) async {
    final response = await http.get(Uri.parse(userDetailsEndpoint), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> fetchUserPosts(String token) async {
    final response = await http.get(Uri.parse(userPostsEndpoint), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['posts'];
    } else {
      return null;
    }
  }
}

class InstagramScreen extends StatefulWidget {
  @override
  _InstagramScreenState createState() => _InstagramScreenState();
}

class _InstagramScreenState extends State<InstagramScreen> {
  InstagramApiService apiService = InstagramApiService();
  String? token;
  Map<String, dynamic>? userDetails;
  List<dynamic>? userPosts;

  Future<void> loginToInstagram() async {
    final loggedInToken = await apiService.login('your_username', 'your_password');
    setState(() {
      token = loggedInToken;
    });
  }

  Future<void> fetchUserDetailsAndPosts() async {
    final userDetailsData = await apiService.fetchUserDetails(token!);
    final userPostsData = await apiService.fetchUserPosts(token!);
    setState(() {
      userDetails = userDetailsData;
      userPosts = userPostsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => loginToInstagram(),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => fetchUserDetailsAndPosts(),
              child: const Text('Fetch Details and Posts'),
            ),
            const SizedBox(height: 20),
            if (userDetails != null)
              Column(
                children: [
                  Text('Name: ${userDetails!['name']}'),
                  Text('Username: ${userDetails!['username']}'),
                  Text('Followers: ${userDetails!['followers']}'),
                  Text('Following: ${userDetails!['following']}'),
                  Text('Posts: ${userDetails!['posts_count']}'),
                ],
              ),
            if (userPosts != null)
              Expanded(
                child: ListView.builder(
                  itemCount: userPosts!.length,
                  itemBuilder: (context, index) {
                    final post = userPosts![index];
                    return Column(
                      children: [
                        Image.network(post['images'][0]),
                        Text('Caption: ${post['caption']}'),
                        Text('Like Count: ${post['like_count']}'),
                        if (post['comments'] != null)
                          Column(
                            children: [
                              for (var comment in post['comments'])
                                Text('Comment: ${comment['text']}'),
                            ],
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