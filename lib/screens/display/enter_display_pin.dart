import 'package:flutter/material.dart';

import '../play/play_widget.dart';

class EnterDisplayPinWidget extends StatefulWidget {
  const EnterDisplayPinWidget({Key? key}) : super(key: key);

  @override
  _EnterDisplayPinWidgetState createState() => _EnterDisplayPinWidgetState();
}

class _EnterDisplayPinWidgetState extends State<EnterDisplayPinWidget> {
  final List<TextEditingController> _pinControllers =
  List.generate(6, (_) => TextEditingController());

  void _prepopulatePin() {
    // Prepopulate the PIN fields with a default value, e.g., "egx3Hy"
    String pin = "xWSFyh";
    for (int i = 0; i < pin.length && i < _pinControllers.length; i++) {
      _pinControllers[i].text = pin[i];
    }
  }

  void _clearPin() {
    // Clear all PIN fields
    for (final controller in _pinControllers) {
      controller.clear();
    }
  }

  String _getDisplayPin() {
    // Collect the entered PIN from all controllers
    return _pinControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight / 3; // 1/3 of the screen height

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500, // Set the maximum width for the card
            ),
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min, // Minimize the height of the card
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_pinControllers.length, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _pinControllers[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '-',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _prepopulatePin,
                          child: const Text('Prefill PIN'),
                        ),
                        ElevatedButton(
                          onPressed: _clearPin,
                          child: const Text('Clear PIN'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0), // Add space before the play button
                    ElevatedButton.icon(
                      onPressed: () {
                        final displayPin = _getDisplayPin();
                        if (displayPin.length == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayWidget(displayPin: displayPin),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter a valid 6-character PIN'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
