import 'package:flutter/material.dart';
import 'database_helper.dart';

class SavedEventsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SavedEventsPage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _SavedEventsPageState createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> savedEvents = []; // <- dynamic, not String

  @override
  void initState() {
    super.initState();
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    final events = await dbHelper.getSavedEvents();
    setState(() {
      savedEvents = events; // no casting needed
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
        title: const Text('Your Saved Events'),
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
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: 3,
                  child: ListTile(
                    title: Text(event['title'] ?? ''),
                    subtitle: Text('${event['