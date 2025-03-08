import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myboard/repository/common_repository.dart';
import '../../../models/common/AbstractFilterRequest.dart';
import '../../../models/common/AbstractFilterResponse.dart';
import '../../../utils/ItemType.dart';

class SearchCommonItems extends StatefulWidget {
  const SearchCommonItems({Key? key}) : super(key: key);

  @override
  _SearchCommonItemsState createState() => _SearchCommonItemsState();
}

class _SearchCommonItemsState extends State<SearchCommonItems> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<AbstractFilterResponse> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.length >= 3) {
        _fetchSearchResults(query);
      } else {
        setState(() {
          _searchResults.clear();
          _errorMessage = '';
        });
      }
    });
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Create filter request object
      final filterRequest = AbstractFilterRequest(
        searchText: query,
        page: 0,
        size: 10,
      );

      // Pass the context to the CommonService instance
      final results = await CommonService(context).searchCommonItems(filterRequest);
      setState(() {
        _searchResults = results ?? [];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching search results. Please try again.';
      });
      debugPrint('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildItem(AbstractFilterResponse item) {
    IconData icon;
    switch (item.itemType) {
      case ItemType.DISPLAY:
        icon = Icons.display_settings;
        break;
      case ItemType.BOARD:
        icon = Icons.dashboard;
        break;
      default:
        icon = Icons.help_outline;
    }

    return ListTile(
      leading: Icon(icon),
      title: Text(item.id),
      subtitle: Text(item.itemType.toString()), // Adjusted for better readability
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Auto Complete"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _errorMessage.isNotEmpty
                  ? Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
                  : _searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return _buildItem(_searchResults[index]);
                },
              )
                  : const Center(
                child: Text('No results found.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
