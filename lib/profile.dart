import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfilePage({Key? key, required this.isDarkMode, required this.toggleTheme}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Profile Page Coming Soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}