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
    CustomItem('assets/NasrCity.jpg', 'Nasr City'),
    CustomItem('assets/Maadi.jpg', 'Maadi'),
    CustomItem('assets/Zamalek.png', 'Zamalek'),
    CustomItem('assets/MasrElGdeeda.jpeg', 'Masr El Gdeeda'),
    CustomItem('assets/NewCairo.jpg', 'New Cairo'),
    CustomItem('assets/Mokatam.jpg', 'Mokatam'),
    CustomItem('assets/Attaba.jpg', 'Attaba'),
    CustomItem('assets/WestElBalad.jpeg', 'West El balad'),
    CustomItem('assets/AsemaEdareya.jpg', 'Asema Edareya'),
    CustomItem('assets/MasrElAdeema.jpg', 'Masr El Adeema'),
    CustomItem('assets/6thOctober.webp', '6th October'),
    CustomItem('assets/Madinty.jpg', 'Madinty'),
    CustomItem('assets/ElShrouk.webp', 'El Shrouk'),
    CustomItem('assets/Obour.jpg', 'Oubor'),
    CustomItem('assets/Badr.webp', 'Badr'),
    CustomItem('assets/NewHeliopolis.jpg', 'New Heliopolis'),
    CustomItem('assets/ElSheikhZayed.jpg', 'Sheikh Zayed'),
    CustomItem('assets/ElMohandseen.jpg', 'Mohandseen'),
    CustomItem('assets/Shobra.jpg', 'Shobra'),
    CustomItem('assets/Zatoon.jpg', 'El Zatoon'),
    CustomItem('assets/ElNozha.jpg', 'El Nozha'),
    CustomItem('assets/Giza.jpg', 'El Giza'),

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
                  title:
                    Row(
                      children: [
                        Image.asset(
                          filteredItems[index].title,
                          height: 75,
                          width: 75,
                        ),
                        SizedBox(width: 20),
                        Text(
                          filteredItems[index].description,
                          style: GoogleFonts.caveat(
                            textStyle: TextStyle(
                              color: Colors.pink,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
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

