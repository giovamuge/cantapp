import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// final Firestore _databaseReference = Firestore.instance;

final List<SingleChildWidget> appProviders = [
  // ChangeNotifierProvider.value(value: Categories()),
  ChangeNotifierProvider.value(value: Favorites()),
  ChangeNotifierProvider.value(
      value: Songs(databaseReference: Firestore.instance))
  // ChangeNotifierProvider<Categories>(
  //   create: (_) => Categories(),
  // ),
  // ChangeNotifierProvider<Favorites>(create: (_) => Favorites()),
  // ChangeNotifierProvider<Songs>(
  //     create: (_) => Songs(databaseReference: _databaseReference))
];
