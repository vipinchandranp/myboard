import 'package:flutter/material.dart';
import '../../api_models/user_cities_response.dart';
import '../../repository/googlemap_repository.dart';
class ViewCitiesWidget extends StatefulWidget {
  @override
  _ViewCitiesWidgetState createState() => _ViewCitiesWidgetState();
}

class _ViewCitiesWidgetState extends State<ViewCitiesWidget> {
  final TextEditingController _cityController = TextEditingController();
  List<CitiesResponse> _cities = [];
  List<CitiesResponse> _filteredCities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    setState(() {
      _isLoading = true;
    });

    final googleMapService = GoogleMapService(context);
    final List<CitiesResponse>? cities = await googleMapService.getCities();

    if (cities != null) {
      setState(() {
        _cities = cities;
        _filteredCities = cities;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _cities
          .where((city) =>
          city.cityName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Autocomplete<CitiesResponse>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<CitiesResponse>.empty();
              }
              _filterCities(textEditingValue.text);
              return _filteredCities;
            },
            displayStringForOption: (CitiesResponse option) => option.cityName,
            onSelected: (CitiesResponse selectedCity) {
              Navigator.pop(context, selectedCity); // Return the selected city when closing the dialog
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  labelText: 'Search Cities',
                  border: OutlineInputBorder(),
                ),
              );
            },
            optionsViewBuilder:
                (context, onSelected, Iterable<CitiesResponse> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  child: Container(
                    height: 200,
                    child: ListView(
                      children: options.map((CitiesResponse city) {
                        return ListTile(
                          title: Text(city.cityName),
                          onTap: () => onSelected(city),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
