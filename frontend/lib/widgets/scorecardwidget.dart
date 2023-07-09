import 'package:flutter/material.dart';
import 'package:frontend/widgets/NamewithPhoto.dart';

class ScoreCardPanel extends StatelessWidget {
  final String teamAName;
  final String teamBName;
  final int teamAScore;
  final int teamBScore;
  final int teamAWickets;
  final int teamBWickets;
  final String result;
  final Function? onpress;

  ScoreCardPanel({
    required this.teamAName,
    required this.teamBName,
    required this.teamAScore,
    required this.teamBScore,
    required this.teamAWickets,
    required this.teamBWickets,
    required this.result,
    this.onpress
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$teamAName VS $teamBName',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          _buildScoreRow(teamAName, teamAScore, teamAWickets),
          SizedBox(height: 10.0),
          _buildScoreRow(teamBName, teamBScore, teamBWickets),
          SizedBox(height: 15.0),
          Text(
            ' $result',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: (){onpress!();},
            child: Container(
                child: const Padding(padding: EdgeInsets.all(10),
                child: Center( child: Text(
                    " View Result" ,
                    style:TextStyle(fontSize: 15,fontWeight:FontWeight.w500),
                    ) ,
                ))
                ,)

        )
        ],
      ),
    );
  }

  Widget _buildScoreRow(String teamName, int score, int wickets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            children: [
                NameWithPhoto(name: teamName,size: 40),
                SizedBox(width: 10,),
                Text(
                teamName,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                ),
                ),
            ],
        ),

        Row(
            children: [
                Text(
                '$score/$wickets ',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 10,),
                Text(
                ' 0.0 ',
                style: TextStyle(fontSize: 14.0,color: Colors.grey, fontWeight: FontWeight.bold),
                ),
            ],
        )

      ],
    );
  }
}
