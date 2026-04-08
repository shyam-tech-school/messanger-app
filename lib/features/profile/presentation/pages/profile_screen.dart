import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
              ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Edit",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Name",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.greyShade300,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Username",
                ),
              ),
              const SizedBox(height: 20),

              // About
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: true,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.greyShade300,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText:
                      "It is a long established fact that a reader will be distracted by the readable.",
                ),
              ),
              const SizedBox(height: 20),

              // Phone number
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phone number",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.greyShade300,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "+91 9876543210",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
