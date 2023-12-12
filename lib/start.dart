import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryozan_shop/auth.dart';
import 'package:ryozan_shop/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cache.dart';
import 'db.dart';
import 'main.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => StartState();
}

class StartState extends State<Start> {
  static List<Map<String, dynamic>> productData = [];
  static List<Map<String, dynamic>> cart = [];
  static double w = 400;
  static double h = 150;

  @override
  void initState() {
    productData = ProductInfo.data;
    cart = ProductInfo.cart;
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Object?> getNavigator() {
    return Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
  }

  _cartPage() {
    if (cart.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProductPage(
                                productIndex:
                                    int.parse(cart[index].keys.elementAt(0)) -
                                        1,
                                notifyParent: () {
                                  Timer.periodic(const Duration(seconds: 1),
                                      (Timer t) => setState(() {}));
                                },
                              ),
                            ));
                      },
                      child: SizedBox(
                          height: 110,
                          child: SizedBox(
                            width: w * 0.94,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              color: Colors.white70,
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: w * 0.28,
                                        maxHeight: h * 0.28,
                                      ),
                                      child: Image.network(
                                          productData[int.parse(cart[index]
                                                  .keys
                                                  .elementAt(0)) -
                                              1]["link"],
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: w * 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 0, 0),
                                          child: Text(
                                            '${productData[int.parse(cart[index].keys.elementAt(0)) - 1]["name"]}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 0, 0),
                                          child: Text(
                                            "${productData[int.parse(cart[index].keys.elementAt(0)) - 1]["description"]}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 40, 0, 0),
                                        child: Text(
                                          (cart[index].values)
                                              .toString()
                                              .substring(1, 2),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(padding: EdgeInsets.only(top: 10));
            },
            itemCount: cart.length,
            shrinkWrap: true,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black, width: 2),
            ),
            onPressed: () async {
              await ProductInfo.placeOrder(
                  Supabase.instance.client.auth.currentUser?.id,
                  Supabase.instance.client.auth.currentUser?.email);
              cart = [];
              await ProductInfo.clearCart(
                  Supabase.instance.client.auth.currentUser?.id);
              setState(() {});
              Fluttertoast.showToast(
                  msg: "Заказ сделан!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            child: const Text(
              "Сделать Заказ",
              style: TextStyle(color: Colors.black),
            ),
          )
        ]),
      );
    } else {
      return const Column(children: [
        Padding(padding: EdgeInsets.only(top: 20)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Корзина пуста",
            style: TextStyle(fontSize: 20),
          )
        ])
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      SingleChildScrollView(
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProductPage(
                                  productIndex: index,
                                  notifyParent: () {
                                    Timer.periodic(const Duration(seconds: 1),
                                        (Timer t) => setState(() {}));
                                  }),
                            ));
                      },
                      child: SizedBox(
                          height: 110,
                          child: SizedBox(
                            width: w * 0.94,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              color: Colors.white70,
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: w * 0.28,
                                        maxHeight: h * 0.28,
                                      ),
                                      child: Image.network(
                                          productData[index]["link"],
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: w * 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 0, 0),
                                          child: Text(
                                            '${productData[index]["name"]}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 0, 0),
                                          child: Text(
                                            "${productData[index]["description"]}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 40, 0, 0),
                                        child: Text(
                                          '₽ ${productData[index]["price"]}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(padding: EdgeInsets.only(top: 10));
            },
            itemCount: ProductInfo.data.length,
            shrinkWrap: true,
          ),
        ]),
      ),
      _cartPage(),
    ];
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  CurrentUserData.email,
                  style: const TextStyle(fontSize: 15),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset('assets/user_pic.jpg'),
                  ),
                ),
                decoration: const BoxDecoration(color: Colors.black38),
                accountEmail: null,
              ),
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        centerTitle: true,
        title: const Text(
          "Ryuzan",
          style: TextStyle(fontFamily: "Roboto", fontSize: 35),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: widgetOptions[_selectedIndex],
      )),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 31,
            ),
            title: const Text(
              "Главная",
              style: TextStyle(fontSize: 23),
            ),
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart,
              size: 31,
            ),
            title: const Text(
              "Корзина",
              style: TextStyle(fontSize: 23),
            ),
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 31,
            ),
            title: const Text(
              "Выйти из аккаунта",
              style: TextStyle(fontSize: 23),
            ),
            onTap: () async {
              SupabaseAuthRepository sba = SupabaseAuthRepository();
              sba.signOut();
              SharedPreferences sp = await SharedPreferences.getInstance();
              LocalDataAnalyse LDA = LocalDataAnalyse(sp: sp);
              LDA.setLoginStatus("0", "", "");
              CurrentUserData.email = "";
              CurrentUserData.pass = "";
              getNavigator();
            },
          ),
        ],
      );
}
