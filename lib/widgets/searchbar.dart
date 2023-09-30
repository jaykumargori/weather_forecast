import 'package:flutter/material.dart';

class SearchFeld extends StatefulWidget {
  final void Function(String)? onSubmitted;
  const SearchFeld({super.key, this.onSubmitted});

  @override
  State<SearchFeld> createState() => _SearchFeldState();
}

class _SearchFeldState extends State<SearchFeld> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 9,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: TextField(
          onSubmitted: widget.onSubmitted,
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
    );
  }
}
