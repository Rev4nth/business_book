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
            onPressed: () async {
              var reload;
              if (_pages[_selectedPageIndex]['title'] == 'Sales') {
                reload = await Navigator.of(context)
                    .pushNamed(SaleAddScreen.routeName);
                if (reload) {
                  _selectPage(0);
                }
              }
              if (_pages[_selectedPageIndex]['title'] == 'Expenses') {
                reload = await Navigator.of(context)
                    .pushNamed(ExpenseAddScreen.routeName);
                if (reload) {
                  _selectPage(1);
                }
              }
              if (_pages[_selectedPageIndex]['title'] == 'Customers') {
                reload = await Navigator.of(context)
                    .pushNamed(CustomerAddScreen.routeName);
                if (reload) {
                  _selectPage(2);
                }
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
            icon: Icon(Icons.arrow_downward),
            title: Text('Sales'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.arrow_upward),
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
