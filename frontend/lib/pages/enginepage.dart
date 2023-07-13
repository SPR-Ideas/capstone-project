
import 'package:flutter/material.dart';
import 'package:frontend/utils/constant.dart';
import 'package:frontend/widgets/nextOver.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/rest.dart';
import '../models/inventoryModels.dart';
import '../widgets/FreshInning.dart';
import '../widgets/Snackbar.dart';
import '../widgets/fallofWickte.dart';
import '../widgets/resultdecaration.dart';

String GetTeamName(HostTeamInnings innings,ScoreCard scorecard){
    return scorecard.hostTeamId == innings.id? scorecard.hostTeamName:scorecard.visitorTeamName;
}

Future<void> DeclareResult(HostTeamInnings currentInning,HostTeamInnings otherInning,ScoreCard scorecard)async{
    print("Called");
    // Current Inning Second Batting Other Innings First Batting.
    String Content = "";
    HostTeamInnings victoryTeamInnings = (currentInning.score>otherInning.score)?currentInning:otherInning;
    if(victoryTeamInnings.id== currentInning.id){
        Content = "${GetTeamName(victoryTeamInnings,scorecard)} won by ${(currentInning.battingStats!.length-1)-currentInning.wickets}";
    }
    else{
        Content = "${GetTeamName(victoryTeamInnings,scorecard)} won by ${(victoryTeamInnings.score - currentInning.score)}";
    }
    await Get.dialog(ResultDialog(content: Content,),transitionDuration: Duration(milliseconds: 500));
}

Future<int> makeServercall(CricketController controller)async{
    var response = await makeGetRequest("/ScoreCard/GetScoreCard?Id=${controller.scorecard.value.id}");
    if (response!=null){
        controller.updateScoreCard(
            ScoreCard.fromJson(response!.data ));
    }
    return 0;
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
            RxInt state,Rx<HostTeamInnings> otherInnings,RxInt
            strikerID
            )async
    {
    print("get Current players called");
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
        strikerID.value = striker.value.id;
        // state.value += state.value;
        // GetCurrentPlayers(innings, striker, nonStriker, blower,state,otherInnings);

    }
    else{
        List<BattingStats> batsmen = innings.value.battingStats!.where((e)=>e.isCurrent==1).toList();
        striker.value =  BattingStats();
        striker.value = (strikerID.value==0)?batsmen.first:batsmen.firstWhere((e)=>e.id==strikerID.value);
        nonStriker.value = BattingStats();
        nonStriker.value = (strikerID.value==0)?batsmen.last:batsmen.firstWhere((e)=>e.id!=strikerID.value);
        blower.value = otherInnings.value.blowingStats!.firstWhere((e)=>e.isCurrent==1);
    }
    return <int>[];
}

class CricketController extends GetxController {
    RxInt stateChange = 0.obs;
    RxInt StrikerId = 0.obs;

    late Rx<ScoreCard> scorecard  =ScoreCard().obs;
    late Rx<HostTeamInnings> currentInnings = HostTeamInnings().obs;
    late Rx<HostTeamInnings> otherInnings = HostTeamInnings().obs;

    late Rx<BattingStats> striker = BattingStats().obs;
    late Rx<BattingStats> nonStriker = BattingStats().obs;
    late Rx<BlowingStats> blower = BlowingStats().obs;

    void swapBatsmen({bool isfirst=false}) {
        StrikerId.value = nonStriker.value.id;
        if(!isfirst)
        GetCurrentPlayers(currentInnings,striker,nonStriker,blower,stateChange,otherInnings,StrikerId);
    }

    void updateScoreCard( ScoreCard scoreCard) async{
        scorecard.value = scoreCard;
        var list =  GetCurrentInnings(scoreCard);
        currentInnings.value = list[0];
        otherInnings.value = list[1];

        if((currentInnings.value.balls)%6==0 && currentInnings.value.balls!=0&& stateChange.value==0){
            Rx<BlowingStats> newBl = BlowingStats().obs;
            if(currentInnings.value.balls/6< currentInnings.value.totalOver){
                await Get.dialog( NextOver(
                // currentBlowerList: currentBlowerList,
                newBlowerList: otherInnings.value.blowingStats!.where((element) => element.isCurrent==0).toList(),
                // currentBl_: currentBl_,
                newBl_: newBl));

                var response = await makePutRequest("/ScoreCard/changeBlower", {
                "inningsId":otherInnings.value.id,
                "currentBlowerId": blower.value.id,
                "newBlowerId": newBl.value.id,
                });

            stateChange.value = 1;
            await makeServercall(this);

            }

        }
        stateChange.value=0;
        GetCurrentPlayers(currentInnings,striker,nonStriker,blower,stateChange,otherInnings,StrikerId);
        if(
                currentInnings.value.isInningsCompleted&&
                otherInnings.value.isInningsCompleted
                )
                {
                    DeclareResult(
                        currentInnings.value,
                        otherInnings.value,
                        scorecard.value
                        );
                }


        }
  // RxInt inningsScore = 0.obs;
  // RxInt wickets = 0.obs;
  // RxInt overs = 0.obs;
  // RxDouble runRate = 0.0.obs;
  RxBool isWide = false.obs;
  RxBool isNoBall = false.obs;
  RxBool isByes = false.obs;
  RxBool isWicket = false.obs;

  void clearOptions(){
    isWide.value = false;
    isByes.value = false;
    isNoBall.value = false;
    isWicket.value = false;
  }

  String getOptions(){
    if(isWide.value)return "WD";
    else if(isNoBall.value)return "NB";
    else if(isByes.value)return "B";
    else if(isWicket.value)return "WK";
    else return "";
  }

    void addRuns(int runs)async{
        var options = getOptions();
        clearOptions();

        if(options=="WK" && currentInnings.value.wickets+1 < currentInnings.value.battingStats!.length-1 ){

            Rx<BattingStats> current = BattingStats().obs;
            Rx<BattingStats> newBt_ = BattingStats().obs;
            await Get.dialog(fallofWicket(
                currentBatsmenList: currentInnings.value.battingStats!.where((e)=>e.isCurrent==1).toList(),
                newBatsmenList: currentInnings.value.battingStats!.where((e)=>e.isCurrent==0).toList(),
                currentBt_: current,
                newBt_: newBt_,
                ));
                StrikerId.value = newBt_.value.id;

        var response = await makePutRequest("/ScoreCard/changeBatsman", {
                "inningsId":currentInnings.value.id,
                "currentBatsmen": current.value.id,
                "newBatsmen": newBt_.value.id
                });

            print(response!.data);


        }

        var response = await makePutRequest("/ScoreCard/UpdateEachBall",{
            "scoreCardID":scorecard.value.id,
            "runs": runs,
            "batsmanId": striker.value.userId,
            "blowerId" : blower.value.userId,
            "blowerName": blower.value.displayNames,
            "options": options
        });


        if(response!.data["status"]==true){
            makeServercall(this);
        }
        if(runs%2!=0){
            print("swap Called");
            swapBatsmen(isfirst: true);
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

            // checks for result declaration


        return Scaffold(
        appBar:  AppBar(
            title: Obx (() => Text("${cricketController.scorecard.value.hostTeamName} Vs ${cricketController.scorecard.value.visitorTeamName}")),
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
                                    (cricketController.currentInnings.value.score/(cricketController.currentInnings.value.balls/6)).toStringAsFixed(2)}'
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
                                    SizedBox(width:10),
                                ],
                            )

                        ],
                        ),

                        Divider(thickness: 2), //Striker
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Obx(() => Container(
                                    width: 100,
                                    child:Text(
                                        cricketController.striker.value.displayName,
                                        overflow: TextOverflow.ellipsis,
                                        )
                                    )) ,
                            // SizedBox(width: 40,),
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
                                    Obx(() =>  Text("${(((cricketController.striker.value.runs)/(cricketController.striker.value.balls))*100).toStringAsFixed(1)}")), // Sr
                                    // SizedBox(width:15),
                                ]
                            )
                        ],),
                        SizedBox(height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Obx(() => Container(
                                    width: 100,
                                    child:  Text(
                                        cricketController.nonStriker.value.displayName,
                                        overflow:  TextOverflow.ellipsis,
                                        )) ),
                            // SizedBox(width: 40,),
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
                                     Obx(() =>  Text("${(((cricketController.nonStriker.value.runs)/(cricketController.nonStriker.value.balls))*100).toStringAsFixed(1)}")), // Sr
                                    // SizedBox(width:15),
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
                                    Obx(()=>Text( (cricketController.blower.value.runs/ cricketController.blower.value.ballsBlowed).toStringAsFixed(2))),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Row(children: [
                                    Obx(() => Checkbox(
                                value: cricketController.isWicket.value,
                                onChanged: cricketController.toggleWicket,
                                )),
                                Text('Wicket'),
                                ]),


                             Obx(() {
                                bool flag = cricketController.currentInnings.value.isInningsCompleted && cricketController.otherInnings.value.isInningsCompleted;
                                return ElevatedButton(

                             style: ButtonStyle(backgroundColor: (flag)?MaterialStatePropertyAll(Colors.grey.shade400):MaterialStatePropertyAll(primaryColor)),
                             onPressed: (flag)?null: cricketController.swapBatsmen,
                             child: Text("Swap Batsmen"),);})
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