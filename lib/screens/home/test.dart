
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'What do you want to hear?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Podcasts'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Moods & Activities'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    childAspectRatio: 2.5,
                    children: [
                      CategoryCard(title: 'Moods', color: Colors.purple),
                      CategoryCard(title: 'Activities', color: Colors.green),
                      CategoryCard(title: 'Love', color: Colors.pink),
                      CategoryCard(title: 'Workout', color: Colors.orange),
                      CategoryCard(title: 'Party', color: Colors.blue),
                      CategoryCard(title: 'Travel', color: Colors.teal),
                    ],
                  ),
                  SectionHeader(title: 'Music By Genre'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    childAspectRatio: 2.5,
                    children: [
                      CategoryCard(title: 'Pop', color: Colors.pink),
                      CategoryCard(title: 'Alternative', color: Colors.green),
                      CategoryCard(title: 'Rock', color: Colors.red),
                      CategoryCard(title: 'Kollywood', color: Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
          ),
          NowPlayingBar(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'FIND',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'LIBRARY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'ALEXA',
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextButton(onPressed: () {}, child: Text('See more'))
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final Color color;

  CategoryCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class NowPlayingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListTile(
        leading: Image.network(
          'https://via.placeholder.com/50',
          fit: BoxFit.cover,
        ),
        title: Text('What happened to Facebook'),
        subtitle: Text('TechStuff'),
        trailing: IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {},
        ),
      ),
    );
  }
}