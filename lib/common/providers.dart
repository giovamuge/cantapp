import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// final Firestore _databaseReference = Firestore.instance;

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider.value(value: Favorites()),
  ChangeNotifierProvider.value(value: SongLyric(fontSize: 15.00)),
  ChangeNotifierProvider.value(
      value: ThemeChanger(appTheme, Constants.themeLight)),
  ChangeNotifierProvider.value(
      value: Songs(databaseReference: Firestore.instance)),
  Provider<FirestoreDatabase>(
    create: (context) => FirestoreDatabase(
        uid: ""), // da modificare in caso di registrazione utente
  ),
];
