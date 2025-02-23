import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khmenu_mobile/admin_file_management/file_screen.dart';
import 'package:khmenu_mobile/admin_item_management/myitem_provider.dart';
import 'package:khmenu_mobile/admin_store_management/mystore_provider.dart';
import 'package:khmenu_mobile/admin_user_management/user_provider.dart';
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
    // Listen to theme and language changes
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    ThemeMode mode = context.watch<ThemeLogic>().mode;

    return Scaffold(
      appBar: _buildAppBar(mode),
      drawer: _buildDrawer(mode),
      body: _buildBody(),
    );
  }

  // Updated to accept theme mode
  AppBar _buildAppBar(ThemeMode mode) {
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
          icon: Icon(Icons.person),
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

  // Updated to accept theme mode
  Widget _buildDrawer(ThemeMode mode) {
    return FutureBuilder<String?>(
      future: Env.apiStorage.read(key: "userPermission"),
      builder: (context, snapshot) {
        bool isAdmin = snapshot.data == "ADMIN";

        return Drawer(
          child: ListView(
            children: [
              if (isAdmin) // Show Admin Tools only if user is an ADMIN
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
                            builder: (context) => randomUserProvider(),
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
                            builder: (context) => mystoreProvider(),
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
                            builder: (context) => myitemProvider(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.file_open),
                      title: Text("File Management"),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => FileUploadScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ExpansionTile(
                title: Text("Contact Us"),
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
                    trailing:
                        mode == ThemeMode.system ? Icon(Icons.check) : null,
                  ),
                  ListTile(
                    leading: Icon(Icons.light_mode),
                    title: Text(_lang.toLightMode),
                    onTap: () {
                      context.read<ThemeLogic>().changeToLight();
                    },
                    trailing:
                        mode == ThemeMode.light ? Icon(Icons.check) : null,
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
      },
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
          child: Container(
            margin: EdgeInsets.all(5), // Set margin to 2px
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
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  _buildContentsCards(context),
                  SizedBox(height: 5),
                  Text(
                    "Using QR code as menu",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Using QR codes as menus offers several advantages. Firstly, it eliminates the need for physical menus, reducing the risk of spreading germs or viruses through contact. Additionally, QR codes allow for easy and quick access to menu options, providing a seamless and convenient dining experience for customers.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "A better Store Control",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Having a better admin control over the QR code menu system provides store owners with greater flexibility and convenience. You can easily update and modify their menus in real-time Manage stores information: Easily update your store poster, contact and promotion. Manage products categorize: Manage category for each product that allows customer to quickly navigate through the options and find what they are looking for. Manage products: Our platform allows you to easily manage your product and make changes on the go. Stay in control of your menu, no matter where you are.",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentsCards(BuildContext context) {
    final List<Map<String, String>> contents = [
      {
        "title": "Mobile Friendly",
        "description":
            "With just a scan, customers can easily access the menu on their smartphones without the need for physical menus or waiting for a server to bring one.",
        "imageUrl": "assets/friendly.png"
      },
      {
        "title": "Faster Speed",
        "description":
            "Ability to provide a fast and efficient dining experience.",
        "imageUrl": "assets/speed.png"
      },
      {
        "title": "Easy to Maintain",
        "description": "Can be updated quickly and effortlessly.",
        "imageUrl": "assets/maintain.png"
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: contents.map((content) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      content["imageUrl"]!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content["title"]!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          content["description"]!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
