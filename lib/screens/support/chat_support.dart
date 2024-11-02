import 'package:flutter/material.dart';

class ChatSupportWidget extends StatefulWidget {
  @override
  _ChatSupportWidgetState createState() => _ChatSupportWidgetState();
}

class _ChatSupportWidgetState extends State<ChatSupportWidget> {
  bool isChatOpen = false; // Track if the chatbox is open

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Chatbox if open
        if (isChatOpen)
          Positioned(
            right: 20,
            bottom: 80, // Position the chatbox above the button
            child: _buildChatBox(),
          ),
        // Chat button
        Positioned(
          right: 20,
          bottom: 20, // Keep the button at bottom-right corner
          child: GestureDetector(
            onTap: () {
              setState(() {
                isChatOpen = !isChatOpen; // Toggle chatbox visibility
              });
            },
            child: _buildChatButton(), // Chat button widget
          ),
        ),
      ],
    );
  }

  // Custom shaped chat button with a close icon on it
  Widget _buildChatButton() {
    return Stack(
      alignment: Alignment.topRight, // Align the close button on the top-right of the chat button
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.teal, // Background color for the button
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(0), // Message bubble style shape
            ),
          ),
          child: Icon(
            Icons.message, // Message icon
            color: Colors.white,
            size: 30,
          ),
        ),
        if (isChatOpen) // Show close icon only if the chatbox is open
          Positioned(
            right: -5,
            top: -5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isChatOpen = false; // Close the chatbox
                });
              },
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Chatbox UI
  Widget _buildChatBox() {
    return Container(
      width: 300,
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Support Chat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isChatOpen = false; // Close chatbox
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text('Chat content goes here...'), // Placeholder for chat content
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
