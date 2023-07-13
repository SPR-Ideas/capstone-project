    import 'package:flutter/material.dart';
import 'package:frontend/utils/constant.dart';

    import '../models/inventoryModels.dart';

    class ScorePage extends StatelessWidget {
    final ScoreCard scoreCard;

    ScorePage({required this.scoreCard});

    @override
    Widget build(BuildContext context) {
        return DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
            appBar: AppBar(
            title: Text('${(scoreCard.hostTeamName)}Vs ${(scoreCard.visitorTeamName)}'),
            backgroundColor: primaryColor,
            bottom: TabBar(
                tabs: [
                Tab(text: '${(scoreCard.hostTeamName)}'),
                Tab(text: '${(scoreCard.visitorTeamName)}'),
                ],
            ),
            ),
            body: TabBarView(
            children: [
                _buildInningsTab(scoreCard.hostTeamInnings,scoreCard.visitorTeamInnings),
                _buildInningsTab(scoreCard.visitorTeamInnings,scoreCard.hostTeamInnings),
            ],
            ),
        ),
        );
    }

    Widget _buildInningsTab(HostTeamInnings? innings,HostTeamInnings? otherInnings) {
  if (innings == null) {
    return Center(child: Text('No innings data available'));
  }

  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Batting Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("R")),
              DataColumn(label: Text("B")),
              DataColumn(label: Text("4")),
              DataColumn(label: Text("6")),
              DataColumn(label: Text("SR")),
            ],
            rows: innings.battingStats!.map((battingStats) {
              return DataRow(cells: [
                DataCell(Text(battingStats.displayName)),
                DataCell(Text(battingStats.runs.toString())),
                DataCell(Text(battingStats.balls.toString())),
                DataCell(Text(battingStats.four.toString())),
                DataCell(Text(battingStats.sixer.toString())),
                DataCell(Text("${((battingStats.runs / battingStats.balls) * 100).toStringAsFixed(1)}")),
              ]);
            }).toList(),
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Text("Extras : ${innings.score -(innings.battingStats!.map((e)=>e.runs).toList().fold(0, (p, e) => p + e)) }"),
                SizedBox(width: 20),
                Text("Total  : ${innings.score}"),
                SizedBox(width: 40),
            ],
          ),
            SizedBox(height: 20),

          Text(
            'Bowling Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("O")),
              DataColumn(label: Text("W")),
              DataColumn(label: Text("R")),
              DataColumn(label: Text("Eco")),
            ],
            rows: otherInnings!.blowingStats!.where((e)=>e.ballsBlowed>0)!.map((blowingStats) {
              return DataRow(cells: [
                DataCell(Text(blowingStats.displayNames)),
                DataCell(Text((blowingStats.ballsBlowed/6).toInt().toString()+"."+(blowingStats.ballsBlowed%6).toString())),
                DataCell(Text(blowingStats.wickets.toString())),
                DataCell(Text(blowingStats.runs.toString())),
                DataCell(Text( (blowingStats.runs/ (blowingStats.ballsBlowed/6)).toStringAsFixed(2))),
              ]);
            }).toList(),
          ),
        ],
      ),
    ),
  );
}



}