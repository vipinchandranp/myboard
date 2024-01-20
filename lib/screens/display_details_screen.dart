import 'package:flutter/material.dart';
import 'package:myboard/models/display_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayDetailsWidget extends StatefulWidget {
  @override
  _DisplayDetailsWidgetState createState() => _DisplayDetailsWidgetState();
}

class _DisplayDetailsWidgetState extends State<DisplayDetailsWidget> {
  DisplayDetails? fetchedDetails;

  @override
  void initState() {
    super.initState();
    fetchDisplayDetails();
  }

  Future<void> fetchDisplayDetails() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          fetchedDetails = DisplayDetails.fromJson(data);
        });
      } else {
        // Handle error case
        print('Failed to fetch display details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: fetchedDetails != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${fetchedDetails!.latitude}, ${fetchedDetails!.longitude}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('Description: ${fetchedDetails!.description}'),
                  SizedBox(height: 8.0),
                  Text('Rating: ${fetchedDetails!.rating}'),
                  SizedBox(height: 16.0),
                  Text(
                    'Comments:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fetchedDetails!.comments!.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User: ${comment.username}'),
                            Text('Comment: ${comment.text}'),
                            // Change 'commentText' to 'text'
                            Text(
                                'Timestamp: ${comment.date.toIso8601String()}'),
                            // Access 'date' property
                            SizedBox(height: 8.0),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : CircularProgressIndicator(), // Show a loading indicator while fetching data
      ),
    );
  }
}
