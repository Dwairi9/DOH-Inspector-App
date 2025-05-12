import 'package:flutter/material.dart';

class ViolationSectionHeadView extends StatelessWidget {
  const ViolationSectionHeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Section Head Status',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                Text('Return to Auditor',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold,fontSize: 15)),
              ],
            ),
            Divider(
              height: 25,
              color: Colors.grey.shade700,
            ),
            Text('Section Head Comment', style: Theme
                .of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10,),
            TextField(
              enabled: false,
              maxLines: 5,
              style: Theme
                  .of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                //errorText: field.valid ? null : "required field".tr(),
                hintText: 'Please review administration violation item 2, and make sure to attach corresponding documents',
              ),
            ),
            Divider(
              height: 25,
              color: Colors.grey.shade700,
            ),
            Text('Schedule Meeting', style: Theme
                .of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, size: 20, color: Theme.of(context).primaryColor),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '21',
                          //DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //   dateValue!.year.toString(),
                              '2024',
                              //DateFormat.y(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString(),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 0.8),
                            ),
                            const SizedBox(height: 2,),
                            Text(
                              'DEC',
                              //  DateFormat.MMM(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toUpperCase(),
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1),
                            )
                          ],
                        )
                      ],
                    ),
                    Text('Meeting Date',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.watch_later_rounded, size: 20, color: Theme.of(context).primaryColor),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '10',
                          //DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          ':30',
                          //DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'AM',
                          //DateFormat.d(Utility.isRTL(context) ? 'ar' : 'en_US').format(dateValue!).toString().padLeft(2, Utility.isRTL(context) ? '٠' : '0'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                    Text('Meeting Clock',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),

            TextField(
              enabled: false,
              maxLines: 5,
              style: Theme
                  .of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                //errorText: field.valid ? null : "required field".tr(),
                hintText: 'Address detail of the meeting location.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
