import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/history/history_cubit.dart';
import 'package:notes/controllers/history/history_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HistoryCubit>(context).getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.previousOrders),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            var cubit = BlocProvider.of<HistoryCubit>(context);
            return Visibility(
              visible: cubit.ordersDone.isNotEmpty,
              replacement: Center(
                  child: Image.asset(
                    'images/empty.png',
                    width: 200,
                  ),
                ),
              child: ListView.separated(
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cubit.ordersDone[i].name!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${cubit.ordersDone[i].createdAt!.day} / ${cubit.ordersDone[i].createdAt!.month} / ${cubit.ordersDone[i].createdAt!.year}",
                            style: TextStyle(
                              color: Colors.green[800],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded),
                          Text(
                            "${cubit.ordersDone[i].deadline!.day} / ${cubit.ordersDone[i].deadline!.month} / ${cubit.ordersDone[i].deadline!.year}",
                            style: TextStyle(
                              color: Colors.red[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, i) {
                  return const Divider(
                    height: 20,
                  );
                },
                itemCount: cubit.ordersDone.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
