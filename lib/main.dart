import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SDUI Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
/// Fetch this json from your backend or i would suggest a CMS
  final Map<String, dynamic> json = const {
    "type": "Column",
    "padding": 16,
    "children": [
      {
        "type": "Image",
        "url": "https://cdn.app.com/banner.png",
        "height": 200
      },
      {
        "type": "Text",
        "value": "Discover Hidden Gems",
        "style": {
          "fontSize": 24,
          "fontWeight": "bold"
        }
      },
      {
        "type": "Text",
        "value": "Explore curated destinations just for you.",
        "style": {
          "fontSize": 16,
          "color": "#888888"
        }
      },
      {
        "type": "Button",
        "label": "Start Exploring",
        "action": {
          "type": "navigate",
          "route": "/home"
        }
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server-Driven UI')),
      body: buildWidgetFromJson(json, context),
    );
  }
}

Widget buildWidgetFromJson(Map<String, dynamic> json, BuildContext context) {
  switch (json['type']) {
    case 'Text':
      final style = json['style'] ?? {};
      return Text(
        json['value'] ?? '',
        style: TextStyle(
          fontSize: (style['fontSize'] ?? 14).toDouble(),
          fontWeight: (style['fontWeight'] == 'bold') ? FontWeight.bold : FontWeight.normal,
          color: style['color'] != null ? HexColor.fromHex(style['color']) : null,
        ),
      );
    case 'Image':
      return Image.network(
        json['url'],
        height: (json['height'] ?? 100).toDouble(),
      );
    case 'Button':
      return ElevatedButton(
        onPressed: () {
          final route = json['action']?['route'];
          if (route != null) Navigator.pushNamed(context, route);
        },
        child: Text(json['label'] ?? 'Button'),
      );
    case 'Column':
      final children = (json['children'] as List<dynamic>)
          .map((child) => buildWidgetFromJson(child, context))
          .toList();
      return Padding(
        padding: EdgeInsets.all((json['padding'] ?? 0).toDouble()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    default:
      return const SizedBox.shrink();
  }
}

class HexColor extends Color {
  HexColor(final int hex) : super(hex);

  factory HexColor.fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return HexColor(int.parse(buffer.toString(), radix: 16));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Welcome to Home Page!')),
    );
  }
}
