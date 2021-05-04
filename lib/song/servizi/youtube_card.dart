import 'package:cantapp/common/utils.dart';
import 'package:cantapp/song/servizi/youtube_api.dart';
import 'package:cantapp/song/servizi/youtube_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YouTubeCard extends StatefulWidget {
  final double _heigth;
  final String _url;

  const YouTubeCard({required double heigth, required String url})
      : _heigth = heigth,
        _url = url;

  @override
  _YouTubeCardState createState() => _YouTubeCardState();
}

class _YouTubeCardState extends State<YouTubeCard>
    with SingleTickerProviderStateMixin
    implements AutomaticKeepAliveClientMixin<YouTubeCard> {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        value: 0.00, duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.00, end: 1.00).animate(_animationController!);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeigth = widget._heigth;
    final cardWidth = MediaQuery.of(context).size.width;

    final titleHeigth = cardHeigth * 60 / 100;
    final subHeight = cardHeigth * 40 / 100;
    final service = YouTubeApi();

    return FutureBuilder<YouTubeModel>(
      future: service.fetchVideo(widget._url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final video = snapshot.data;
          if (video != null) {
            _animationController?.forward();
            return FadeTransition(
              opacity: _animation!,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Utils.launchURL(widget._url),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(children: [
                      Container(
                        width: cardWidth,
                        height: titleHeigth,
                        child: Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: cardWidth,
                        height: subHeight,
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(video.title,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.youtube,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          height: 10,
                                          width: 1,
                                          alignment: Alignment.center,
                                          color: Colors.grey,
                                        )),
                                    Text(video.authorName,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13))
                                  ],
                                ),
                                RawGestureDetector(
                                    gestures: {
                                      AllowMultipleGestureRecognizer:
                                          GestureRecognizerFactoryWithHandlers<
                                              AllowMultipleGestureRecognizer>(
                                        () =>
                                            AllowMultipleGestureRecognizer(), //constructor
                                        (AllowMultipleGestureRecognizer
                                            instance) {
                                          //initializer
                                          instance.onTap = () =>
                                              print('options on video youtube');
                                        },
                                      )
                                    },
                                    //Creates the nested container within the first.
                                    child: Icon(FontAwesomeIcons.ellipsisV,
                                        size: 15))
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            height: cardHeigth,
            width: cardWidth,
            color: Colors.white,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('Video al momento non disponibile'),
            ),
          );
        }

        // By default, show a loading spinner.
        // return Shimmer.fromColors(
        //   baseColor: Colors.grey[100],
        //   highlightColor: Colors.grey[300],
        //   child: Container(
        //     height: cardHeigth,
        //     width: cardWidth,
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        //   ),
        // );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            height: cardHeigth,
            width: cardWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
          ),
        );

        // return Container();
      },
    );
  }

  @override
  void updateKeepAlive() {
    print('updateKeepAlive called');
  }

  @override
  bool get wantKeepAlive => true;
}

// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
