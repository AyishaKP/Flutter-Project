import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'products.dart';
import 'package:http/http.dart' as http;
import 'list.dart';
import 'home.dart';
import 'package:flutter/foundation.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter TabBar',
      home: new Home(),
      theme: new ThemeData(primaryColor: Colors.grey, primarySwatch: Colors.grey),
    );
  }
}

Future<http.Response> fetchPost() {
  return http.get(
      'http://ae-dev.awok.com/api/home/?PAGED=1&IW=295&IH=295&PER_PAGE=40');
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  Products result = Products();
  List<Item> homeProducts = new List();

  Future<void> getProducts() async {
    final response = await http.get(
        'http://ae-dev.awok.com/api/home/?PAGED=1&IW=295&IH=295&PER_PAGE=20',
        headers: {"OS":"android", "App-Version":"19050","Country":"AE","Currency":"AED"});
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        result = Products.fromJson(jsonDecode(response.body));
        homeProducts = result.output.data.items;
        print(homeProducts);
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    tabController = new TabController(length: 2, vsync: this);
    var tabBarItem = new TabBar(
      tabs: <Widget>[
        Tab(
          icon: new Icon(Icons.list),
        ),
        Tab(
          icon: new Icon(Icons.grid_on),
        ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );

    var listItem = new ListView.builder(
        itemCount: result.output.data.items.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Card(
              elevation: 5.0,
              child: Container(
                alignment: Alignment.center,
                margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(result.output.data.items[index].name),
              ),
            ),
          );
        });

    var gridView = Column(
       
      children: <Widget>[
       
        Expanded(
          flex: 1,
          
          child: Container(
            color: Colors.red,
            child:
            Image.asset('images/banner.jpeg')
          ),

        ),
        Expanded(
          flex: 8,
          child: 
          
          Container(
            
            child :
              GridView.builder(
      //scrollDirection: Axis.horizontal,
        itemCount: homeProducts.length,
        // homeProducts.length + 1,
        //
        //result.output.data.items.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.65),
        itemBuilder: (BuildContext context, int index) {

          // if (index == 0) {
          //   return Container(
          //     child:  Image.asset('images/banner.jpeg'),

          //   );
          // }
          // index -= 1;
          return new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Column(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/placeholderIcon.png',
                    image: homeProducts[index].image.src,
                    //result.output.data.items[index].image.src,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0),
                    child: Text(
                      result.output.data.items[index].name,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(homeProducts[index].prices.priceNew +
                          'AED'),
                      new Text(
                        homeProducts[index].prices.priceOld + 'AED',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text('ADD TO CART ',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                //new Text('Item $index'),
              ),
            ),
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                child: new CupertinoAlertDialog(
                  title: new Column(
                    children: <Widget>[
                      new Text("GridView"),
                      new Icon(
                        Icons.favorite,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  content: new Text("Selected Item $index"),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text("OK"))
                  ],
                ),
              );
            },
          );
             
        }),

          ),

        ),
      ],
      

    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Tab with List & Grid"),
          bottom: tabBarItem,
          elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
        drawer: getDrawer(),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            listItem,
            gridView,
          ],
        ),
        bottomNavigationBar: getBootombar(),
      ),
    );
  }

  getBootombar() {
    return Container(
      height: 80.0,
      child: new TabBar(
      
  tabs: [
    Tab(
      icon: new Icon(Icons.home),
    ),
    Tab(
      icon: new Icon(Icons.rss_feed),
    ),
    Tab(
      icon: new Icon(Icons.perm_identity),
    ),
    Tab(icon: new Icon(Icons.settings),)
  ],
  labelColor: Colors.yellow,
  unselectedLabelColor: Colors.blue,
  indicatorSize: TabBarIndicatorSize.label,
  indicatorPadding: EdgeInsets.all(5.0),
  indicatorColor: Colors.red,
),

    );
    
  }

  getDrawer() {
   return Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Awok'),
                accountEmail: Text('awok@awok.co'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text('A'),

                ),

              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                trailing: Text('awok@awok.co'),
              ),
               Divider(),
                ListTile(
                leading: Icon(Icons.language),
                title: Text('English'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.pages),
                title: Text('My Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ListPage()));
                  
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(),
            ],
          ),
        );
  }
}
