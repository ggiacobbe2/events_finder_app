import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfilePage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  String name = '';
  String email = '';
  String phone = '';
  String location = '';

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
    locationController = TextEditingController(text: location);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        name = nameController.text;
        email = emailController.text;
        phone = phoneController.text;
        location = locationController.text;
      }
      isEditing = !isEditing;
    });
  }

  Widget buildProfileField({required String label, required TextEditingController controller, required IconData icon}) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              color: theme.cardColor,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildProfileField(label: "Your Name", controller: nameController, icon: Icons.person),
                    const SizedBox(height: 8),
                    buildProfileField(label: "Email", controller: emailController, icon: Icons.email),
                    const SizedBox(height: 8),
                    buildProfileField(label: "Phone Number", controller: phoneController, icon: Icons.phone),
                    const SizedBox(height: 8),
                    buildProfileField(label: "Location", controller: locationController, icon: Icons.location_on),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: toggleEdit,
                      icon: Icon(isEditing ? Icons.save : Icons.edit),
                      label: Text(isEditing ? "Save" : "Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.cardColor,
                        foregroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // might change formatting of these sections below
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Your Tickets",
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Your Posted Events",
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}