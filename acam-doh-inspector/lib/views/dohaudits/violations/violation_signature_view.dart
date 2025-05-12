import 'dart:io';

import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/views/draw_view2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViolationSignatureView extends ConsumerWidget {
  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 4.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  const ViolationSignatureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Violation Comment', style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  Text('Count 0', style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 10,),
              TextField(
                maxLines: 5,
                style: Theme
                    .of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  //errorText: field.valid ? null : "required field".tr(),
                  hintText: 'Add Auditor Violation Comment',
                ),
              ),
              Divider(
                height: 25,
                color: Colors.transparent,
              ),
              Text("Inspector Signature".tr(), style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  addSignature(
                      context, _newController(), "Inspector Signature".tr(),
                      themeNotifier,
                      //provider
                  );
                },
                child: IgnorePointer(
                  child: SizedBox(
                    height: 240,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: themeNotifier
                                  .light3Color
                              ),
                            ),
                            child: PainterView(_newController())),
                        //if (provider.inspectorPainterController.isEmpty)
                        Center(
                            child: Text(
                              "Tap Here to Sign".tr(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: themeNotifier.light4Color),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 25,
                color: Colors.transparent,
              ),
              Row(
                children: [
                  Text("Responsible Party Signature".tr(), style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('Not Available',style: Theme.of(context).textTheme.bodySmall!),
                  const SizedBox(width: 7,),
                  SizedBox(
                    width: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: false,
                      onChanged: (value) => {
                        // provider.setRememberPassword(value ?? false),
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  addSignature(
                    context, _newController(), "Responsible Party Signature".tr(),
                    themeNotifier,
                    //provider
                  );
                },
                child: IgnorePointer(
                  child: SizedBox(
                    height: 240,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: themeNotifier
                                  .light3Color
                              ),
                            ),
                            child: PainterView(_newController())),
                        //if (provider.inspectorPainterController.isEmpty)
                        Center(
                            child: Text(
                              "Tap Here to Sign".tr(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: themeNotifier.light4Color),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),

    );
  }

  addSignature(BuildContext context, PainterController painterController,
      String title, ThemeNotifier themeNotifier,
      // AuditVisitViewProvider provider
      ) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(title, style: Theme
                .of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
            content: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 240,
                child: Container(
                    decoration: BoxDecoration(
                      color: themeNotifier.light0Color,
                      border: Border.all(color: themeNotifier.light3Color),
                    ),
                    child: PainterView(painterController))),
            actions: [
              TextButton(
                child: Text("Clear".tr()),
                onPressed: () {
                  painterController.clear();
                  //   provider.signatureUpdated();
                },
              ),
              TextButton(
                onPressed: () async {
                  //     provider.signatureUpdated();
                  Navigator.of(dialogContext).pop();
                },
                child: Text("Okay".tr()),
              ),
            ],
          );
        });
  }
}
