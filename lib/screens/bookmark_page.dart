import 'package:flutter/material.dart';
import '../theme/theme_data.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookmarks'),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Bookmark content goes here',
          style: appThemeData.textTheme.bodyLarge,
        ),
      ),
    );
  }
}

