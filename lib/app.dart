import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wifi_photo/views/drawer/about_page.dart';
import 'package:wifi_photo/views/drawer/connect.dart';
import 'package:wifi_photo/views/drawer/settings.dart';
import 'package:wifi_photo/views/home/widescreen_home.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/constants.dart';
import 'controllers/intents.dart';
import 'views/drawer/history.dart';
import 'views/home/mobile_home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  null,
        title: const Text(
          'WIFI_PHOTO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: appBarGradient,
        )
      ),
      drawer: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.backspace): GoBackIntent()
        },
        child: Actions(
          actions: {
            GoBackIntent: CallbackAction<GoBackIntent>(onInvoke: (intent) {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.openEndDrawer();
              }
              return null;
            })
          },
          child: Drawer(
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/icon.png',
                        width: 75,
                        height: 75,
                      ),
                      const Text('WIFI_PHOTO')
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    UniconsSolid.history,
                    color: Colors.black,
                  ),
                  title: const Text('Received-history'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const HistoryPage();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.connecting_airports_sharp,
                    color: Colors.black,
                  ),
                  title: const Text("connect"),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Connect();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child:
        size.width > 720 ? const WidescreenHome() : const MobileHome(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
        Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Help"),
                  content: const Text(
                    """1. Before sharing files make sure that you are connected to wifi or your mobile-hotspot is turned on.\n\n2. While receiving make sure you are connected to the same wifi or hotspot as that of sender.""",
                    textAlign: TextAlign.justify,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                  ],
                );
              });
        },
        icon: const Text("Help"),
        label: const Icon(Icons.help),
      ),
    );
  }
}
