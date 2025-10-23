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
          : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: categoryEvents.length,
            itemBuilder: (context, index) {
              final event = categoryEvents[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/${event['image']}',
                            width: double.infinity,
                            height: constraints.maxWidth * 0.6,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event['location']}, ${event['date']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}