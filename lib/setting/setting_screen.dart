import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/common/utils.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/utils/song_util.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'widgets/settings_switch_tile.dart';
import 'widgets/settings_tile.dart';
// import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _value = false;
  Shared _shared;
  String _versionName;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _shared = new Shared();
    _shared.getThemeMode().then((theme) => setState(
        () => _value = theme == Constants.themeLight || theme == null));
    PackageInfo.fromPlatform()
        .then((info) => setState(() => _versionName = info.version));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Impostazioni"),
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          SettingsSection(
            title: 'Informazioni',
            tiles: [
              SettingsTile(
                title: 'Versoine',
                leading: Icon(Icons.verified_user),
                subtitle: _versionName,
              ),
              SettingsTile(
                title: 'Sviluppatore',
                leading: Icon(Icons.supervised_user_circle),
                onTap: () async => await Utils.launchURL(
                    'https://www.linkedin.com/in/giovanni-mugelli/'),
              )
            ],
          ),
          SettingsSection(
            title: 'Stile',
            tiles: [
              SettingsTile(
                title: 'Testo',
                subtitle: Provider.of<SongLyric>(context).toStringFontSize(),
                leading: Icon(Icons.format_size),
                onTap: () async =>
                    await SongUtil().settingModalBottomSheet(context),
              ),
              SettingsSwitchTile(
                title: 'Modalità Giorno',
                subtitle: 'Scegli tra la modalità notte e giorno',
                leading: Icon(Icons.wb_sunny),
                switchValue: _value,
                onChanged: (bool v) {
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
          SettingsSection(
            title: 'Note legali',
            tiles: [
              SettingsTile(
                title: 'Policy & Privacy',
                leading: Icon(Icons.security),
                onTap: () async => await Utils.launchURL(
                    'https://us-central1-mgc-cantapp.cloudfunctions.net/privacyAndPolicy'),
              ),
              SettingsTile(
                title: 'Disclaimer',
                leading: Icon(Icons.warning_rounded),
                onTap: () async => await Utils.launchURL(
                    'https://us-central1-mgc-cantapp.cloudfunctions.net/disclaimer'),
                // onTap: () async => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DisclaimerScreen(),
                //   ),
                // ),
              ),
            ],
          ),
          SettingsSection(
            title: 'Richieste',
            tiles: [
              SettingsTile(
                title: 'Nuovo canto',
                leading: Icon(Icons.add_circle),
                onTap: () async => await Utils.launchURL(
                    'https://forms.gle/H2HFQ8EpaWgQJs7d6'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String _title;
  final List<Widget> _tiles;

  const SettingsSection({String title, List<Widget> tiles})
      : _title = title,
        _tiles = tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 15, right: 15.00, top: 25.00, bottom: 10.00),
          child: Text(
            _title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.00,
                color: Theme.of(context).textTheme.headline1.color),
          ),
        ),
        ..._tiles
      ],
    );
  }
}
