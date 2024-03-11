import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/pages/home.dart';
import 'package:lofo/pages/more_page.dart';
import 'package:lofo/pages/your_posts_page.dart';
import 'package:lofo/theme/light_theme.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

int selectedPageIndex = 1;

class _LayoutState extends State<Layout> {
  String appBarTitle = 'Home';
  Widget page = const HomePage();

  @override
  Widget build(BuildContext context) {
    switch (selectedPageIndex) {
      case 0:
        page = const MorePage();
        appBarTitle = 'Hi, $userName';
        break;
      case 1:
        page = const HomePage();
        appBarTitle = 'Home';
        break;
      case 2:
        page = const YourPostsPage();
        appBarTitle = 'Your Requests';
        break;
      default:
        page = const HomePage();
        appBarTitle = 'Home';
        throw UnimplementedError('no widget for $selectedPageIndex');
    }

    var mainArea = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: page,
    );

    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      appBar: appBar(appBarTitle, userImageExample),
      body: Column(children: <Widget>[
        Expanded(child: mainArea),
        SafeArea(top: false, child: bottomNavigationBar()),
      ]),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'More',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox_rounded),
          // icon: Icon(Icons.amp_stories_rounded),
          label: 'Your Posts',
        ),
      ],
      currentIndex: selectedPageIndex,
      onTap: (value) {
        setState(() {
          selectedPageIndex = value;
        });
      },
    );
  }

  NavigationBar navigationBar() {
    return NavigationBar(
      indicatorColor: lightColorScheme.primary,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.menu),
          label: 'More',
        ),
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.all_inbox_rounded),
          // icon: Icon(Icons.amp_stories_rounded),
          label: 'Your Posts',
        ),
      ],
      selectedIndex: selectedPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedPageIndex = index;
        });
      },
    );
  }
}

Widget layoutWidget = const Layout();
