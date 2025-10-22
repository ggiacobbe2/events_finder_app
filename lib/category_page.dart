import 'package:flutter/material.dart';
import 'all_events.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {

    final Map<String, List<String>> categoryMapping = {
      'Sports & Fitness': ['Sports', 'Fitness'],
      'Music & Art': ['Music', 'Art'],
      'Family': ['Family'],
      'Nightlife': ['Nightlife'],
      'Lifestyle': ['Lifestyle'],
      'Education': ['Education'],
      'Professional': ['Professional'],
      'Food': ['Food'],
    };

    final List<String> tags = categoryMapping[category] ?? [];

    final List<Map<String, dynamic>> categoryEvents = allEvents
        .where((event) => event['category'].any((c) => tags.contains(c)))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Events'),
      ),
      body: categoryEvents.isEmpty
          ? const Center(child: Text('No events found in this category.'))
          : ListView.builder(
              itemCount: categoryEvents.length,
              itemBuilder: (context, index) {
                final event = categoryEvents[index];
                return Card(
                  margin: const EdgeInsets.all(6.0),
                  color: Theme.of(context).cardColor,
                  elevation: 3,
                  child: ListTile(
                    title: Text(event['title']),
                    subtitle: Text('${event['location']} - ${event['date']}'),
                    // optional: add image if available
                    // leading: Image.asset('assets/${event['image']}', width: 50, height: 50, fit: BoxFit.cover),
                  ),
                );
              },
            ),
    );
  }
}