import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/models/order.dart';
import 'package:notes/widgets/custom_button.dart';
import 'package:notes/widgets/custom_texfield.dart';

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
        title: const Text(
          'أضافة جديد',
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
                  text: 'الأسم',
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context).order.client!.name =
                        value!.trim();
                  },
                  onValidate: (value) {
                    return BlocProvider.of<OrderCubit>(context)
                        .validation(value, "ادخل الأسم");
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
                        text: 'طول الكم',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .armTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل الكم");
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
                        text: 'طول الوسط',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .waistTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل الوسط");
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
                        text: 'طول الجيب',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .jeepTall = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل الجيب");
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
                        text: 'دوران الصدر',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .chestRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل دوران الصدر");
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
                        text: 'دوران الوسط',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .waistRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل دوران الوسط");
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
                        text: 'دوران الاجناب',
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          BlocProvider.of<OrderCubit>(context)
                              .order
                              .client!
                              .sidesRound = value;
                        },
                        onValidate: (value) {
                          return BlocProvider.of<OrderCubit>(context)
                              .validation(value, "ادخل دوران الاجناب");
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
                  text: 'عرض الكتف',
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context)
                        .order
                        .client!
                        .shouldersTall = value;
                  },
                  onValidate: (value) {
                    return BlocProvider.of<OrderCubit>(context)
                        .validation(value, "ادخل عرض الكتف");
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
                                  .getFilteredDeadline(), // تاريخ التسليم
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
                  text: 'تعليق زيادة',
                  onSaved: (value) {
                    BlocProvider.of<OrderCubit>(context).order.comment = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'أضافة',
                  onClick: () async {
                    bool valid = await BlocProvider.of<OrderCubit>(context)
                        .onConfirmOrder(widget.client);
                    if (valid) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('تم الأضافة بنجاح'),
                        backgroundColor: Colors.green,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('دخلي تاريخ التسليم'),
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
