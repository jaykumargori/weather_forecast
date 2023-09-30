import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/controllers/global_controller.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: GlobalController.to.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
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
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final controller = GlobalController.to;
                final placements = controller.placemarks;
                return ListView.separated(
                    padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                    itemCount: placements.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      final place = placements[index];
                      final title$1 = place.name ?? '';
                      final title$2 = place.postalCode ?? '';
                      final title = '${title$1}, ${title$2}';
                      final subtitle$1 = place.locality ?? '';
                      final subtitle$2 = place.administrativeArea ?? '';
                      final subtitle$3 = place.country ?? '';
                      final subtitle =
                          '${subtitle$1}, ${subtitle$2}, ${subtitle$3}';
                      return ListTile(
                        minLeadingWidth: 24,
                        leading: const Icon(
                          Icons.place,
                          color: CustomColors.firstGradientColor,
                        ),
                        onTap: () {
                          Get.toNamed('/', arguments: [place.locality]);
                        },
                        title: Text(title),
                        subtitle: Text(subtitle),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: CustomColors.firstGradientColor,
                          size: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
