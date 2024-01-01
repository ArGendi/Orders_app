// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/models/order.dart';
import 'package:notes/widgets/custom_button.dart';
import 'package:notes/widgets/custom_texfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateOrderScreen extends StatefulWidget {
  final int index;
  const UpdateOrderScreen({super.key, required this.index});

  @override
  State<UpdateOrderScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<UpdateOrderScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrderCubit>(context).order = BlocProvider.of<OrderCubit>(context).orders[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editOrder),
        //centerTitle: true,
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: BlocProvider.of<OrderCubit>(context).formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<OrderCubit>(context)
                        .imageBottomSheet(context);
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
                    child: BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        return Center(
                          child: BlocProvider.of<OrderCubit>(context)
                                      .order
                                      .image !=
                                  null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                    BlocProvider.of<OrderCubit>(context)
                                        .order
                                        .image!,  
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                  ),
                              )
                              : Icon(
                                  Icons.photo,
                                  size: 30,
                                ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.name,
                  text: AppLocalizations.of(context)!.name,
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context).order.client!.name =
                        value!.trim();
                  },
                  onValidate: (value) {
                    return BlocProvider.of<OrderCubit>(context)
                        .validation(value, AppLocalizations.of(context)!.enterName);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.armTall,
                        text: AppLocalizations.of(context)!.armTall,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .armTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterArmTall);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.waistTall,
                        text: AppLocalizations.of(context)!.waistTall,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .waistTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterWaistTall);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.jeepTall,
                        text: AppLocalizations.of(context)!.jeepTall,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .jeepTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterJeepTall);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.chestRound,
                        text: AppLocalizations.of(context)!.chestRotation,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .chestRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterChestRotation);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.waistRound,
                        text: AppLocalizations.of(context)!.waistRotation,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .waistRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterWaistRotation);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.sidesRound,
                        text: AppLocalizations.of(context)!.sidesRotation,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .sidesRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, AppLocalizations.of(context)!.enterSidesRotation);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].client!.shouldersTall,
                  text: AppLocalizations.of(context)!.shouldersWidth,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context)
                        .order
                        .client!
                        .shouldersTall = value;
                  },
                  onValidate: (value) {
                    return BlocProvider.of<OrderCubit>(context)
                        .validation(value, AppLocalizations.of(context)!.enterShouldersWidth);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () async {
                     BlocProvider.of<OrderCubit>(context).selectDeadlineDate(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return Text(
                              BlocProvider.of<OrderCubit>(context)
                                  .getFilteredDeadline(context), // تاريخ التسليم
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  initial: BlocProvider.of<OrderCubit>(context).orders[widget.index].comment,
                  text: AppLocalizations.of(context)!.additionalComment,
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context).order.comment = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: AppLocalizations.of(context)!.editOrder, 
                  onClick: () async {
                      bool valid = await BlocProvider.of<OrderCubit>(context)
                          .onUpdateOrder(context, widget.index);
                      if (valid) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar( SnackBar(
                          content: Text(AppLocalizations.of(context)!.editDone),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.popUntil(context, (route) => false);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar( SnackBar(
                          content: Text(AppLocalizations.of(context)!.problemExist),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
