class History{
  String? name;
  DateTime? createdAt;
  DateTime? deadline;

  History({this.name, this.createdAt, this.deadline});

  History.fromMap(Map map){
    name = map['name'];
    deadline = DateTime.fromMillisecondsSinceEpoch(map['deadline']);
    createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
  }

   Map<String, dynamic> toMap(){
    return {
      'name': name,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }
}