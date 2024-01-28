import 'package:flutter/material.dart';
import 'package:myboard/models/location_search.dart';

class LocationSearchDelegate extends SearchDelegate<SelectLocationDTO?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Pass null when the user cancels the search
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement the search results here
    // This method is called when the user submits a query
    // You should return the selected location or null based on the user's choice

    // For example, you can return a Placeholder widget for demonstration purposes
    return Placeholder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions here
    // This method is called as the user types in the search bar
    // You should return a list of suggestions based on the current query

    // For example, you can return a Placeholder widget for demonstration purposes
    return Placeholder();
  }
}
