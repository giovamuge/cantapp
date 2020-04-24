import 'package:cantapp/activity/activity_card.dart';
import 'package:flutter/material.dart';

class ListActivityCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.00,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // imposta padding al primo elemento
          // per rispettare il margine a sinistra
          // da margine 20 sottraggo 5 quindi 15
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ActivityCardWidget(
              index: 0,
              color: Colors.orange,
              title: "Popolari",
              assetsImage: "icons/popularity.png",
            ),
          ),
          ActivityCardWidget(
            index: 1,
            color: Colors.lightBlue,
            title: "Novità",
            assetsImage: "icons/new.png",
          ),
          ActivityCardWidget(
            index: 2,
            color: Colors.lightGreen,
            title: "Proposte",
            assetsImage: "icons/plant_tree.png",
          ),
          // ActivityCardWidget(
          //   index: 3,
          //   color: Colors.orange,
          //   title: "Classici",
          //   assetsImage: "icons/popularity.png",
          // ),
          // ActivityCardWidget(
          //   index: 4,
          //   color: Colors.deepOrange,
          //   title: "sss",
          //   assetsImage: "icons/popularity.png",
          // ),
        ],
      ),
    );
  }
}
