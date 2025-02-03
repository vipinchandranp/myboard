import 'package:flutter/material.dart';
import 'package:myboard/screens/display/stepper_screen.dart'; // Import the new widget
import 'package:myboard/models/display/bdisplay.dart';
import 'package:myboard/screens/display/media_carousel.dart';
import 'package:myboard/screens/display/status_indicator.dart';
import 'package:myboard/utils/utility.dart';
import 'package:myboard/widgets/round_button.dart';
import '../qrcode/show_qr_code.dart';
import 'associated_boards_screen.dart';
import 'current_board_playing.dart';

class DisplayCardWidget extends StatelessWidget {
  final BDisplay display;

  const DisplayCardWidget({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          MediaCarouselWidget(display: display),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  display.displayName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                StatusIndicatorWidget(status: display.status),
                const SizedBox(height: 6),
                Text(
                  'Created on: ${Utility.formatDate(display.createdDateAndTime)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),

                // Add the price in a large font with Indian Rupee symbol
                if (display.price != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Price: ₹${display.price!.toStringAsFixed(2)} / hour', // Price display with Indian Rupee symbol
                      style: const TextStyle(
                        fontSize: 28, // Large font size for the price
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // You can change the color to suit your theme
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Add the displayPin here in a large font
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Pin: ${display.displayPin}',
                    style: const TextStyle(
                      fontSize: 32, // Large font size for the displayPin
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Board List Section
                AssociatedBoardsScreen(displayId: display.displayId),

                const SizedBox(height: 16),

                // Horizontally scrollable buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RoundedButton(
                        icon: Icons.book_online,
                        label: 'Book Display',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StepperScreen(display: display),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      RoundedButton(
                        icon: Icons.qr_code,
                        label: 'Show QR Code',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowQRCode(
                                data: display.displayId,
                                title: 'QR Code for ${display.displayName}',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      RoundedButton(
                        icon: Icons.play_arrow,
                        label: 'Show Currently Playing',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CurrentBoardPlaying(
                                displayId: display.displayId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
