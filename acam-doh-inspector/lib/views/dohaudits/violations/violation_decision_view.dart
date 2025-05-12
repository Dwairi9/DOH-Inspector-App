import 'package:flutter/material.dart';

class ViolationDecisionView extends StatelessWidget {
  const ViolationDecisionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Decision on Facility',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                Text('Reconciliation Requested\nNo',style: Theme.of(context).textTheme.headlineMedium!,textAlign: TextAlign.center,),

              ],
            ),
            const SizedBox(height: 10.0,),
            Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade700, width: 1.5),
              //borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Move to Profile',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                  Text('No',style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10.0,),
                  Text('Decision Number',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                  Text('DC/24/1192024',style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10.0,),
                  Text('DC Decision Date:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                  Text('14/12/2024',style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10.0,),
                  Text('Related Action:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                  Text('No Action',style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10.0,),
                  Text('Remarks:',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
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
                      hintText: 'Remarks added by the Disciplinary Committee for the Facility.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
