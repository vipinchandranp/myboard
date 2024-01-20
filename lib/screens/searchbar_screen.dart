import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/repositories/map_repository.dart';

import '../bloc/map/map_cubit.dart';

class SelectLocationBar extends StatefulWidget {
  @override
  _SelectLocationBarState createState() => _SelectLocationBarState();
}

class _SelectLocationBarState extends State<SelectLocationBar> {
  String? _searchingWithQuery;
  late Iterable<SelectLocationDTO> _lastOptions = <SelectLocationDTO>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Autocomplete<SelectLocationDTO>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          _searchingWithQuery = textEditingValue.text;

          // Use Completer to create a Future with the correct type
          Completer<Iterable<SelectLocationDTO>> completer = Completer();

          // Debounce the search using easy_debounce
          EasyDebounce.debounce(
            'searchDebounce',
            Duration(milliseconds: 500),
            () async {
              // Use Future.delayed to ensure the return type is a Future
              await Future.delayed(Duration.zero);
              final Iterable<SelectLocationDTO> options =
                  await MapRepository().searchPlaces(_searchingWithQuery!);

              // If another search happened after this one, throw away these options.
              // Use the previous options instead and wait for the newer request to
              // finish.
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
        onSelected: (SelectLocationDTO selection) {
          debugPrint('You just selected ${selection.name}');
          context
              .read<MapCubit>()
              .emit(SelectedLocation(selectedLocation: selection));
        },
        displayStringForOption: (SelectLocationDTO option) => option.name,
      ),
    );
  }
}
