AI Usage:

10/15
Asked: How can we ensure each app has a unique AppBar and not share main's AppBar?
Generated:
```
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      const SearchPage(),
      const SavedEventsPage(),
      const ProfilePage(),
    ];
```
How We Applied: Implemented this at the bottom of main.dart and modified it by passing the arguments "isDarkMode" & "toggleTheme".
Reflection: Learned how to build independent pages but still share certain behavior (such as light/dark mode).

10/19
Asked: How can we implement Flutter's built in DateRangePicker as one of our advanced filters?
Generated:
```
  String getDateRangeText() {
    if (selectedDateRange == null) {
      return 'Select Date Range';
    } else {
      return '${selectedDateRange!.start.month}/${selectedDateRange!.start.day}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}/${selectedDateRange!.end.year}';
    }
  }
```

AND
```
            InkWell(
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
```

How We Applied: We implemented the DateRangePicker into our search bar as its own entity. This way, users can choose to use this advanced filtering on its own, by combining with another filter, or not at all.
Reflection: Learned how to implement a clickable icon that launches Flutter's built-in date range picker. Also learned more about formatting dates since they can tricky when it comes to queries & filtering.

10/24
Asked: How can we take a certain amount of event data from our static list and insert it into our buildEventCard function?
Generated:
```
children: allEvents.take(5).map((event)
```
How We Applied: We implemented this into our carousel of event cards, so that we could use actual data and not placeholder data.
Reflection: Learned how to take and map information that has already been defined in our static data table and use it elsewhere in the app. Helps us reduce the need to define/duplicate data that has already been created.

10/22
Asked: How can we map multiple tags to their respective categories?
Generated:
```
    final List<String> tags = categoryMapping[category] ?? [];

    final List<Map<String, dynamic>> categoryEvents = allEvents
        .where((event) => event['category'].any((c) => tags.contains(c)))
        .toList();
```
How We Applied: Used this to map multiple category tags to the appropriate category "folder".
Reflection: This sort of practice is good for code maintainability and also shows the importance of low coupling. If we add more tags or categories in the future, this code helps us easily adapt and adjust as little code as possible.

10/24
Asked: Having trouble with connecting the database & loading the profile. Help us load the profile if it already exists.
Generated:
```
  void _loadProfile() async {
    final profile = await dbHelper.getProfile();
    if (profile != null) {
      profileId = profile['id'] as int?;
      nameController = TextEditingController(text: profile!['name'] ?? '');
      emailController = TextEditingController(text: profile!['email'] ?? '');
      phoneController = TextEditingController(text: profile!['phone'] ?? '');
      locationController = TextEditingController(text: profile!['location'] ?? '');
    }
    setState(() {});
  }
```
How We Applied: We implemented this logic to our profile page to load any profile information if it already existed. This was also very helpful to the saved_events and ticket_page because we applied a very similar logic.
Reflection: Learned to load any stored information first and how to do so without interfering with the UI. It also helped us learn the overall sequence of events for fetching data, initializing controllers, and then setting the state for saving information.

10/26
Asked: Having trouble parsing our date string correctly for the search.dart page. Help improve our parsing function so that it accurately filters events by date.
Generated:
```
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
```
How We Applied: This helped us improve our filtering logic in our search.dart function. It allows the platform to compare date ranges for events safely without producing unnecessary errors.
Reflection: Learned more about safe, defensive coding, and how defining a robust function like this can be helpful for reusability throughout our code. It also helped us avoid any unnecessary  syntax/typo errors since the function is very particular.
