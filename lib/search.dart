import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Events Near You'),
      ),
      body: Center(
        child: Text(
          'Search Page Coming Soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}