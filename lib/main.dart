import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_prov.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products_Prov(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        //all children of this class will now be notified about the changes
        //so provider should be created at the highest level of the data demand
        //rebuild will happen only in listeners, not in materialapp
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            fontFamily: "Lato",
            colorScheme: ColorScheme(
                //colorScheme is used since accentColor is deprecated
                brightness: Brightness.light,
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                secondary: Colors.amber,
                onSecondary: Colors.black,
                error: Colors.red,
                onError: Colors.black,
                background: Colors.white,
                onBackground: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black)),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
