import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khmenu_mobile/login_module/fakestore_loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'counter_logic.dart';
import 'language_data.dart';
import 'language_logic.dart';
import 'second_state_screen.dart';
import 'theme_logic.dart';

class SimpleStateScreen extends StatefulWidget {
  const SimpleStateScreen({super.key});

  @override
  State<SimpleStateScreen> createState() => _SimpleStateScreenState();
}

class _SimpleStateScreenState extends State<SimpleStateScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_lang.appName),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => SecondStateScreen(),
              ),
            );
          },
          icon: Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () {
            context.read<CounterLogic>().decrease();
          },
          icon: Icon(Icons.remove),
        ),
        IconButton(
          onPressed: () {
            context.read<CounterLogic>().increase();
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    ThemeMode mode = context.watch<ThemeLogic>().mode;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Icon(Icons.face)),
          ExpansionTile(
            title: Text(_lang.themeColor),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.phone_android),
                title: Text(_lang.toSystemMode),
                onTap: () {
                  context.read<ThemeLogic>().changeToSystem();
                },
                trailing: mode == ThemeMode.system ? Icon(Icons.check) : null,
              ),
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text(_lang.toLightMode),
                onTap: () {
                  context.read<ThemeLogic>().changeToLight();
                },
                trailing: mode == ThemeMode.light ? Icon(Icons.check) : null,
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text(_lang.toDarkMode),
                onTap: () {
                  context.read<ThemeLogic>().changeToDark();
                },
                trailing: mode == ThemeMode.dark ? Icon(Icons.check) : null,
              ),
            ],
          ),
          ExpansionTile(
            title: Text(_lang.language),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Text("ខ្មែរ"),
                title: Text(_lang.changeToKhmer),
                onTap: () {
                  context.read<LanguageLogic>().changToKhmer();
                },
                trailing: _langIndex == 0 ? Icon(Icons.check_circle) : null,
              ),
              ListTile(
                leading: Text("EN"),
                title: Text(_lang.changeToEnglish),
                onTap: () {
                  context.read<LanguageLogic>().changeToEnglish();
                },
                trailing: _langIndex == 1 ? Icon(Icons.check_circle) : null,
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text("Contact Us"),
            onTap: () {
              // _launchInBrowser("https://google.com");
              _launchInBrowser("tel:+85568666420");
              // _launchInBrowser("https://google.com");
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String uri) async {
    Uri url = Uri.parse(uri);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About KH menu",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "Cloud Menu is a free platform for update and customize your shop menu in real-time, ensuring that your offerings are always accurate and up-to-date.",
                ),
                Text(
                  "Updated on 08/01/2025",
                  style: Theme.of(context).textTheme.displaySmall,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
