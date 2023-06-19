import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sync_ventures_ig_api/video_player_ig.dart';

// const String apiUrl = 'https://graph.instagram.com/6455384274500205?access_token=IGQVJVQmQxUDdld3ZAycXRRaURTaG1ZANUpodThSeXpYUjg2SzhyX1paQnNlR0tzVjQ5UUZA1VUdYd3RJdFcwUWFELTduSmhyZAGpUZAExPNGxtTThFX3hiOEJQY1FuNEM1OXItQVZAJZAXZAR&fields=account_type,username,media_count';

class InstagramUser {
  final String? accountType;
  final String? username;
  final int? mediaCount;

  InstagramUser({this.accountType, this.username, this.mediaCount});

  factory InstagramUser.fromJson(Map<String, dynamic> json) {
    return InstagramUser(
      accountType: json['account_type'],
      username: json['username'],
      mediaCount: json['media_count'],
    );
  }
}

class InstagramScreennew extends StatefulWidget {
  @override
  _InstagramScreennewState createState() => _InstagramScreennewState();
}

class _InstagramScreennewState extends State<InstagramScreennew> {
  InstagramUser? user;

  Future<void> fetchInstagramUser() async {
    final response = await http.get(
      Uri.parse(
        'https://graph.instagram.com/6455384274500205?access_token=IGQVJVQmQxUDdld3ZAycXRRaURTaG1ZANUpodThSeXpYUjg2SzhyX1paQnNlR0tzVjQ5UUZA1VUdYd3RJdFcwUWFELTduSmhyZAGpUZAExPNGxtTThFX3hiOEJQY1FuNEM1OXItQVZAJZAXZAR&fields=account_type,username,media_count',
      ),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        user = InstagramUser.fromJson(jsonData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram User'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => fetchInstagramUser(),
              child: const Text('Fetch User Details'),
            ),
            const SizedBox(height: 20),
            if (user != null)
              Column(
                children: [
                  Text(
                    'Account Type: ${user!.accountType}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Username: ${user!.username}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Media Count: ${user!.mediaCount}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return InstagramScreenVideo();
                    },
                  ),
                );
              },
              child: const Text('Fetch Media Details'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
