import 'package:flutter/material.dart';
import 'package:lofo/pages/more_page.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/security_layouts/security_pages/security_home.dart';
import 'package:lofo/security_layouts/security_pages/security_inbox_page.dart';

class SecurityLayout extends StatefulWidget {
  const SecurityLayout({super.key});

  @override
  State<SecurityLayout> createState() => _SecurityLayoutState();
}

int selectedSecurityPageIndex = 1;

class _SecurityLayoutState extends State<SecurityLayout> {
  String appBarTitle = 'Home';
  Widget securityPage = const SecurityHomePage();

  @override
  Widget build(BuildContext context) {
    switch (selectedSecurityPageIndex) {
      case 0:
        securityPage = const MorePage();
        appBarTitle = 'Hi, Security';
        break;
      case 1:
        securityPage = const SecurityHomePage();
        appBarTitle = 'Home';
        break;
      case 2:
        securityPage = const SecurityInboxPage();
        appBarTitle = 'Your Requests';
        break;
      default:
        securityPage = const SecurityHomePage();
        appBarTitle = 'Home';
        throw UnimplementedError('no widget for $selectedSecurityPageIndex');
    }

    var mainArea = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: securityPage,
    );

    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      appBar: securityAppBar(appBarTitle, securityImageExample),
      body: Column(children: <Widget>[
        Expanded(child: mainArea),
        SafeArea(top: false, child: bottomNavigationBar()),
      ]),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: securityColorScheme.background,
      unselectedItemColor: securityColorScheme.surfaceVariant,
      selectedItemColor: securityColorScheme.primary,
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
          label: 'Inbox',
        ),
      ],
      currentIndex: selectedSecurityPageIndex,
      onTap: (value) {
        setState(() {
          selectedSecurityPageIndex = value;
        });
      },
    );
  }

  NavigationBar navigationBar() {
    return NavigationBar(
      indicatorColor: securityColorScheme.primary,
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
      selectedIndex: selectedSecurityPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedSecurityPageIndex = index;
        });
      },
    );
  }
}

// const layoutWidget = SecurityLayout();
