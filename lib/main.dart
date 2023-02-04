import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '../providers/orders.dart';
import '../screens/edit_product_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_prov.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products_Prov>(
          update: (context, auth, prevProds) => Products_Prov(
              auth.token, prevProds == null ? [] : prevProds.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prevOrds) =>
              Orders(auth.token, prevOrds == null ? [] : prevOrds.orders),
        ),
        //all children of this class will now be notified about the changes
        //so provider should be created at the highest level of the data demand
        //rebuild will happen only in listeners, not in materialapp
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
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
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            )),
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
