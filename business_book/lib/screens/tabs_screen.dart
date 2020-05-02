import 'package:flutter/material.dart';

import './sales_list_screen.dart';
import './customers_list_screen.dart';
import './expenses_list_screen.dart';
import './sale_add_screen.dart';
import './customer_add_screen.dart';
import './expense_add_screen.dart';
import '../widgets/app_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
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
        'page': ExpensesListScreen(),
        'title': 'Expenses',
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
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_pages[_selectedPageIndex]['title'] == 'Sales') {
                Navigator.of(context).pushNamed(SaleAddScreen.routeName);
              }
              if (_pages[_selectedPageIndex]['title'] == 'Expenses') {
                Navigator.of(context).pushNamed(ExpenseAddScreen.routeName);
              }
              if (_pages[_selectedPageIndex]['title'] == 'Customers') {
                Navigator.of(context).pushNamed(CustomerAddScreen.routeName);
              }
            },
          )
        ],
      ),
      drawer: AppDrawer(),
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
            title: Text('Expenses'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.people),
            title: Text('Customers'),
          ),
        ],
      ),
    );
  }
}
