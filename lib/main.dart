import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis_auth/googleapis_auth.dart'; // Add this line
import 'package:provider/provider.dart';

import 'src/adaptive_login.dart'; // Add this line
import 'src/adaptive_playlists.dart';
import 'src/app_state.dart';
import 'src/playlist_details.dart';

final scopes = [
  'https://www.googleapis.com/auth/youtube.readonly',
];

final clientId = ClientId(
  '581670214734-5jaus7ll87ekj6a19q0c8ovt2lnur386.apps.googleusercontent.com',
  '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',
);

final _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const AdaptivePlaylists();
      },
      // Add redirect configuration
      redirect: (context, state) {
        if (!context.read<AuthedUserPlaylists>().isLoggedIn) {
          return '/login';
        } else {
          return null;
        }
      },
      // To this line
      routes: <RouteBase>[
        // Add new login Route
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return AdaptiveLogin(
              clientId: clientId,
              scopes: scopes,
              loginButtonChild: const Text('Login to YouTube'),
            );
          },
        ),
        // To this line
        GoRoute(
          path: 'playlist/:id',
          builder: (context, state) {
            final title = '$state.queryParams[`title`]!';
            final id = '$state.params[`id`]!';
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: PlaylistDetails(
                playlistId: id,
                playlistName: title,
              ),
            );
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(ChangeNotifierProvider<AuthedUserPlaylists>(
    // Modify this line
    create: (context) => AuthedUserPlaylists(), // Modify this line
    child: const PlaylistsApp(),
  ));
}

class PlaylistsApp extends StatelessWidget {
  const PlaylistsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Your Playlists', // Change FlutterDev to Your
      theme: FlexColorScheme.light(
        scheme: FlexScheme.red,
        useMaterial3: true,
      ).toTheme,
      darkTheme: FlexColorScheme.dark(
        scheme: FlexScheme.red,
        useMaterial3: true,
      ).toTheme,
      themeMode: ThemeMode.dark, // Or ThemeMode.System if you'd prefer
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
