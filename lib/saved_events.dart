import 'package:flutter/material.dart';

class SavedEventsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SavedEventsPage({Key? key, required this.isDarkMode, required this.toggleTheme}) : super(key: key);

  @override
  _SavedEventsPageState createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
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
      body: Center(
        child: Text(
          'Saved Events Page Coming Soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}