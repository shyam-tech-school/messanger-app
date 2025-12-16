import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/call/presentation/pages/call_screen.dart';
import 'package:mail_messanger/features/chats/presentation/pages/chats_screen.dart';
import 'package:mail_messanger/features/settings/presentation/pages/settings_screen.dart';
import 'package:mail_messanger/features/video/presentation/pages/video_call_list_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final List<Widget> screens = [
    const ChatsScreen(),
    const CallScreen(),
    const VideoCallListScreen(),
    const SettingsScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.greyShade300)),
          borderRadius: const .only(
            topRight: .circular(20),
            topLeft: .circular(20),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const .only(
            topRight: .circular(20),
            topLeft: .circular(20),
          ),
          child: BottomAppBar(
            color: ColorConstants.black,
            //color: ColorConstants.darkScaffoldBgColor,
            padding: const .only(top: 15),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                BottomBarIconWidget(
                  ontap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  icons: Ionicons.chatbubbles_outline,
                  label: "Chats",
                  isSelected: _currentIndex == 0,
                ),

                BottomBarIconWidget(
                  ontap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  icons: CupertinoIcons.phone,
                  label: "Call",
                  isSelected: _currentIndex == 1,
                ),

                BottomBarIconWidget(
                  ontap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  icons: Ionicons.videocam_outline,
                  label: "Call",
                  isSelected: _currentIndex == 2,
                ),

                BottomBarIconWidget(
                  ontap: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                  icons: Ionicons.settings_outline,
                  label: "Settings",
                  isSelected: _currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarIconWidget extends StatelessWidget {
  const BottomBarIconWidget({
    super.key,
    required this.ontap,
    required this.icons,
    required this.label,
    required this.isSelected,
  });

  final Function()? ontap;
  final IconData icons;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icons),
      onPressed: ontap,
      iconSize: 30,
      color: isSelected ? ColorConstants.primaryColor : ColorConstants.white,
    );
  }
}
