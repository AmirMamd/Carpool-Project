import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DetailsFromFaculty.dart';

class CustomItem {
  final String title;
  final String description;

  CustomItem(this.title, this.description);
}

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  _RouteListState createState() => _RouteListState();
}
class _RouteListState extends State<RouteList> {
  final List<CustomItem> customItems = [
    CustomItem('Item 1', 'Nasr City'),
    CustomItem('Item 2', 'Maadi'),
    CustomItem('Item 3', 'Zamalek'),
    CustomItem('Item 4', 'Masr El Gdeeda'),
    CustomItem('Item 5', 'New Cairo'),
    CustomItem('Item 6', 'Mokatam'),
    CustomItem('Item 7', 'Attaba'),
    CustomItem('Item 8', 'West El balad'),
    CustomItem('Item 9', 'Asema Edareya'),
    CustomItem('Item 10', 'Masr El Adeema'),
    CustomItem('Item 11', '6th October'),
    CustomItem('Item 12', 'Madinty'),
    CustomItem('Item 13', 'El Shrouk'),
    CustomItem('Item 14', 'Oubor'),
    CustomItem('Item 15', 'Badr'),
    CustomItem('Item 16', 'New Heliopolis'),
    CustomItem('Item 17', 'Sheikh Zayed'),
    CustomItem('Item 18', 'Mohandseen'),
    CustomItem('Item 19', 'Shobra'),
    CustomItem('Item 20', 'El Sarayat'),
    CustomItem('Item 21', 'Midan El Tahrir'),

  ];
  List<CustomItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = customItems;
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = customItems; // Show all items if query is empty
      } else {
        filteredItems = customItems
            .where((item) =>
            item.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Routes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              onChanged: (query) {
                filterItems(query);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length, // Use filteredItems
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(
                      filteredItems[index].description,
                      style: GoogleFonts.caveat(
                        textStyle: TextStyle(
                          color: Colors.pink,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsFromFaculty(location: filteredItems[index].description),
                      )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

