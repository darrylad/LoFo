import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/navigation.dart';
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
  Widget securityPage = const SecurityHomePage();

  @override
  Widget build(BuildContext context) {
    switch (selectedSecurityPageIndex) {
      case 0:
        securityPage = const MorePage();
        currentAppBar =
            securityAppBar('Hi, Security', const LoginImageButton());
        break;
      case 2:
        securityPage = const SecurityHomePage();
        currentAppBar =
            securityAppBar('Public Posts', const LoginImageButton());
        break;
      case 1:
        securityPage = const SecurityInboxPage();
        currentAppBar = securityAppBar('Inbox', const LoginImageButton());
        break;
      default:
        securityPage = const SecurityHomePage();
        currentAppBar = securityAppBar('Hi, Darryl', const LoginImageButton());
        throw UnimplementedError('no widget for $selectedSecurityPageIndex');
    }

    var mainArea = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: securityPage,
    );

    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      appBar: currentAppBar,
      body: Column(children: <Widget>[
        Expanded(child: mainArea),
        SafeArea(top: false, child: securityBottomNavigationBar()),
      ]),
    );
  }

  BottomNavigationBar securityBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: securityColorScheme.surface,
      unselectedItemColor: securityColorScheme.onSurface.withOpacity(0.5),
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
