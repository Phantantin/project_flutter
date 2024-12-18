import 'package:flutter/material.dart';
import 'package:shopping_app_1/widget/subtitle_text.dart';

class DashboardButtonWidget extends StatelessWidget {
  final String title, imagePath;
  final Function onPressed;
  const DashboardButtonWidget(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 65,
              width: 65,
            ),
            const SizedBox(
              height: 15,
            ),
            SubtitleTextWidget(
              label: title,
              fontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
