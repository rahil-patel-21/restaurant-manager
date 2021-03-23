import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CardWidget.dart';
import '../elements/EmptyRestaurantsWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class RestaurantsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  RestaurantsWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _RestaurantsWidgetState createState() => _RestaurantsWidgetState();
}

class _RestaurantsWidgetState extends StateMVC<RestaurantsWidget> {
  RestaurantController _con;

  _RestaurantsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).myRestaurants,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshRestaurants,
        child: _con.restaurants.isEmpty
            ? EmptyRestaurantsWidget()
            : ListView.builder(
                shrinkWrap: true,
                primary: true,
                itemCount: _con.restaurants.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/Details',
                          arguments: RouteArgument(
                            id: _con.restaurants.elementAt(index).id,
                            heroTag: 'my_restaurants',
                          ));
                    },
                    child: CardWidget(restaurant: _con.restaurants.elementAt(index), heroTag: 'my_restaurants'),
                  );
                },
              ),
      ),
    );
  }
}
