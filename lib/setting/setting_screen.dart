import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBG,
      appBar: AppBar(
        title: Text("Impostazioni"),
      ),
      body: ListView(
        children: [
          SettingsSection(
            title: 'Principale',
            tiles: [
              SettingsTile(
                title: 'Testo',
                subtitle: 'Dimensione del testo',
                leading: Icon(Icons.format_size),
                onTap: () {},
              ),
              SettingsTile.switchTile(
                title: 'Modalità tema',
                subtitle: 'Scegli tra la modalità notte e giorno',
                leading: Icon(Icons.wb_sunny),
                switchValue: value,
                onToggle: (bool v) {
                  setState(() => value = v);
                  print('modalità tema: $v');
                  Provider.of<ThemeChanger>(context)
                      .setTheme(value ? ThemeData.light() : ThemeData.dark());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
