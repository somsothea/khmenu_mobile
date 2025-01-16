import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';
import 'language_data.dart';
import 'language_logic.dart';
import 'second_state_screen.dart';
import 'theme_logic.dart';

class SimpleStateScreen extends StatefulWidget {
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
          icon: Icon(Icons.music_video),
        ),
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
              ListTile(
                leading: Text("CN"),
                title: Text(_lang.changeToChinese),
                onTap: () {
                  context.read<LanguageLogic>().changeToChinese();
                },
                trailing: _langIndex == 2 ? Icon(Icons.check_circle) : null,
              ),
              ListTile(
                leading: Text("TH"),
                title: Text(_lang.changeToThailand),
                onTap: () {
                  context.read<LanguageLogic>().changeToThailand();
                },
                trailing: _langIndex == 3 ? Icon(Icons.check_circle) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Shopping Cart"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Wish List"),
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: "Enter Email",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.visibility),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About Cambodia",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "Cambodia is a Southeast Asian nation whose landscape spans low-lying plains, the Mekong Delta, mountains and Gulf of Thailand coastline. Phnom Penh, its capital, is home to the art deco Central Market, glittering Royal Palace and the National Museum's historical and archaeological exhibits",
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
