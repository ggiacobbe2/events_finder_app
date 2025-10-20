import 'package:flutter/material.dart';

class SavedEventsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SavedEventsPage({Key? key, required this.isDarkMode, required this.toggleTheme}) : super(key: key);

  @override
  _SavedEventsPageState createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  List<Map<String, String>> savedEvents = [ // placeholder saved events
    {'title': 'Event 1', 'date': '2025-10-18', 'location': 'New York'},
    {'title': 'Event 2', 'date': '2025-11-08', 'location': 'Los Angeles'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Saved Events'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: savedEvents.isEmpty
          ? Center(
              child: Text(
                'No saved events yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: savedEvents.length,
              itemBuilder: (context, index) {
                final event = savedEvents[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: 3,
                  child: ListTile(
                    title: Text(event['title']!),
                    subtitle: Text('${event['date']} - ${event['location']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark),
                      onPressed: () {
                        setState(() {
                          savedEvents.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}