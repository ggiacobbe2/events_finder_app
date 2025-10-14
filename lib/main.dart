import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Event {
  final String title;
  final String date;

  Event(this.title, this.date);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Events Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: EventsHomePage(),
    );
  }
}

class EventsHomePage extends StatefulWidget {
  @override
  _EventsHomePageState createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  String searchQuery = '';

  List<Event> events = [ // placeholder events
    Event('Event 1', '10-14-2025'),
    Event('Event 2', '10-31-2025'),
    Event('Event 3', '11-08-2025'),
    Event('Event 4', '12-20-2025'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Event> filteredEvents = events
        .where((event) =>
            event.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Events Finder'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(filteredEvents[index].title),
                      subtitle: Text(filteredEvents[index].date),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}