
class Client{
  int? id;
  String? name;
  String? armTall;
  String? waistTall;
  String? jeepTall;
  String? chestRound;
  String? waistRound;
  String? sidesRound;
  String? shouldersTall;

  Client({this.id});
  Client.initialize(this.name, this.armTall, this.waistTall, this.jeepTall, this.chestRound,
   this.waistRound, this.sidesRound, this.shouldersTall);
  Client.fromMap(Map map){
    name = map['name'];
    armTall = map['armTall'];
    waistTall = map['waistTall'];
    jeepTall = map['jeepTall'];
    chestRound = map['chestRound'];
    waistRound = map['waistRound'];
    sidesRound = map['sidesRound'];
    shouldersTall = map['shouldersTall'];
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'armTall': armTall,
      'waistTall': waistTall,
      'jeepTall': jeepTall,
      'chestRound': chestRound,
      'waistRound': waistRound,
      'sidesRound': sidesRound,
      'shouldersTall': shouldersTall,
    };
  }
}