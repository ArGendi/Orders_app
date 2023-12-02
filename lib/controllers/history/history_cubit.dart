import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/history/history_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/models/history.dart';
import 'package:notes/models/order.dart';

class HistoryCubit extends Cubit<HistoryState>{
  List<History> ordersDone = [];

  HistoryCubit() : super(InitHistoryState());

  void getHistory(){
    Box historyBox = Hive.box(historyTable);
    ordersDone = historyBox.keys.toList().map((key){
        Map map = historyBox.get(key);
        print(map);
        History order = History.fromMap(map);
        return order;
      }
    ).toList().reversed.toList();
    emit(GetHistoryState());
  }

}