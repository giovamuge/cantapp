import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/common/utils.dart';
import 'package:cantapp/setting/note_legali/disclaimer_screen.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/utils/song_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

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
