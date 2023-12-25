import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/models/order.dart';
import 'package:notes/screens/update_order_screen.dart';
import 'package:notes/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int index;
  final Order order;
  const OrderDetailsScreen({super.key, required this.index, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BlocProvider.of<OrderCubit>(context)
            .orders[index]
            .client!
            .name
            .toString()),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateOrderScreen(index: index)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        if(order.image != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              //barrierDismissible: false,
                              context: context, builder: (context){
                              return Center(
                                child: Stack(
                                  children: [
                                    Image.file(order.image!),
                                    Positioned(
                                      child: IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                      order
                                      .image!,  
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                ),
                            )
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                 AppLocalizations.of(context)!.armTall,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  order.client!
                                      .armTall
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.waistTall,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  order.client!
                                      .waistTall
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 30,
                          color: Colors.grey[200],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                   AppLocalizations.of(context)!.jeepTall,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  order.client!
                                      .jeepTall
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                   AppLocalizations.of(context)!.chestRotation,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      order.client!
                                          .chestRound
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "(${(int.parse(order.client!.chestRound!) / 4).toStringAsFixed(2)})",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600]
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 30,
                          color: Colors.grey[200],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                   AppLocalizations.of(context)!.waistRotation,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      order.client!
                                          .waistRound
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "(${(int.parse(order.client!.waistRound!) / 4).toStringAsFixed(2)})",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600]
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                   AppLocalizations.of(context)!.sidesRotation,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      order.client!
                                          .sidesRound
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "(${(int.parse(order.client!.sidesRound!) / 4).toStringAsFixed(2)})",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600]
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 30,
                          color: Colors.grey[200],
                        ),
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.shouldersWidth,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              order.client!
                                  .shouldersTall
                                  .toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        if (order
                            .comment!
                            .isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Expanded(child: Divider(endIndent:  15, color: Colors.green[400]),),
                                  Text(
                                     AppLocalizations.of(context)!.additionalComment,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontSize: 18,
                                      color: Colors.green[700]
                                    ),
                                  ),
                                  Expanded(child: Divider(indent:  15, color: Colors.green[400])),
                                ],
                              ),
                              Text(
                                order
                                    .comment
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              
                            ],
                          ),
                          Divider(
                                height: 30,
                                color: Colors.grey[200],
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${order.createdAt!.day} / ${order.createdAt!.month} / ${order.createdAt!.year}",
                              style: TextStyle(
                                  //fontSize: 18,
                                  color: Colors.green[700]),
                            ),
                            Icon(Icons.arrow_forward_rounded),
                            Text(
                              "${order.deadline!.day} / ${order.deadline!.month} / ${order.deadline!.year}",
                              style: TextStyle(
                                  //fontSize: 18,
                                  color: Colors.red[700]),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: AppLocalizations.of(context)!.orderDelivered,
              onClick: () async{
                await BlocProvider.of<OrderCubit>(context, listen: false).showDoneDialog(context, index);
              },
              bgColor: Colors.green[900],
            ),
          ],
        ),
      ),
    );
  }
}
