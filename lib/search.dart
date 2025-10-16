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

  final List<String> locations = [ // placeholders
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Miami',
  ];

  String getDateRangeText() {
    return '${selectedDateRange!.start.month}/${selectedDateRange!.start.day}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}/${selectedDateRange!.end.year}';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text('Where'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: selectedLocation,
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
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

                const SizedBox(width: 10),

                SizedBox(
                  height: 60,
                  width: 60,
                  child: InkWell(
                    onTap: () async {
                      DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        initialDateRange: selectedDateRange,
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: const Color.fromARGB(255, 113, 113, 113)),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}