import 'package:flutter/material.dart';
import 'search.dart';
import 'saved_events.dart';
import 'profile.dart';
import 'category_page.dart';
import 'all_events.dart';
import 'event_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  final Color lightPrimaryColor = const Color.fromARGB(255, 57, 8, 147);
  final Color darkPrimaryColor = const Color.fromARGB(255, 118, 131, 244);
  final Color lightBackgroundColor = const Color.fromARGB(255, 240, 242, 239);
  final Color darkBackgroundColor = Colors.black;
  final Color lightCardColor = const Color.fromARGB(255, 227, 228, 228);
  final Color darkCardColor = const Color(0xFF1E1E1E);
  final Color lightTextColor = const Color(0xFFFAFFF9);
  final Color darkTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    ThemeData _buildLightTheme() => ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      cardColor: lightCardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimaryColor,
        foregroundColor: lightTextColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: lightBackgroundColor,
        unselectedItemColor: lightPrimaryColor,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    );

    ThemeData _buildDarkTheme() => ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkTextColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBackgroundColor,
        selectedItemColor: darkPrimaryColor,
        unselectedItemColor: Colors.white70,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );

    return MaterialApp(
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: EventsHomePage(
       isDarkMode: isDarkMode,
       toggleTheme: () {
         setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class EventsHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const EventsHomePage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _EventsHomePageState createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  int _selectedIndex = 0;
  final List<String> categories = [
    'Sports & Fitness',
    'Food',
    'Nightlife',
    'Lifestyle',
    'Education',
    'Family',
    'Professional',
    'Music',
    'Art',
  ];

  final List<IconData> categoryIcons = [
    Icons.sports_soccer,
    Icons.restaurant,
    Icons.nightlife,
    Icons.travel_explore,
    Icons.school,
    Icons.family_restroom,
    Icons.business_center,
    Icons.music_note,
    Icons.brush,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final String title = event['title'] ?? 'Upcoming Event';
    final String location = event['location'] ?? 'Location TBD';
    final DateTime? parsedDate = DateTime.tryParse(event['date'] ?? '');
    final String dateText = parsedDate != null
        ? '${parsedDate.month}/${parsedDate.day}/${parsedDate.year}'
        : (event['date'] ?? 'Date TBD');
    final String imagePath = event['image'] ?? '';

    return GestureDetector(
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                'assets/$imagePath',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$location, $dateText',
                    style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Your Next Event',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          const SizedBox(height: 10),
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: PageView(
              controller: PageController(viewportFraction: 0.9),
              children: allEvents.take(5).map((event) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildEventCard(event),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: categories.map((category) {
              return Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                category: category,
                                isDarkMode: widget.isDarkMode,
                                toggleTheme: widget.toggleTheme,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Theme.of(context).cardColor,
                          child: Center(
                            child: Icon(
                              categoryIcons[categories.indexOf(category)],
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      SearchPage(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
      SavedEventsPage(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
      ProfilePage(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 2,
        unselectedFontSize: 2,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 32), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 32), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, size: 32), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 32), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: widget.isDarkMode ? const Color.fromARGB(255, 66, 57, 192) : const Color.fromARGB(255, 27, 1, 74),
        unselectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}