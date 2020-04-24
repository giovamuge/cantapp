import 'package:cantapp/song/song_model.dart';
import 'package:flutter/widgets.dart';

enum CategoryEnum {
  ingresso,
  pace,
  agnellodidio,
  comunione,
  mariani,
  canoni,
  inni,
  quaresima,
  natale,
  finali,
  offertorio,
  credo,
  alleluia,
  gloria,
  signorepieta
}

class Category {
  const Category({@required this.title, @required this.value, this.songs});

  final String title;
  final CategoryEnum value;
  final List<Song> songs;

  toString() {
    var valueData = value.toString();
    var splitted = valueData.split('.');
    return splitted[1];
  }
}

class Categories {
  List<Category> _items = [
    new Category(value: CategoryEnum.agnellodidio, title: 'Agnello di Dio'),
    new Category(value: CategoryEnum.alleluia, title: 'Alleluia'),
    new Category(value: CategoryEnum.canoni, title: 'Canoni'),
    new Category(value: CategoryEnum.comunione, title: 'Comunione'),
    new Category(value: CategoryEnum.credo, title: 'Credo'),
    new Category(value: CategoryEnum.finali, title: 'Finali'),
    new Category(value: CategoryEnum.gloria, title: 'Gloria'),
    new Category(value: CategoryEnum.ingresso, title: 'Ingresso'),
    new Category(value: CategoryEnum.inni, title: 'Inni'),
    new Category(value: CategoryEnum.mariani, title: 'Mariani'),
    new Category(value: CategoryEnum.natale, title: 'Natale'),
    new Category(value: CategoryEnum.offertorio, title: 'Offertorio'),
    new Category(value: CategoryEnum.pace, title: 'Pace'),
    new Category(value: CategoryEnum.quaresima, title: 'Quaresima'),
    new Category(value: CategoryEnum.signorepieta, title: 'Signore Pietà'),
  ];

  List<Category> get items {
    return [..._items];
  }

  // Future<void> fetchSongsToCategories(List<Song> songs) async {
  //   songs.forEach((s) {
  //     _items.forEach((c) {
  //       if (s.categories.length > 0) {
  //         var cat = c.toString();
  //         var index = s.categories.indexOf(cat.toLowerCase());
  //         if (index > -1) {
  //           var songs = c.songs;
  //           if (songs == null) {
  //             songs = [];
  //           }
  //           songs.add(s);
  //           c.songs = songs;
  //           // print('songs: ${s.title}, added to ${c.title}');
  //         }
  //       }
  //     });
  //   });

  //   notifyListeners();
  // }
}
