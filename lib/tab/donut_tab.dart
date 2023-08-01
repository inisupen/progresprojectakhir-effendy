import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/donut_tile.dart';

class DonutTab extends StatefulWidget {
  final Function(List<Map<String, dynamic>> donuts) onDataFetched;

  DonutTab({required this.onDataFetched});
  @override
  _DonutTabState createState() => _DonutTabState();
}

class _DonutTabState extends State<DonutTab> {
  // List to store the donut data fetched from the API
  List<Map<String, dynamic>> donuts = [];

  // Function to fetch the donut data from the Strapi API
  Future<void> fetchDonuts() async {
    final apiUrl =
        'http://localhost:1337/api/donuts?populate=%2A'; // Replace with your Strapi API endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(response.body);

        // Explicitly cast jsonData['data'] to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(jsonData['data']);

        setState(() {
          donuts = jsonDataList;
        });

        widget.onDataFetched(donuts);
      } else {
        // Handle error response here
        print('Failed to fetch donuts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors here
      print('Error occurred while fetching donuts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDonuts();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: donuts.length,
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        final donut = donuts[index]['attributes'];
        final donutImage =
            donut['gambar_donut']['data'][0]['attributes']['url'];
        return DonutTile(
          donutFlavor: donut['rasa_donat'],
          donutPrice: donut['harga'].toString(),
          donutColor: Colors.blue, // Replace with the appropriate color
          imageName: donutImage,
        );
      },
    );
  }
}
