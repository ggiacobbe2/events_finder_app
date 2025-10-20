import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const SearchPage({Key? key, required this.isDarkMode, required this.toggleTheme}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  DateTimeRange? selectedDateRange;
  String? selectedLocation;

  List<Map<String, dynamic>> allEvents = [ // placeholder events
    {'title': 'Event 1', 'location': 'New York', 'date': DateTime(2025, 10, 18)},
    {'title': 'Event 2', 'location': 'Los Angeles', 'date': DateTime(2025, 11, 8)},
    {'title': 'Event 3', 'location': 'Miami', 'date': DateTime(2025, 12, 11)},
    {'title': 'Event 4', 'location': 'Chicago', 'date': DateTime(2025, 12, 21)},
  ];

  List<Map<String, dynamic>> filteredEvents = [];

  final List<String> locations = [
    'All',
    'Atlanta',
    'Boston',
    'Chicago',
    'Houston',
    'Los Angeles',
    'Miami',
    'New York',
    'Portland',
    'San Francisco',
    'Seattle',
  ];

  @override
  void initState() {
    super.initState();
    filteredEvents = List.from(allEvents);
  }

  void _filterEvents() {
    setState(() {
      filteredEvents = allEvents.where((event) {
        final matchesQuery = searchQuery.isEmpty || event['title'].toLowerCase().contains(searchQuery.toLowerCase());
        final matchesLocation = selectedLocation == null || selectedLocation == 'All' || event['location'] == selectedLocation;
        final matchesDateRange = selectedDateRange == null ||
            (event['date'].isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
             event['date'].isBefore(selectedDateRange!.end.add(const Duration(days: 1))));
        return matchesQuery && matchesLocation && matchesDateRange;
      }).toList();
    });
  }

  String _getDateRangeText() {
    if (selectedDateRange == null) {
      return 'Select Date Range';
    } else {
      return '${selectedDateRange!.start.month}/${selectedDateRange!.start.day}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}/${selectedDateRange!.end.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Events Near You'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
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
                        return Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            title: Text(event['title']),
                            subtitle: Text('${event['location']} - ${event['date'].month}/${event['date'].day}/${event['date'].year}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () {
                                // need to add saving functionality
                              },
                            ),
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