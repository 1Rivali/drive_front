import 'package:drive_front/features/home/cubit/home_cubit.dart';
import 'package:drive_front/features/home/screens/widgets/myfiles.dart';
import 'package:drive_front/utils/storage/cache_helper.dart';
import 'package:drive_front/utils/widgets/page_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_navigation/side_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    MyFilesScreen(),
    Container(),
    Container(),
  ];

  int _selectedIndex = 0;
  final String? name = CacheHelper.getData(key: 'name');
  @override
  void initState() {
    context.read<HomeCubit>().getMyFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageDecoration(
      scaffold: Scaffold(
        body: Row(
          children: [
            SideNavigationBar(
              selectedIndex: _selectedIndex,
              theme: _buildSideNavigationBarTheme(),
              header: _buildSideNavigationBarHeader(),
              footer: _buildSideNavigationBarFooter(),
              items: const [
                SideNavigationBarItem(
                  icon: Icons.file_copy,
                  label: 'My Files',
                ),
                SideNavigationBarItem(
                  icon: Icons.public,
                  label: 'Public Files',
                ),
                SideNavigationBarItem(
                  icon: Icons.group,
                  label: 'Groups',
                ),
              ],
              onTap: (value) => setState(() {
                _selectedIndex = value;
              }),
            ),
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }

  SideNavigationBarTheme _buildSideNavigationBarTheme() {
    return SideNavigationBarTheme(
      itemTheme: SideNavigationBarItemTheme(),
      togglerTheme: const SideNavigationBarTogglerTheme(),
      dividerTheme: const SideNavigationBarDividerTheme(
        showHeaderDivider: true,
        showMainDivider: true,
        showFooterDivider: true,
      ),
    );
  }

  SideNavigationBarFooter _buildSideNavigationBarFooter() {
    return SideNavigationBarFooter(
        label: ListTile(
      dense: true,
      leading: const Icon(Icons.logout),
      title: const Text("Logout"),
      onTap: () {},
    ));
  }

  SideNavigationBarHeader _buildSideNavigationBarHeader() {
    return SideNavigationBarHeader(
      image: CircleAvatar(
        backgroundColor: Colors.indigo.shade500,
        child: Text(
          name!.substring(0, 1).toUpperCase(),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      title: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            "Welcome back ${name!} ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      subtitle: const Text(''),
    );
  }
}
