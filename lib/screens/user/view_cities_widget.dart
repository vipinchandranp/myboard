import 'package:flutter/material.dart';
import '../../api_models/user_cities_response.dart';
import '../../repository/googlemap_repository.dart';
import '../../themes/app_theme.dart';

class ViewCitiesWidget extends StatefulWidget {
  @override
  _ViewCitiesWidgetState createState() => _ViewCitiesWidgetState();
}

class _ViewCitiesWidgetState extends State<ViewCitiesWidget> {
  final TextEditingController _cityController = TextEditingController();
  List<CitiesResponse> _cities = [];
  bool _isLoading = false;

  Future<void> _fetchCities(String query) async {
    if (query.length < 3) return; // Wait for at least 3 characters

    setState(() {
      _isLoading = true;
    });

    final googleMapService = GoogleMapService(context);
    try {
      final List<CitiesResponse>? cities = await googleMapService.getCities(query);

      if (cities != null) {
        setState(() {
          _cities = cities;
        });
      }
    } catch (e) {
      print('Error fetching cities: $e'); // Handle errors appropriately
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location', style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white, // Set background color to white
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _cityController,
                  onChanged: (query) {
                    if (query.length >= 3) {
                      _fetchCities(query);
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppTheme.secondaryColor),
                    filled: Theme.of(context).inputDecorationTheme.filled,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                        color: AppTheme.secondaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.secondaryColor,
                    ),
                  )
                      : _cities.isEmpty
                      ? Center(
                    child: Text(
                      'No cities found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                      : ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: Theme.of(context).cardTheme.elevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Theme.of(context).cardTheme.color,
                        child: ListTile(
                          leading: Icon(Icons.location_city, color: AppTheme.secondaryColor),
                          title: Text(
                            city.cityName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          onTap: () {
                            Navigator.pop(context, city);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
