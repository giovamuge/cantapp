import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// final Firestore _databaseReference = Firestore.instance;

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider.value(value: SongLyric(fontSize: 15.00)),
  ChangeNotifierProvider.value(
      value: ThemeChanger(appTheme, Constants.themeLight)),
  // ChangeNotifierProvider.value(
  //     value: Songs(databaseReference: FirebaseFirestore.instance)),
  // Provider<FirestoreDatabase>(
  //   create: (context) => FirestoreDatabase(
  //       uid: ""), // da modificare in caso di registrazione utente
  // ),
];
