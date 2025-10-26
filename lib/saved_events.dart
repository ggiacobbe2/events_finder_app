import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedEventsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SavedEventsPage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _SavedEventsPageState createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> savedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    final events = await dbHelper.getSavedEvents();
    setState(() {
      savedEvents = events;
    });
  }

  Future<void> _deleteSavedEvent(int id) async {
    await dbHelper.deleteSavedEvent(id);
    _loadSavedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Saved Events',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round),
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
                final eventDate = DateTime.tryParse(event['date'] ?? '');
                final dateText = eventDate != null
                    ? '${eventDate.month}/${eventDate.day}/${eventDate.year}'
                    : 'date';
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: 3,
                  child: ListTile(
                    title: Text(event['title'] ?? ''),
                    subtitle: Text('${event['location']}, $dateText'),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark),
                      onPressed: () {
                        _deleteSavedEvent(event['id'] as int);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}