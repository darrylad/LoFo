import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String aboutTextDesc =
      'Welcome to the Lofo app, a dedicated platform designed to simplify the lost and found process on campus. My app provides students with a convenient way to report lost items, including descriptions and photos, which are then routed to campus security for assistance. \n \n \nDeveloped by Darryl David \n \n \n';

  getAboutText() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.fetchAndActivate();

      aboutTextDesc =
          remoteConfig.getString('about_text').replaceAll('new_line', '\n');
      setState(() {});
    } catch (e) {
      debugPrint("about text error: $e");
    }
  }

  @override
  initState() {
    getAboutText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return Hero(
      tag: 'about',
      child: Scaffold(
          appBar: AppBar(
            leading: leading,
            backgroundColor: themeData.scaffoldBackgroundColor,
            actions: const [],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'About',
                    style: TextStyle(
                        fontFamily: fonts[0],
                        fontSize: 50,
                        color: themeData.colorScheme.onSurfaceVariant,
                        fontVariations: const [FontVariation('wght', 500)]),
                  ),
                  const SizedBox(height: 60),
                  aboutText(
                      // 'Welcome to the Lofo app, a dedicated platform designed to simplify the lost and found process on campus. Our app provides students with a convenient way to report lost items, including descriptions and photos, which are then routed to campus security for assistance.',
                      aboutTextDesc,
                      TextAlign.start),
                  // const SizedBox(height: 20),
                  // aboutText(
                  //     'Group: Darryl David, Shivam Sharma, and Lovely Bhardwaj',
                  //     TextAlign.left),
                  // const SizedBox(height: 20),
                  // aboutText('Darryl: Frontend and Backend', TextAlign.left),
                  // aboutText('Shivam: AI', TextAlign.left),
                  // aboutText('Lovely: AI', TextAlign.left),
                  const SizedBox(height: 20),
                  Opacity(
                      opacity: 0.5,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/gdsclogo.png',
                          width: 120,
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Text aboutText(String text, TextAlign textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fonts[0],
          fontSize: 16,
          color: themeData.colorScheme.onSurfaceVariant,
          fontVariations: const [FontVariation('wght', 500)]),
    );
  }
}

class AboutSection extends StatefulWidget {
  final String? issueUrl;
  final String? appUrl;
  const AboutSection({super.key, this.issueUrl, this.appUrl});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  Future<void> _launchUrl(String URL) async {
    final Uri _url = Uri.parse(URL);
    try {
      // if (!await launchUrl(_url)) {
      //   throw Exception('Could not launch $_url');
      // }
      await launchUrl(_url);
    } on Exception catch (e) {
      debugPrint('Could not launch $_url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ABOUT',
              style: TextStyle(
                  color: themeData.colorScheme.outline,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          logoRow(),
          const SizedBox(height: 10),
          (widget.appUrl != null)
              ? ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  title: const Text('Source code'),
                  onTap: () {
                    _launchUrl(widget.appUrl!);
                  },
                  trailing: const Icon(Icons.open_in_new_rounded),
                )
              : const SizedBox(),
          const SizedBox(height: 15),
          Text('LoFo',
              style: TextStyle(
                  color: themeData.colorScheme.onSurface,
                  fontFamily: fonts[0],
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            'An intuitive way of reporting lost and found items on campus. \n \nThis app is in beta, which makes it prone to bugs.',
            style: TextStyle(
              color: themeData.colorScheme.onSurface,
              fontVariations: const [FontVariation('wght', 600)],
              fontFamily: fonts[0],
            ),
          ),
          (widget.issueUrl != null)
              ? ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  title: const Text('File an issue'),
                  onTap: () {
                    _launchUrl(widget.issueUrl!);
                  },
                  trailing: const Icon(Icons.open_in_new_rounded),
                )
              : const SizedBox(),
          Text(
            'If you have any great ideas that would improve the app\'s experience, feel free to reach out!',
            style: TextStyle(
              color: themeData.colorScheme.onSurface,
              fontVariations: const [FontVariation('wght', 600)],
              fontFamily: fonts[0],
            ),
          ),
          const SizedBox(height: 20),
          gdscGestureRow()
        ],
      ),
    );
  }

  Row logoRow() {
    return Row(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: themeData.colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: themeData.colorScheme.onSurface.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            image: const DecorationImage(
              image: AssetImage("assets/icons/icon.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            versionRow(),
            const SizedBox(height: 10),
            Text(
              'Developed by Darryl David',
              style: TextStyle(
                color: themeData.colorScheme.onSurface,
                fontVariations: const [FontVariation('wght', 600)],
                fontFamily: fonts[0],
              ),
            ),
          ],
        ),
      ],
    );
  }

  GestureDetector gdscGestureRow() {
    return GestureDetector(
      onTap: () {
        _launchUrl(
            'https://gdg.community.dev/gdg-on-campus-indian-institute-of-technology-indore-india/');
      },
      child: Row(
        children: [
          Image.asset('assets/images/gdsclogo.png', width: 50),
          const SizedBox(width: 15),
          Text(
            'GDSC IIT Indore',
            style: TextStyle(
              color: themeData.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontFamily: fonts[0],
            ),
          ),
        ],
      ),
    );
  }

  Row versionRow() {
    return Row(
      children: [
        Text('Version 0.7.1',
            style: TextStyle(
              fontFamily: fonts[0],
              fontVariations: const [FontVariation('wght', 600)],
            )),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: themeData.colorScheme.surfaceBright,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: Text(
              'BETA',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
