import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/views/dohaudits/violations/violation_decision_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ViolationWorkflowDecisionView extends StatelessWidget {
  const ViolationWorkflowDecisionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0,),
            Text('Section Head Violation Review',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
            const SizedBox(height: 10.0,),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                border: Border.all(
                    color: Colors.grey.shade700, width: 1.5),
                //borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Status',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                  Text('Send to DC',style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 10.0,),
                  Text('Action By Department',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  Text('Medical Audit Inspector',style: Theme.of(context).textTheme.headlineMedium!),
                  const SizedBox(height: 10.0,),
                  Text('Action By:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0,),
                  Text('Mohammad Hasan AL Ali',style: Theme.of(context).textTheme.headlineMedium!),
                  const SizedBox(height: 10.0,),
                  Text('Assigned',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0,),
                  Text('01/12/2024',style: Theme.of(context).textTheme.headlineMedium!),
                  const SizedBox(height: 10.0,),
                  Text('Assigned To Department',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0,),
                  Text('Medical Audit Inspector',style: Theme.of(context).textTheme.headlineMedium!),
                  const SizedBox(height: 10.0,),
                  Text('Assigned To:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0,),
                  Text('Mohammed Hasan Al Ali',style: Theme.of(context).textTheme.headlineMedium!),
                  const SizedBox(height: 10.0,),
                  Text('Comments:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),
                  TextField(
                    enabled: false,
                    maxLines: 3,
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      //errorText: field.valid ? null : "required field".tr(),
                      hintText: 'Here goes the comment entered by the auditor/inspector',
                    ),
                  ),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      showViolationDecisionView(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.6),
                        border: Border.all(
                            color: Colors.grey.shade700, width: 1.5),
                        //borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                      ),
                      child: Row(
                        children: [
                          Text('Violation Decision',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  showViolationDecisionView(context) {
    WidgetUtil.showFullScreenDialog(context, ViolationDecisionView(),"Violation Decision".tr(), subtitle: 'PTL-HAVR-2024-0001385 - In Progress', [
    ], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }
}
