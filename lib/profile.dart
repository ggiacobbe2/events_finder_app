import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
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