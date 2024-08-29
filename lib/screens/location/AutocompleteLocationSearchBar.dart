import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/repositories/map_repository.dart';
import 'package:myboard/repositories/user_repository.dart';

class AutocompleteLocationSearchBar extends StatefulWidget {
  @override
  _AutocompleteLocationSearchBarState createState() =>
      _AutocompleteLocationSearchBarState();
}

class _AutocompleteLocationSearchBarState
    extends State<AutocompleteLocationSearchBar> {
  late Iterable<SelectLocationDTO> _lastOptions = <SelectLocationDTO>[];
  String? _searchingWithQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), // Round edges
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
      child: Autocomplete<SelectLocationDTO>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          _searchingWithQuery = textEditingValue.text;
          Completer<Iterable<SelectLocationDTO>> completer = Completer();
          EasyDebounce.debounce(
            'searchDebounce',
            Duration(milliseconds: 500),
            () async {
              await Future.delayed(Duration.zero);
              final Iterable<SelectLocationDTO> options =
                  await MapRepository().searchPlaces(_searchingWithQuery!);

              if (_searchingWithQuery != textEditingValue.text) {
                completer.complete(_lastOptions);
              } else {
                _lastOptions = options;
                completer.complete(_lastOptions);
              }
            },
          );

          return completer.future;
        },
        onSelected: (SelectLocationDTO selection) async {
          await UserRepository().saveLocation(selection);
          context
              .read<MapCubit>()
              .emit(SelectedLocation(selectedLocation: selection));
        },
        displayStringForOption: (SelectLocationDTO option) {
          return '${option.name}';
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.location_on), // Location mark
              hintText: 'Search location',
              contentPadding: EdgeInsets.all(10.0),
            ),
          );
        },
      ),
    );
  }
}
