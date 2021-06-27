import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uiprojectone/budget_repository.dart';
import 'package:uiprojectone/failure_model.dart';
import 'package:uiprojectone/spending_chart.dart';
import 'item_model.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  await dotenv.load(fileName:'.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notion Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: BugetScreen(),
    );
  }
}

class BugetScreen extends StatefulWidget {

  @override
  _BugetScreenState createState() => _BugetScreenState();
}

class _BugetScreenState extends State<BugetScreen> {
late Future<List<Item>> _futureItems;

  var DateFormat;

@override
void initState() {
  super.initState();
  _futureItems = BudgetRepository().getItems();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: FutureBuilder<List<Item>>
      (
        future: _futureItems,
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
          {  
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length+1,
              itemBuilder: (BuildContext context,int index)
              {
                if(index==0) return SpendingChart(items: items);
                final item = items[index-1];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 2.0,
                      color:getCategoryColor(item.category),
                    ),
                    boxShadow: const[
                      BoxShadow(
                        color:Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0
                      )
                    ]
                  ),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.category} a ${(item.date)}'),
                       trailing: Text(
                        '-\$${item.price.toStringAsFixed(2)}',
                      ),
                  ),
                  
                );
              },
            );

          }else if(snapshot.hasError){
             final failure = snapshot.error as Failure;
             return Center(child: Text(failure.message));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Color getCategoryColor(String category)
{
  switch (category)
  {
    case 'Entertainment':
    return Colors.red[400]!;
    case 'food':
    return Colors.green[400]!;
    case 'Persoanl':
    return Colors.blue[400]!;
    case 'Transpotation':
    return Colors.purple[400]!;
    default:
    return Colors.blue[400]!;
  }
}


 //subtitle: Text('${item.category} a ${DateFormat.Mdy().format(item.date)}'),