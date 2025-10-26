import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TicketPage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> savedTickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final tickets = await dbHelper.getSavedTickets();
    setState(() {
      savedTickets = List<Map<String, dynamic>>.from(tickets);
    });
  }

  Future<void> _deleteTicket(int id) async {
    await dbHelper.deleteTicket(id);
    setState(() {
      savedTickets.removeWhere((ticket) => ticket['id'] == id);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Tickets',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: savedTickets.isEmpty
          ? Center(
              child: Text(
                'No tickets yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: savedTickets.length,
              itemBuilder: (context, index) {
                final ticket = savedTickets[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: 3,
                  child: ListTile(
                    title: Text(ticket['title'] ?? ''),
                    subtitle: Text('${ticket['location']}, ${ticket['date']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteTicket(ticket['id'] as int);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}