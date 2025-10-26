import 'package:flutter/material.dart';
import 'all_events.dart';
import 'event_detail_page.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SearchPage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final dbHelper = DatabaseHelper();

  String searchQuery = '';
  DateTimeRange? selectedDateRange;
  String? selectedLocation;

  List<Map<String, dynamic>> filteredEvents = [];
  Set<String> savedEventTitles = {};

  final List<String> locations = [
    'All',
    'Atlanta',
    'Boston',
    'Chicago',
    'Denver',
    'Houston',
    'Jacksonville',
    'Los Angeles',
    'Miami',
    'New York',
    'Philadelphia',
    'Phoenix',
    'Portland',
    'San Diego',
    'Seattle',
  ];

  DateTime? parseEventDate(String? dateString) {
    if (dateString == null) return null;
    final parts = dateString.split('/');
    if (parts.length != 3) return null;
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) return null;
    return DateTime(year, month, day);
  }

  @override
  void initState() {
    super.initState();
    filteredEvents = List.from(allEvents);
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    final events = await dbHelper.getSavedEvents();
    setState(() {
      savedEventTitles = events.map((e) => e['title'] as String).toSet();
    });
  }

  void _filterEvents() {
    setState(() {
      filteredEvents = allEvents.where((event) {
        final matchesQuery = searchQuery.isEmpty ||
            (event['title']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

        final matchesLocation = selectedLocation == null ||
            selectedLocation == 'All' ||
            event['location'] == selectedLocation;

        final eventDate = parseEventDate(event['date']);

        final matchesDateRange = selectedDateRange == null ||
            (eventDate != null &&
            !eventDate.isBefore(selectedDateRange!.start) &&
            !eventDate.isAfter(selectedDateRange!.end));

        return matchesQuery && matchesLocation && matchesDateRange;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Events Near You',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                _filterEvents();
              },
            ),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      hint: const Text('Where'),
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                      ),
                      value: selectedLocation,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                          _filterEvents();
                        });
                      },
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDateRange: selectedDateRange,
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDateRange = picked;
                            _filterEvents();
                          });
                        }
                      },
                      child: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredEvents.isEmpty
                  ? const Center(child: Text('No events found'))
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        final dateText = event['date'] ?? '';
                        return Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            title: Text(event['title']),
                            subtitle: Text('${event['location']}, $dateText'),
                            trailing: IconButton(
                              icon: Icon(
                                savedEventTitles.contains(event['title'])
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                              ),
                              onPressed: () async {
                                if (!savedEventTitles.contains(event['title'])) {
                                  await dbHelper.insertSavedEvent({
                                    'title': event['title'],
                                    'date': event['date'],
                                    'location': event['location'],
                                    'isSaved': 1,
                                  });
                                  setState(() {
                                    savedEventTitles.add(event['title']);
                                  });
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailPage(
                                    event: event,
                                    isDarkMode: widget.isDarkMode,
                                    toggleTheme: widget.toggleTheme,
                                  ),
                                ),
                              );
                            },
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