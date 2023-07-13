

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/rest.dart';
import 'package:frontend/pages/enginepage.dart';
import 'package:frontend/utils/constant.dart';
import 'package:get/get.dart';

import '../models/inventoryModels.dart';
import '../widgets/scorecardwidget.dart';

Widget  historyPage(Inventorymodel? inventory){
    return Center(
      child: (inventory==null)? Center(child: Text("No History found")): HistoryPage(inventorymodel: inventory,)
        );
}

class HistoryPageController  extends GetxController {
    RxList<Matches> matches = <Matches>[].obs;

    void updateAgain(Inventorymodel inventorymodel) {
        try{
        matches.value = inventorymodel.matches.reversed.toList();
        }catch(e){}
    }

    HistoryPageController( Inventorymodel inventorymodel){
        matches.value = inventorymodel!.matches;

    }

    List<dynamic> CreateScoreCard(Matches match){
        ScoreCard scoreCard = match.scoreCard;

        late String TeamAName;
        late String TeamBName;
        late HostTeamInnings? TeamA;
        late HostTeamInnings? TeamB;
        late String Result = "";

        if( scoreCard.isHostInnings && !scoreCard.visitorTeamInnings!.isInningsCompleted ){
            TeamA = scoreCard.hostTeamInnings;
            TeamAName = scoreCard.hostTeamName;
            TeamB = scoreCard.visitorTeamInnings;
            TeamBName = scoreCard.visitorTeamName;
        }

        if(!scoreCard.isHostInnings && scoreCard.hostTeamInnings!.isInningsCompleted ){
            TeamB = scoreCard.hostTeamInnings;
            TeamBName = scoreCard.hostTeamName;

            TeamA = scoreCard.visitorTeamInnings;
            TeamAName = scoreCard.visitorTeamName;
        }


        if(match.isCompleted){
            if(scoreCard.isHostInnings){

                TeamA = scoreCard.hostTeamInnings;
                TeamAName = scoreCard.hostTeamName;
                TeamB = scoreCard.visitorTeamInnings;
                TeamBName = scoreCard.visitorTeamName;
            }
            else{

                TeamB = scoreCard.hostTeamInnings;
                TeamBName = scoreCard.hostTeamName;
                TeamA = scoreCard!.visitorTeamInnings;
                TeamAName = scoreCard.visitorTeamName;

            }
        }

        if(!scoreCard.hostTeamInnings!.isInningsCompleted && !scoreCard.visitorTeamInnings!.isInningsCompleted){
            // If two Innings were not completed
            Result = " CRR :${TeamA!.score/TeamA.balls}";
        }
        if(scoreCard.hostTeamInnings!.isInningsCompleted || scoreCard.visitorTeamInnings!.isInningsCompleted){
            Result = "$TeamBName needs ${(TeamA!.score+1)-TeamB!.score} from ${(TeamB.totalOver*6) - TeamB.balls}";
        }
        if(match.isCompleted){
            Result = match.result;
        }
        return [TeamAName ,TeamBName, TeamA,TeamB,Result];

    }



}

class HistoryPage extends StatelessWidget{
    final Inventorymodel inventorymodel;
    late HistoryPageController  historyController;

    HistoryPage({required this.inventorymodel}){
        historyController = Get.put(HistoryPageController(inventorymodel));
    }

    @override
    Widget build(BuildContext context) {
        historyController.updateAgain(inventorymodel);
        return Scaffold(
            body: Column(
                children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(16,16,16,10),
                        child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text("History",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                            GestureDetector(
                                onTap: ()async{
                                    var response  = await makeGetRequest("/Inventory/GetInventory");
                                    if(response!=null) historyController.updateAgain(Inventorymodel.fromJson(response.data));
                                },
                                child: Icon(Icons.refresh,color: primaryColor,),
                                )

                        ],)),
                    Expanded(child:
                        Obx(() => ListView.builder(
                            itemCount:  historyController.matches.value.length,
                            itemBuilder: (context, index) {
                                // historyController.updateAgain(inventorymodel);
                                final Matches match = historyController.matches.value[index];
                                final List<dynamic> details = historyController.CreateScoreCard(match);
                                return Card(
                                    elevation: 2,
                                    margin: EdgeInsets.all(14),
                                    child: ScoreCardPanel(
                                    teamAName:  details[0],
                                    teamBName: details[1],
                                    teamAScore: details[2].score,
                                    teamAWickets: details[2].wickets,
                                    teamAballs: details[2].balls,
                                    teamBScore:  details[3].score,
                                    teamBWickets: details[3].wickets,
                                    teamBballs: details[3].balls,
                                    result : details[4],
                                    onpress:(){ Get.to( CricketCounterPage(ScoreCardId: match.scoreCard.id));},
                                )
                                );
                            },
                        ))
                    )
                ],
            ),
        );
  }
}



