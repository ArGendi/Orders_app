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

class AddNoteScreen extends StatefulWidget {
  final Client? client;
  const AddNoteScreen({super.key, this.client});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.newOrder,
        ),
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
                  initial: widget.client != null ? widget.client!.name : null,
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
                        initial: widget.client != null
                            ? widget.client!.armTall
                            : null,
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
                        initial: widget.client != null
                            ? widget.client!.waistTall
                            : null,
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
                        initial: widget.client != null
                            ? widget.client!.jeepTall
                            : null,
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
                        initial: widget.client != null
                            ? widget.client!.chestRound
                            : null,
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
                        initial: widget.client != null
                            ? widget.client!.waistRound
                            : null,
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
                        initial: widget.client != null
                            ? widget.client!.sidesRound
                            : null,
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
                  initial: widget.client != null
                      ? widget.client!.shouldersTall
                      : null,
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
                      BlocProvider.of<OrderCubit>(context)
                          .selectDeadlineDate(context);
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
                  text: AppLocalizations.of(context)!.additionalComment,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context).order.comment = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    if (state is LoadingUploadOrderState) {
                      return const Center(child: CircularProgressIndicator(color: Colors.black,),);
                    }
                    else{
                      return CustomButton(
                        text: AppLocalizations.of(context)!.add,
                        onClick: () async {
                          OrderStatus status =
                              await BlocProvider.of<OrderCubit>(context)
                                  .onConfirmOrder(context, widget.client);
                          if (status == OrderStatus.success) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar( SnackBar(
                              content: Text(AppLocalizations.of(context)!.addedSuccessfuly),
                              backgroundColor: Colors.green,
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)!.enterDeadline),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                      );
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
