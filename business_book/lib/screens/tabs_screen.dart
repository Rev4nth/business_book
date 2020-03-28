import 'package:flutter/material.dart';

import './customers_list_screen.dart';
import './edit_sale_screen.dart';
import './sales_list_screen.dart';
import './edit_customer_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': SalesListScreen(),
        'title': 'Sales',
      },
      {
        'page': CustomersListScreen(),
        'title': 'Customers',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title']),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (_pages[_selectedPageIndex]['title'] == 'Sales') {
                  Navigator.of(context).pushNamed(EditSale.routeName);
                }
                if (_pages[_selectedPageIndex]['title'] == 'Customers') {
                  Navigator.of(context).pushNamed(EditCustomer.routeName);
                }
              },
            )
          ],
        ),
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.work),
              title: Text('Sales'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.people),
              title: Text('Customers'),
            ),
          ],
        ));
  }
}
