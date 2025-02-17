import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khmenu_mobile/basic_module/file_upload_screen.dart';
import 'package:khmenu_mobile/myitem_module/myitem_provider.dart';
import 'package:khmenu_mobile/mystore_module/mystore_provider.dart';
import 'package:khmenu_mobile/users_module/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'counter_logic.dart';
import 'language_data.dart';
import 'language_logic.dart';
import 'about_screen.dart';
import 'theme_logic.dart';
import 'package:khmenu_mobile/env.dart';

class SettingStateScreen extends StatefulWidget {
  const SettingStateScreen({super.key});

  @override
  State<SettingStateScreen> createState() => _SettingStateScreenState();
}

class _SettingStateScreenState extends State<SettingStateScreen> {
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
                builder: (context) => AboutStateScreen(),
              ),
            );
          },
          icon: Icon(Icons.help),
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
          //DrawerHeader(child: Icon(Icons.face)),
          ExpansionTile(
            title: Text("Admin Tools"),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.people),
                title: Text("User Management"),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          randomUserProvider(), // Navigate to RandomUserProvider
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text("Store Management"),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          mystoreProvider(), // Navigate to RandomUserProvider
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text("Item Management"),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          myitemProvider(), // Navigate to RandomUserProvider
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text("File Management"),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          FileUploadScreen(), // Navigate to RandomUserProvider
                    ),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("ContactUs"),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.call),
                title: Text("Call Us"),
                onTap: () {
                  _launchInBrowser("tel:+85568666420");
                },
              ),
              ListTile(
                leading: Icon(Icons.web),
                title: Text("Website"),
                onTap: () {
                  _launchInBrowser(Env.apiBaseUrl);
                },
                trailing: _langIndex == 1 ? Icon(Icons.check_circle) : null,
              ),
            ],
          ),
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
                  "About KH Menu",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "KH Menu is a free platform for updating and customizing your shop menu in real-time, ensuring that your offerings are always accurate and up-to-date.",
                ),
                SizedBox(height: 20), // Added spacing
                Text(
                  "Our Team",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 10),
                _buildTeamCards(), // Call to the new method that builds the team cards
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(String name, String position, String description,
      String profileImagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              NetworkImage(profileImagePath), // Use the profile image
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              position,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCards() {
    return Column(
      children: [
        _buildTeamCard(
            "Heng Sombo",
            "Developer",
            "Sombo is the visionary behind KH Menu, guiding the requirments.",
            "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
        _buildTeamCard(
            "Som Sothea",
            "Developer",
            "Sothea drives the development of KH Menu with a keen eye for detail.",
            "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
        _buildTeamCard(
            "Sok Ratha",
            "Developer",
            "Ratha creates stunning UI/UX designs for a seamless user experience.",
            "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
      ],
    );
  }
}
