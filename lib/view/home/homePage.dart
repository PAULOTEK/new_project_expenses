import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/transaction.model.dart';
import '../../widgets/chart_widget/chart.dart';
import '../../widgets/transaction_form/transaction_form.dart';
import '../../widgets/trasaction_list/transaction_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChar = false;

  @override
  Widget build(BuildContext context) {
    bool isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    final actions = <Widget>[
      if (isLandScape)
        _getIconButtom(
          _showChar ? Icons.list : Icons.pie_chart,
          () => setState(
            () {
              _showChar = !_showChar;
            },
          ),
        ),
      _getIconButtom(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        _openTransactionFormModal(context),
      ),
    ];
    final PreferredSizeWidget? appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Despesas Pessoais'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                actions.first,
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Despesas Pessoais',
            ),
            actions: actions)) as PreferredSizeWidget?;
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final pageBody = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showChar || !isLandScape)
            SizedBox(
              height: availableHeight * (isLandScape ? 0.7 : 0.3),
              child: ChartWidget(_recentTransactions),
            ),
          if (!_showChar || !isLandScape)
            SizedBox(
              height: availableHeight * (isLandScape ? 1 : 0.7),
              child: TransactionList(
                  transactions: _transactions, onRemove: (string) async => _removeTransaction),
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
  }

  final _transactions = [
    TransactionModel(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TransactionModel(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.30,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<TransactionModel> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = TransactionModel(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (value) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  Widget _getIconButtom(
    IconData icon,
    Function functionn,
  ) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () => functionn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: () => functionn,
            icon: Icon(icon),
          );
  }
}
