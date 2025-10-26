import 'package:flutter/material.dart';
import 'database_helper.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const EventDetailPage({
    super.key,
    required this.event,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool ticketReserved = false;

  @override
  Widget build(BuildContext context) {
    final String title = widget.event['title'] ?? 'Event Details';
    final String location = widget.event['location'] ?? 'Location TBD';
    final DateTime? parsedDate = DateTime.tryParse(widget.event['date'] ?? '');
    final String dateText = parsedDate == null
        ? (widget.event['date'] ?? 'Date TBD')
        : '${parsedDate.month}/${parsedDate.day}/${parsedDate.year}';
    final String description =
        widget.event['description'] ?? 'No description available.';
    final List<dynamic> categories =
        (widget.event['category'] is List) ? widget.event['category'] : <String>[];
    final String? imageName =
        widget.event['image'] != null ? 'assets/${widget.event['image']}' : null;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: imageName == null
                  ? Container(
                      height: 220,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.photo,
                        size: 72,
                      ),
                    )
                  : Image.asset(
                      imageName,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 6),
                Text(
                  dateText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories
                    .map(
                      (category) => Chip(
                        label: Text(
                          '$category',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().insertTicket({
                  'title': widget.event['title'] ?? '',
                  'date': widget.event['date'] ?? '',
                  'location': widget.event['location'] ?? '',
                });

                setState(() {
                  ticketReserved = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('One ticket reserved!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Reserve a Ticket',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}