import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';
import 'package:lofo/pages/home.dart';
import 'package:lofo/pages/more_page.dart';
import 'package:lofo/pages/your_posts_page.dart';
import 'package:lofo/services/notification_service.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

var currentAppBar = appBar('Welcome', null);
// int selectedPageIndex = 1;
final ValueNotifier<int> selectedPageIndexNotifier = ValueNotifier<int>(1);

class _LayoutState extends State<Layout> {
  Widget page = const HomePage();
  String morePageAppBarTitle = (isUserLoggedIn) ? 'Hi, $userName' : '';

  @override
  void initState() {
    if (areNotificationsEnabled) {
      NotificationService().uploadDeviceToken();
    }
    super.initState();
    // selectedPageIndexNotifier.addListener(() {
    //   print('selectedPageIndexNotifier: ${selectedPageIndexNotifier.value}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageIndexNotifier,
      builder: (context, selectedPageIndex, child) {
        switch (selectedPageIndex) {
          case 0:
            page = const MorePage();
            currentAppBar =
                appBar(morePageAppBarTitle, const LoginImageButton());
            break;
          case 1:
            page = const HomePage();
            currentAppBar = appBar('Home', const LoginImageButton());
            break;
          case 2:
            page = const YourPostsPage();
            currentAppBar =
                appBar('Private requests', const LoginImageButton());
            break;
          default:
            page = const HomePage();
            currentAppBar =
                appBar('Which page is this', const LoginImageButton());
            throw UnimplementedError('no widget for $selectedPageIndex');
        }

        var mainArea = AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: page,
        );

        return Scaffold(
          appBar: currentAppBar,
          body: Column(children: <Widget>[
            Expanded(child: mainArea),
            SafeArea(top: false, child: bottomNavigationBar()),
          ]),
        );
      },
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: themeData.colorScheme.primary,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'More',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Public Posts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox_rounded),
          // icon: Icon(Icons.amp_stories_rounded),
          label: 'Your posts',
        ),
      ],
      // currentIndex: selectedPageIndex,
      currentIndex: selectedPageIndexNotifier.value,
      onTap: (value) {
        // setState(() {
        //   selectedPageIndex = value;
        // });
        selectedPageIndexNotifier.value = value;
      },
    );
  }

  // NavigationBar navigationBar() {
  //   return NavigationBar(
  //     indicatorColor: lightColorScheme.primary,
  //     destinations: const <Widget>[
  //       NavigationDestination(
  //         icon: Icon(Icons.menu),
  //         label: 'More',
  //       ),
  //       NavigationDestination(
  //         icon: Icon(Icons.home),
  //         label: 'Home',
  //       ),
  //       NavigationDestination(
  //         icon: Icon(Icons.all_inbox_rounded),
  //         // icon: Icon(Icons.amp_stories_rounded),
  //         label: 'Your Posts',
  //       ),
  //     ],
  //     selectedIndex: selectedPageIndex,
  //     onDestinationSelected: (int index) {
  //       setState(() {
  //         selectedPageIndex = index;
  //       });
  //     },
  //   );
  // }
}

Widget layoutWidget = const Layout();



// class Layout extends StatefulWidget {
//   const Layout({super.key});

//   @override
//   State<Layout> createState() => _LayoutState();
// }

// var currentAppBar = appBar('Welcome', null);
// // int selectedPageIndex = 1;
// final ValueNotifier<int> selectedPageIndexNotifier = ValueNotifier<int>(1);

// class _LayoutState extends State<Layout> {
//   Widget page = const HomePage();
//   String morePageAppBarTitle = (isUserLoggedIn) ? 'Hi, $userName' : '';

//   @override
//   Widget build(BuildContext context) {
//     themeData = Theme.of(context);

//     // switch (selectedPageIndex) {
//     switch (selectedPageIndexNotifier.value) {
//       case 0:
//         page = const MorePage();
//         currentAppBar = appBar(morePageAppBarTitle, const LoginImageButton());
//         break;
//       case 1:
//         page = const HomePage();
//         currentAppBar = appBar('Home', const LoginImageButton());
//         break;
//       case 2:
//         page = const YourPostsPage();
//         currentAppBar = appBar('Your Requests', const LoginImageButton());
//         break;
//       default:
//         page = const HomePage();
//         currentAppBar = appBar('Which page is this', const LoginImageButton());
//         // throw UnimplementedError('no widget for $selectedPageIndex');
//         throw UnimplementedError(
//             'no widget for ${selectedPageIndexNotifier.value}');
//     }

//     var mainArea = AnimatedSwitcher(
//       duration: const Duration(milliseconds: 200),
//       child: page,
//     );

//     return Scaffold(
//       // backgroundColor: Colors.blueGrey[100],
//       appBar: currentAppBar,
//       body: Column(children: <Widget>[
//         Expanded(child: mainArea),
//         SafeArea(top: false, child: bottomNavigationBar()),
//       ]),
//     );
//   }

//   BottomNavigationBar bottomNavigationBar() {
//     return BottomNavigationBar(
//       selectedItemColor: themeData.colorScheme.primary,
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.menu),
//           label: 'More',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.all_inbox_rounded),
//           // icon: Icon(Icons.amp_stories_rounded),
//           label: 'Your Posts',
//         ),
//       ],
//       // currentIndex: selectedPageIndex,
//       currentIndex: selectedPageIndexNotifier.value,
//       onTap: (value) {
//         // setState(() {
//         //   selectedPageIndex = value;
//         // });
//         selectedPageIndexNotifier.value = value;
//       },
//     );
//   }

//   // NavigationBar navigationBar() {
//   //   return NavigationBar(
//   //     indicatorColor: lightColorScheme.primary,
//   //     destinations: const <Widget>[
//   //       NavigationDestination(
//   //         icon: Icon(Icons.menu),
//   //         label: 'More',
//   //       ),
//   //       NavigationDestination(
//   //         icon: Icon(Icons.home),
//   //         label: 'Home',
//   //       ),
//   //       NavigationDestination(
//   //         icon: Icon(Icons.all_inbox_rounded),
//   //         // icon: Icon(Icons.amp_stories_rounded),
//   //         label: 'Your Posts',
//   //       ),
//   //     ],
//   //     selectedIndex: selectedPageIndex,
//   //     onDestinationSelected: (int index) {
//   //       setState(() {
//   //         selectedPageIndex = index;
//   //       });
//   //     },
//   //   );
//   // }
// }
