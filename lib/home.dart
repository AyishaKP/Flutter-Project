import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'products.dart';
import 'package:http/http.dart' as http;
import 'list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter TabBar',
      home: new HomeScreen(),
      theme: new ThemeData(primaryColor: Colors.black),
    );
  }
}

Future<http.Response> fetchPost() {
  return http.get(
      'http://ae-dev.awok.com/api/home/?PAGED=1&IW=295&IH=295&PER_PAGE=40');
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}
class _HomeState extends State<HomeScreen>  {
  Products result = Products();
  List<Item> homeProducts = new List();

  Future<void> getProducts() async {
    final response = await http.get(
        'http://ae-dev.awok.com/api/home/?PAGED=1&IW=295&IH=295&PER_PAGE=20');
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
            Container(
            color: Colors.red,
            child:
            Image.asset('images/banner.jpeg')

            //  FadeInImage.assetNetwork(
            //         placeholder: 'images/placeholderIcon.png',
            //         image: result.,
            //         //result.output.data.items[index].image.src,
            //       ),
          ),


          GridView.builder(
      //scrollDirection: Axis.horizontal,
        itemCount: homeProducts.length,
        // homeProducts.length + 1,
        //
        //result.output.data.items.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.65),
            primary: false,
            shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Card(
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
                            MaterialPageRoute(builder: (context) => ListPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                //new Text('Item $index'),
              ),
            );
        },
        
      //     ),
       

      // ),
          
   
          ),

        ],

      ),
          
      );
   
  }
}