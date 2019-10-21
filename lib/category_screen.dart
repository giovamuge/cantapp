import 'package:cantapp/song_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Category({@required this.title, @required this.value, this.songs});

  String title;
  CategoryEnum value;
  List<Song> songs;
}

final List<Category> categories = [
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

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Categorie'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[500],
          indent: 15.00,
          thickness: .30,
          height: 0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, i) => ListTile(
          trailing: Icon(
            Icons.chevron_right,
            size: 20.00,
          ),
          title: Text(categories[i].title),
          onTap: () => {},
        ),
      ),
    );
  }
}
