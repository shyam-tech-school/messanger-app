import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/call/presentation/pages/call_screen.dart';
import 'package:mail_messanger/features/chats/presentation/pages/chats_screen.dart';
import 'package:mail_messanger/features/group/presentation/pages/group_screen.dart';
import 'package:mail_messanger/features/settings/presentation/pages/settings_screen.dart';
import 'package:mail_messanger/features/story/presentation/pages/story_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final List<Widget> screens = [
    const ChatsScreen(),
    const StoryScreen(),
    const GroupScreen(),
    const CallScreen(),
    const SettingsScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.greyShade300)),
        ),
        child: BottomAppBar(
          padding: const .only(top: 10),
          child: Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              BottomBarIconWidget(
                ontap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                icons: _currentIndex == 0
                    ? CupertinoIcons.bubble_left_bubble_right_fill
                    : CupertinoIcons.bubble_left_bubble_right,
                label: "Chat",
                isSelected: _currentIndex == 0,
              ),

              BottomBarIconWidget(
                ontap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                icons: _currentIndex == 1
                    ? CupertinoIcons.arrow_2_circlepath_circle_fill
                    : CupertinoIcons.arrow_2_circlepath_circle,
                label: "Story",
                isSelected: _currentIndex == 1,
              ),

              BottomBarIconWidget(
                ontap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                icons: _currentIndex == 2
                    ? CupertinoIcons.person_3_fill
                    : CupertinoIcons.person_3,
                label: "Group",
                isSelected: _currentIndex == 2,
              ),

              BottomBarIconWidget(
                ontap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                icons: _currentIndex == 3
                    ? CupertinoIcons.phone_fill
                    : CupertinoIcons.phone,
                label: "Call",
                isSelected: _currentIndex == 3,
              ),

              BottomBarIconWidget(
                ontap: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
                icons: CupertinoIcons.settings,
                label: "Settings",
                isSelected: _currentIndex == 4,
              ),
            ],
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
    return GestureDetector(
      onTap: ontap,
      child: Column(
        spacing: 5,
        children: [
          Icon(
            icons,
            size: 30,
            color: isSelected ? ColorConstants.primary : ColorConstants.black54,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? ColorConstants.primary : null,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
