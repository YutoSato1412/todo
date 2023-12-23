//ListviewではなくTableで作成しようとした記録
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    List<String> list = ['　', '月', '火', '水', '木', '金', '土'];

    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('時間割'),
          backgroundColor: Colors.cyan,
        ),
        body: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          headingRowHeight: 40,
          border: TableBorder.all(color: Colors.black12),
          horizontalMargin: 0,
          columnSpacing: 0,
          columns: List.generate(
              list.length,
              (index) => DataColumn(
                      label: Container(
                    alignment: Alignment.center,
                    width: deviceWidth / 7,
                    child: Text(list[index]),
                  ))),
          rows: const <DataRow>[
            DataRow(cells: <DataCell>[
              DataCell(Text('test')),
              DataCell(Text('test')),
              DataCell(Text('test')),
              DataCell(Text('test')),
              DataCell(Text('test')),
              DataCell(Text('test'))
            ])
          ],
        ),
      );
    });
  }
}
