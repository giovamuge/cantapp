// import 'package:cantapp/favorite/favorite_bloc.dart';
// import "package:flutter/widgets.dart";
// // import "package:timeline/blocs/favorites_bloc.dart";
// // import 'package:timeline/search_manager.dart';
// // import 'package:timeline/timeline/timeline.dart';
// // import 'package:timeline/timeline/timeline_entry.dart';

// /// This [InheritedWidget] wraps the whole app, and provides access
// /// to the user's favorites through the [FavoritesBloc]
// /// and the [Timeline] object.
// class BlocProvider extends InheritedWidget {
//   final FavoritesBloc favoritesBloc;

//   /// This widget is initialized when the app boots up, and thus loads the resources.
//   /// The timeline.json file contains all the entries' data.
//   /// Once those entries have been loaded, load also all the favorites.
//   /// Lastly use the entries' references to load a local dictionary for the [SearchManager].
//   BlocProvider(
//       {Key key,
//       FavoritesBloc fb,
//       @required Widget child,
//       TargetPlatform platform = TargetPlatform.iOS})
//       : favoritesBloc = fb ?? FavoritesBloc(),
//         super(key: key, child: child) {

//       // // /// All the entries are loaded, we can fill in the [favoritesBloc]...
//       // favoritesBloc.init(entries);

//       // // /// ...and initialize the [SearchManager].
//       // SearchManager.init(entries);
//     // });
//   }

//   @override
//   updateShouldNotify(InheritedWidget oldWidget) => true;

//   /// static accessor for the [FavoritesBloc].
//   /// e.g. [ArticleWidget] retrieves the favorites information using this static getter.
//   static FavoritesBloc favorites(BuildContext context) {
//     BlocProvider bp =
//         (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider);
//     FavoritesBloc bloc = bp?.favoritesBloc;
//     return bloc;
//   }
// }
