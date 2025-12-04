import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

import '../widgets/profile_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const .all(16.0),
        child: ListView(
          children: [
            const CupertinoSearchTextField(),
            const SizedBox(height: 20),

            ProfileHeader(
              ontap: () =>
                  Navigator.pushNamed(context, RouteName.profileScreen),
            ),
            const SizedBox(height: 20),

            SettingsSection(
              items: [
                SettingsTile(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteName.accountScreen),
                  icon: CupertinoIcons.shield,
                  title: "Account",
                ),
                SettingsTile(icon: CupertinoIcons.lock, title: "Privacy"),
                SettingsTile(icon: CupertinoIcons.chat_bubble, title: "Chats"),
                SettingsTile(icon: CupertinoIcons.bell, title: "Notifications"),
              ],
            ),
            const SizedBox(height: 12),

            const SettingsSection(
              items: [
                SettingsTile(
                  icon: CupertinoIcons.info,
                  title: "Help and feedback",
                ),
                SettingsTile(
                  icon: CupertinoIcons.person_2,
                  title: "Invite a friend",
                ),
              ],
            ),

            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: .all(8.0),
                child: Text(
                  "@offenso techschool",
                  style: TextStyle(fontSize: 12, color: ColorConstants.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

   



// --- CUSTOM SCROLL VIEW -- ** MAY BE NEED IN FUTURE **
/*


-- SEARCH BAR --
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 0; // hidden when scrolling up
  @override
  double get maxExtent => 60; // visible height

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: const CupertinoSearchTextField(),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}


 CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Settings",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            pinned: true,
            elevation: 0,
            centerTitle: false,
            expandedHeight: 60,
            collapsedHeight: 60,
            automaticallyImplyLeading: false,
          ),

          // Search bar
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _SearchBarDelegate(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // -- Header section --
          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(horizontal: 16),
              child: Container(
                decoration: const BoxDecoration(),
                child: Row(
                  spacing: 12,
                  children: [
                    const CircleAvatar(radius: 35),
                    Expanded(
                      child: Column(
                        spacing: 6,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Username",
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: .8,
                                ),
                          ),
                          const Text(
                            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: .symmetric(horizontal: 16),
                child: SettingsSection(
                  items: [
                    SettingsTile(icon: CupertinoIcons.shield, title: "Account"),
                    SettingsTile(icon: CupertinoIcons.lock, title: "Privacy"),
                    SettingsTile(
                      icon: CupertinoIcons.chat_bubble,
                      title: "Chats",
                    ),
                    SettingsTile(
                      icon: CupertinoIcons.bell,
                      title: "Notifications",
                    ),
                    SettingsTile(
                      icon: CupertinoIcons.arrow_up_arrow_down,
                      title: "Storage and data",
                    ),
                  ],
                ),
              ),
            ]),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: .symmetric(horizontal: 16),
                child: SettingsSection(
                  items: [
                    SettingsTile(
                      icon: CupertinoIcons.info,
                      title: "Help and feedback",
                    ),
                    SettingsTile(
                      icon: CupertinoIcons.person_2,
                      title: "Invite a friend",
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
*/