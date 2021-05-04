import 'package:cantapp/common/utils.dart';
import 'package:cantapp/song/servizi/chord_screen.dart';
import 'package:cantapp/song/servizi/youtube_card.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiziScreen extends StatefulWidget {
  final Song song;
  const ServiziScreen({required this.song});

  @override
  _ServiziScreenState createState() => _ServiziScreenState();
}

class _ServiziScreenState extends State<ServiziScreen> {
  PageController _controller =
      PageController(initialPage: 0, viewportFraction: .9);

  @override
  void initState() => super.initState();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.song.links.where((l) => l.type == 'youtube').toList();
    final audios = widget.song.links.where((l) => l.type == 'audio').toList();
    return Scaffold(
      appBar: AppBar(title: Text("Servizi")),
      body: SafeArea(
        child: ListView(
          // padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     "Servizi",
            //     style: TextStyle(
            //       fontSize: 35,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Accordi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // FlatButton(
                  //   child: Text("visualizza tutto"),
                  //   textColor: Colors.yellow,
                  //   padding: const EdgeInsets.all(0),
                  //   onPressed: () {},
                  // )
                ],
              ),
            ),
            _buildListChords(),

            SizedBox(height: 30),

            ..._buildVideos(videos),

            SizedBox(height: 10),

            ..._buildAudios(audios),

            SizedBox(height: 80.00)
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVideos(List<Link> videos) {
    if (videos.length > 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "YouTube",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // FlatButton(
              //   child: Text("visualizza tutto"),
              //   textColor: Colors.yellow,
              //   padding: const EdgeInsets.all(0),
              //   onPressed: () {},
              // )
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 300.00,
          child: PageView.builder(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            // onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: videos.length,
            itemBuilder: (ctx, index) =>
                YouTubeCard(heigth: 300.00, url: videos[index].url),
          ),
        ),
      ];
    } else {
      return [Container()];
    }
  }

  List<Widget> _buildAudios(List<Link> audios) {
    if (audios.length > 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Audio mp3",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // FlatButton(
              //   child: Text("visualizza tutto"),
              //   textColor: Colors.yellow,
              //   padding: const EdgeInsets.all(0),
              //   onPressed: () {},
              // )
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final double cardHeigth = 200;
              final double cardWidth = 150;

              final double titleHeigth = cardHeigth * 66 / 100;
              final double subHeight = cardHeigth * 34 / 100;

              final double paddingLeft = (index == 0) ? 20.00 : 5.00;

              return Padding(
                padding: EdgeInsets.only(left: paddingLeft, right: 5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Utils.launchURL(
                      'https://www.youtube.com/watch?v=CReCKHj8GTk'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(children: [
                      Container(
                        width: cardWidth,
                        height: titleHeigth,
                        color: Colors.yellow,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.headphones,
                            color: Colors.white,
                            size: 50.00,
                          ),
                        ),
                      ),
                      Container(
                        width: cardWidth,
                        height: subHeight,
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            "MOSCA in 40ena e l'INCIDENTE DIPLOMATICO RUSSIA-ITALIA"),
                      )
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ];
    } else {
      return [Container()];
    }
  }

  Widget _buildListChords() {
    if (widget.song == null || widget.song.chord == null) {
      return Container(
        padding: const EdgeInsets.only(left: 20),
        child: Text("Non ci sono accordi"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChordScreen(song: widget.song))),
          title: Text("Versione 1"),
          leading: CircleAvatar(
            maxRadius: 20,
            backgroundColor: Colors.purple[100],
            child: Text(
              '1',
              style: TextStyle(
                  color: Colors.purple[900],
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        );
      },
    );
  }
}
