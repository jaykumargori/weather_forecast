import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/utilities/custom_colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final args = Get.arguments;
  final TextEditingController _controller = TextEditingController();
  List<Placemark>? placements;

  @override
  void initState() {
    _controller.text = args[1];
    placements = args[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      try {
                        List<Location> locations =
                            await locationFromAddress(value);
                        if (locations.isNotEmpty) {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  locations[0].latitude,
                                  locations[0].longitude);

                          setState(() {
                            placements = placemarks;
                          });
                        } else {
                          // Handle the case where no locations were found
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'No locations found for the provided address.'),
                            ),
                          );
                        }
                      } catch (e) {
                        // Handle any errors that occur during geocoding or placemark lookup
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'No locations found for the provided address.'),
                          ),
                        );
                      }
                    } else {
                      // Handle the case where the search field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid address.'),
                        ),
                      );
                    }
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: placements?.length ?? 0,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.toNamed('/',
                            arguments: [placements?[index].locality]);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: CustomColors.firstGradientColor,
                      title: Text(placements?[index].locality ?? ''),
                      titleTextStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
