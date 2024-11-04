import 'package:electriciansapp/Constants/constants.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String iconPath; // Updated to use a custom icon path

  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconPath, // Updated to use a custom icon path
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xffA7C7E7),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.asset(
                    iconPath, // Use custom icon path
                    width: 50,
                    height: 50,
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style:
                        kTextStyle.copyWith(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
