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

  @override
  void initState() {
    _controller.text = args[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Placemark> placements = args[0];

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
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: TextField(
                  controller: _controller,
                  cursorColor: CustomColors.textColorBlack,
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
                  itemCount: placements.length,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.toNamed('/',
                            arguments: [placements[index].locality]);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: CustomColors.firstGradientColor,
                      title: Text(placements[index].locality ?? ''),
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
