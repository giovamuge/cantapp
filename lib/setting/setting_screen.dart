import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _value = false;
  Shared _shared;

  @override
  void initState() {
    _shared = new Shared();
    _shared.getThemeMode().then(
        (theme) => setState(() => _value = theme == Constants.themeLight));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                title: 'Modalità Giorno',
                subtitle: 'Scegli tra la modalità notte e giorno',
                leading: Icon(Icons.wb_sunny),
                switchValue: _value,
                onToggle: (bool v) {
                  setState(() => _value = v);
                  print('modalità tema: $v');
                  final theme =
                      Provider.of<ThemeChanger>(context, listen: false);
                  theme.setTheme(_value ? appTheme : appThemeDark,
                      _value ? Constants.themeLight : Constants.themeDark);
                  _shared.setThemeMode(
                      _value ? Constants.themeLight : Constants.themeDark);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
