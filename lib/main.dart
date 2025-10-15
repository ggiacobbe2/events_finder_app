import 'package:flutter/material.dart';
import 'search.dart';
import 'profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  final Color lightPrimaryColor = const Color(0xFFC600D4);
  final Color darkPrimaryColor = const Color(0xFFD312E0);

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimaryColor,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: lightPrimaryColor,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: lightPrimaryColor),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      cardColor: darkPrimaryColor,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
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

  EventsHomePage({required this.isDarkMode, required this.toggleTheme});

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
    'Post an Event!',
    'Education',
    'Family',
    'Professional',
    'Music & Art',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find an Event Near You!',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: categories.map((category) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(category: category),
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      const SearchPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 144, 0, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Events'),
      ),
      body: Center(
        child: Text('Events coming soon!'),
      ),
    );
  }
}