import 'package:flutter/material.dart';

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
      theme: isDarkMode ? darkTheme : lightTheme,
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

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
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