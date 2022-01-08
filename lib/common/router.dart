// import 'package:cantapp/root/root.dart';
// import 'package:cantapp/song/song_model.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';

// import 'routes.dart' as routes;
// import '../home/home_screen.dart';
// import '../setting/setting_screen.dart';
// import '../playlist/playlist_screen.dart';
// import '../song/song_screen.dart';
// import '../song/servizi/servizi_screen.dart';
// import '../favorite/favorite_screen.dart';
// import '../category/category_screen.dart';

// final Map<String, WidgetBuilder> appRoutes = {
//   // Export static map routes
//   // '/' to tab screen
//   // '/song' detail song with lyric
//   '/': (context) => RootScreen(),
//   '/song': (context) => SongScreen(id: '')
// };

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case routes.defaultRoute:
//       // return MaterialPageRoute(builder: (context) => HomeScreen());
//       return MaterialPageRoute(
//         builder: (context) => Scaffold(
//           body: Center(
//             child: Text("caricamento..."),
//           ),
//         ),
//       );
//     case routes.homeRoute:
//       return MaterialPageRoute(builder: (context) => HomeScreen());
//     // case routes.settingRoute:
//     //   return MaterialPageRoute(builder: (context) => SettingScreen());
//     case routes.favoriteRoute:
//       return MaterialPageRoute(builder: (context) => FavoriteScreen());
//     case routes.playlistRoute:
//       return MaterialPageRoute(builder: (context) => PlaylistScreen());
//     case routes.categoryRoute:
//       return MaterialPageRoute(builder: (context) => CategoryScreen());
//     case routes.serviziRoute:
//       final song = settings.arguments as Song;
//       return MaterialPageRoute(builder: (context) => ServiziScreen(song: song));
//     case routes.serviziRoute:
//       final songId = settings.arguments as String;
//       return MaterialPageRoute(builder: (context) => SongScreen(id: songId));
//     default:
//       return MaterialPageRoute(
//         builder: (context) => Scaffold(
//           body: Center(
//             child: Text('No path for ${settings.name}'),
//           ),
//         ),
//       );
//   }
// }

// Route<dynamic> generateTabletRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case routes.serviziRoute:
//       final song = settings.arguments as Song;
//       return MaterialPageRoute(builder: (context) => ServiziScreen(song: song));
//     case routes.serviziRoute:
//       final songId = settings.arguments as String;
//       return MaterialPageRoute(builder: (context) => SongScreen(id: songId));
//     case routes.defaultRoute:
//       return MaterialPageRoute(
//           builder: (context) => Scaffold(body: Container()));
//     default:
//       return MaterialPageRoute(
//         builder: (context) => Scaffold(
//           body: Container(),
//         ),
//       );
//   }
// }

// Route<R> _buildRoute<R>(WidgetBuilder builder, String name) {
//   return MaterialPageRoute(
//       builder: builder, settings: RouteSettings(name: name));
// }
