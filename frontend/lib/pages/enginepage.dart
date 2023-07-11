
import 'package:flutter/material.dart';
import 'package:frontend/utils/constant.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/rest.dart';
import '../models/inventoryModels.dart';
import '../widgets/FreshInning.dart';
import '../widgets/Snackbar.dart';
import '../widgets/fallofWickte.dart';

void makeServercall(CricketController controller)async{
    var response = await makeGetRequest("/ScoreCard/GetScoreCard?Id=${controller.scorecard.value.id}");
    if (response!=null){
        controller.updateScoreCard(
            ScoreCard.fromJson(response!.data ));
    }
}

List<HostTeamInnings> GetCurrentInnings(ScoreCard scoreCard){
    if(!scoreCard.hostTeamInnings!.isInningsCompleted && !scoreCard.visitorTeamInnings!.isInningsCompleted ){
        if(scoreCard.isHostInnings) return [scoreCard.hostTeamInnings!,scoreCard.visitorTeamInnings!];
        else return[ scoreCard.visitorTeamInnings! ,scoreCard.hostTeamInnings!];
    }
    else {
        if(scoreCard.hostTeamInnings!.isInningsCompleted) return [scoreCard.visitorTeamInnings!,scoreCard.hostTeamInnings!];
        if(scoreCard.visitorTeamInnings!.isInningsCompleted) return [scoreCard.hostTeamInnings!,scoreCard.visitorTeamInnings!];
    }
    return [HostTeamInnings(),];
}

bool isFreshInnings(HostTeamInnings innings) {
    return innings.battingStats!.every((battingStat) => battingStat.isCurrent == 0);
}

Future<List<int>> GetCurrentPlayers(
            Rx<HostTeamInnings> innings,Rx<BattingStats> striker ,
            Rx<BattingStats> nonStriker,Rx<BlowingStats> blower,
            RxInt state,Rx<HostTeamInnings> otherInnings
            )async
    {
    if(isFreshInnings(innings.value)){
        await Get.dialog(
            PlayerSelectionDialog(
                batsmenList_: innings.value.battingStats!.where((element) => element.isCurrent==0).toList(),
                blowingList_: otherInnings.value.blowingStats!.where((element) => element.isCurrent==0).toList(),
                blower_:blower ,
                striker_: striker,
                nonStriker_: nonStriker,
            ));
        await makePutRequest("/ScoreCard/freshInnings",{
            "inningsId" :innings.value.id,
            "strikerId" : striker.value.id,
            "nonStrikerId":nonStriker.value.id,
            "blowerId": blower.value.id,
        });
        // state.value += state.value;
        // GetCurrentPlayers(innings, striker, nonStriker, blower,state,otherInnings);

    }
    else{
        List<BattingStats> batsmen = innings.value.battingStats!.where((e)=>e.isCurrent==1).toList();
        striker.value =  BattingStats();
        striker.value = batsmen.first;
        nonStriker.value = BattingStats();
        nonStriker.value = batsmen.last;
        blower.value = otherInnings.value.blowingStats!.firstWhere((e)=>e.isCurrent==1);
    }
    return <int>[];
}

class CricketController extends GetxController {
    RxInt stateChange = 0.obs;

    late Rx<ScoreCard> scorecard  =ScoreCard().obs;
    late Rx<HostTeamInnings> currentInnings = HostTeamInnings().obs;
    late Rx<HostTeamInnings> otherInnings = HostTeamInnings().obs;

    late Rx<BattingStats> striker = BattingStats().obs;
    late Rx<BattingStats> nonStriker = BattingStats().obs;
    late Rx<BlowingStats> blower = BlowingStats().obs;

    void updateScoreCard( ScoreCard scoreCard){
        scorecard.value = scoreCard;
        var list =  GetCurrentInnings(scoreCard);
        currentInnings.value = list[0];
        otherInnings.value = list[1];

        GetCurrentPlayers(currentInnings,striker,nonStriker,blower,stateChange,otherInnings);
        }
  // RxInt inningsScore = 0.obs;
  // RxInt wickets = 0.obs;
  // RxInt overs = 0.obs;
  // RxDouble runRate = 0.0.obs;
  RxBool isWide = false.obs;
  RxBool isNoBall = false.obs;
  RxBool isByes = false.obs;
  RxBool isWicket = false.obs;

  String getOptions(){
    if(isWide.value)return "WD";
    else if(isNoBall.value)return "NB";
    else if(isByes.value)return "B";
    else if(isWicket.value)return "WK";
    else return "";
  }

    void addRuns(int runs)async{
        var response = await makePutRequest("/ScoreCard/UpdateEachBall",{
            "scoreCardID":scorecard.value.id,
            "runs": runs,
            "batsmanId": striker.value.userId,
            "blowerId" : blower.value.userId,
            "blowerName": blower.value.displayNames,
            "options":getOptions()
        });
        if(response!.data["status"]==true){
            makeServercall(this);
        }
    }
  void toggleWide(bool? value) {
    isWide.value = value?? isWide.value;
  }

  void toggleNoBall(bool? value) {
    isNoBall.value = value?? isNoBall.value;
  }

  void toggleByes(bool? value) {
    isByes.value = value?? isByes.value;
  }

  void toggleWicket(bool? value) {
    isWicket.value = value?? isWicket.value;
  }
}

class CricketCounterPage extends HookWidget {
    final CricketController cricketController = Get.put(CricketController());
    final int ScoreCardId;
    CricketCounterPage({required this.ScoreCardId});



    @override
    Widget build(BuildContext context) {

        useEffect((){
            var response = makeGetRequest("/ScoreCard/GetScoreCard?Id=$ScoreCardId")
            .then((value) =>  {
                if(value!=null){
                    cricketController.updateScoreCard(
                        ScoreCard.fromJson( value.data),
                    ),
                }
                else{
                    Snackbar("Server Not Resonding","",Colors.red.shade300)
                }
                },);
            return null;
            },[]);

        return Scaffold(
        appBar:  AppBar(
            title: const Text("Gully Cricket"),
            centerTitle: true,
            backgroundColor: primaryColor,

            ),
        body: SingleChildScrollView(child:  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Obx(()=> Text(
                        (cricketController.scorecard.value.hostTeamInnings!.id==
                        cricketController.currentInnings.value.id)?
                        cricketController.scorecard.value.hostTeamName:
                        cricketController.scorecard.value.visitorTeamName,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                        ),
                        )),
                        SizedBox(height: 8.0),
                        Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                            children: [
                            Row(children: [
                                Obx(() => Text('${cricketController.currentInnings.value.score} - ${cricketController.currentInnings.value.wickets}',
                                style: TextStyle(fontSize: 28,fontWeight: FontWeight.w600),
                            )),
                            SizedBox( width: 10,),
                            Obx(() =>
                                Text(
                                    '${(cricketController.currentInnings.value.balls/6).toInt()}.${(cricketController.currentInnings.value.balls%6)}',
                                    style: TextStyle(fontSize: 20 ,color: Colors.grey),
                                    )),

                            ],),
                            Obx(() => Text(' CR : ${
                                    (cricketController.currentInnings.value.score/(cricketController.currentInnings.value.balls/6))}'
                                )),
                        ],)

                    ],
                    ),
                ),
                ),
                SizedBox(height: 8.0),
                Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                            Text(
                                'Batsmen',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                ),
                                textAlign: TextAlign.left,
                                ),
                            Row(

                                children: [
                                    Text("R",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("B",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("4",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("6",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 40,),
                                    Text("SR",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                ],
                            )

                        ],
                        ),

                        Divider(thickness: 2), //Striker
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Obx(() => Text(cricketController.striker.value.displayName)) ,
                            SizedBox(width: 40,),
                            Row(

                                children: [
                                   Obx(() => Text(cricketController.striker.value.runs.toString())),  // Runs
                                    SizedBox(width: 35,),
                                    Obx(() => Text(cricketController.striker.value.balls.toString())) ,                                   SizedBox(width: 28,),
                                    SizedBox(width: 10,),
                                    Obx(() => Text(cricketController.striker.value.four.toString())),
                                    SizedBox(width: 33,),
                                    Obx(() => Text(cricketController.striker.value.sixer.toString())), // 6s
                                    SizedBox(width:30),
                                    Obx(() => Text("${((cricketController.striker.value.runs)/(cricketController.striker.value.balls)).toStringAsFixed(2)}")), // Sr
                                ]
                            )
                        ],),
                        SizedBox(height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Obx(() => Text(cricketController.nonStriker.value.displayName)) ,
                            SizedBox(width: 40,),
                            Row(
                                children: [
                                   Obx(() => Text(cricketController.nonStriker.value.runs.toString())),  // Runs
                                    SizedBox(width: 35,),
                                    Obx(() => Text(cricketController.nonStriker.value.balls.toString())) ,                                   SizedBox(width: 28,),
                                    SizedBox(width: 10,),
                                    Obx(() => Text(cricketController.nonStriker.value.four.toString())),
                                    SizedBox(width: 33,),
                                    Obx(() => Text(cricketController.nonStriker.value.sixer.toString())), // 6s
                                    SizedBox(width:30,),
                                    Obx(() => Text("${(cricketController.nonStriker.value.runs)/(cricketController.striker.value.balls)}")), // Sr
                                ]
                            )
                        ],),

                        SizedBox(height: 15,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                            Text(
                                'Blower',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                ),
                                textAlign: TextAlign.left,
                                ),
                            Row(

                                children: [
                                    Text("O",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("R",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("W",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                    SizedBox(width: 35,),
                                    Text("ER",style: TextStyle(fontWeight: FontWeight.w500,color:Colors.black54),),
                                ],
                            )



                        ],
                        ),
                        Divider(thickness: 2),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                            Obx(() => Text(cricketController.blower.value.displayNames)) ,
                            Row(
                                children: [
                                    Obx(()=>Text(
                                        "${((cricketController.blower.value.ballsBlowed)/6).toInt()}.${(
                                            cricketController.blower.value.ballsBlowed%6
                                        )}")),
                                    SizedBox(width: 35,),
                                    Obx(()=>Text(cricketController.blower.value.runs.toString())),
                                    SizedBox(width: 35,),
                                    Obx(()=>Text(cricketController.blower.value.wickets.toString())),
                                    SizedBox(width: 35,),
                                    Obx(()=>Text( (cricketController.blower.value.runs/ cricketController.blower.value.ballsBlowed).toDouble().toString())),
                                ],
                            )

                        ],
                        ),


                    ],
                    ),
                ),
                ),
                SizedBox(height:8.0),
                Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                        'Add Runs',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                        ),
                        ),
                        SizedBox(height: 8.0),
                        Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List.generate(
                            7,
                            (index) => Obx(() =>  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: CircleBorder(),
                                fixedSize: Size(50, 50)
                            ),
                            onPressed: (cricketController.currentInnings.value.isInningsCompleted&&cricketController.otherInnings.value.isInningsCompleted) ?null:(){
                                cricketController.addRuns(index)
                                ;},
                            child: Text('$index'),
                            )),
                        ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                        'Extras',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                        ),
                        ),
                        SizedBox(height: 8.0),

                        Row(
                        children: [
                            Row(children: [
                                Obx(() => Checkbox(
                            value: cricketController.isWide.value,
                            onChanged: cricketController.toggleWide,
                            )),
                            Text('Wide'),
                            ],),
                            Row(children: [
                                Obx(() => Checkbox(
                            value: cricketController.isNoBall.value,
                            onChanged: cricketController.toggleNoBall,
                            )),
                            Text('No Ball'),
                            ],),

                            Row(
                                children: [
                                    Obx(() => Checkbox(
                            value: cricketController.isByes.value,
                            onChanged: cricketController.toggleByes,
                            )),
                            Text('Byes'),
                                ],
                            ),
                        ],
                        ),
                        Row(
                                children: [
                                    Obx(() => Checkbox(
                            value: cricketController.isWicket.value,
                            onChanged: cricketController.toggleWicket,
                            )),
                            Text('Wicket'),
                                ],
                            )
                    ],
                    ),
                ),
                ),
            ],
            ),
        )),
        );
    }
}