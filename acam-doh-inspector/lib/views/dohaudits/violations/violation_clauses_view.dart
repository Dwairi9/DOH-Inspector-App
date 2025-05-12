import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ViolationClausesView extends StatelessWidget {
  const ViolationClausesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Violation Clauses',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                Text('Count 0',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold,fontSize: 15)),
              ],
            ),
            Divider(
              height: 25,
              color: Colors.grey.shade700,
            ),
            Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        value: false,
                        onChanged: (value) => {
                          // provider.setRememberPassword(value ?? false),
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 7,),
                Text('Select All',style: Theme.of(context).textTheme.bodySmall!),
                const SizedBox(width: 20,),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 30),
                    child: ElevatedButton(
                      onPressed: (){},
                      child:  Text(
                        'Add'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 30),
                    child: ElevatedButton(
                      onPressed: (){},
                      child:  Text(
                        'Delete'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            //const SizedBox(height: 10,),
            const ViolationCalusesCell(),

          ],
        ),
      ),
    );
  }
}

class ViolationCalusesCell extends StatelessWidget {
  const ViolationCalusesCell({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
         // height: 200,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.only(bottom: 10,left: 5),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 1.5),
            //borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      value: false,
                      onChanged: (value) => {
                        // provider.setRememberPassword(value ?? false),
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            fillColor: Colors.white,
                            filled: true,
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: themeNotifier.light3Color, width: 0.0),
                            // ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: "",
                              elevation: 16,
                              isExpanded: true,
                              style: TextStyle(color: Theme.of(context).primaryColor),
                              onChanged: (String? value) {
                                if (value != null) {
                                  //  provider.setInspectionResult(value);
                                }
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade800,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: "",
                                  child: Text("Facility".tr(), style: Theme.of(context).textTheme.headlineMedium),
                                ),
                                // ...provider.getInspectionResultGroupItems().map<DropdownMenuItem<String>>((InspectionResultGroupItem item) {
                                //   return DropdownMenuItem<String>(
                                //     value: item.value,
                                //     child: AutoSizeText(
                                //       item.text,
                                //       minFontSize: 11,
                                //       stepGranularity: 1,
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //       style: Theme.of(context).textTheme.headlineMedium,
                                //     ),
                                //   );
                                // }).toList()
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Text('Select',style: Theme.of(context).textTheme.bodySmall!),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: "",
                        elevation: 16,
                        isExpanded: true,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        onChanged: (String? value) {
                          if (value != null) {
                            //  provider.setInspectionResult(value);
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade800,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "",
                            child: Text("Facility".tr(), style: Theme.of(context).textTheme.headlineMedium),
                          ),
                          // ...provider.getInspectionResultGroupItems().map<DropdownMenuItem<String>>((InspectionResultGroupItem item) {
                          //   return DropdownMenuItem<String>(
                          //     value: item.value,
                          //     child: AutoSizeText(
                          //       item.text,
                          //       minFontSize: 11,
                          //       stepGranularity: 1,
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: Theme.of(context).textTheme.headlineMedium,
                          //     ),
                          //   );
                          // }).toList()
                        ],
                      ),
                    )),
              ),
              const SizedBox(height: 1,),
              Text('Violation Type',),
              SizedBox(height:  10,),
              Row(
                children: [
                Expanded(
                  child: const ViolationClausesTitleSubtitleView(
                    title: '40.0',subTitle: 'Violation Reference',),
                ),
                const SizedBox(width: 10,),
                Expanded(child: const ViolationClausesTitleSubtitleView(title: '45,000',subTitle: 'Violation Amount',)),
                const SizedBox(width: 10,),
                Text('AED',),
                const SizedBox(width: 10,),
              ],),
              SizedBox(height:  10,),
              Row(children: [
                Expanded(
                  child: const ViolationClausesTitleSubtitleView(
                    title: '0',subTitle: 'Occurance',),
                ),
                const SizedBox(width: 10,),
                Expanded(child: const ViolationClausesTitleSubtitleView(title: '3',subTitle: 'Follow Up',)),
                const SizedBox(width: 10,),
                Text('days',),
                const SizedBox(width: 10,),
              ],),
              const SizedBox(height: 10,),
              Padding(padding:EdgeInsets.only(right: 10.0),child: const ViolationClausesTitleSubtitleView(title: '3',subTitle: 'Action',)),
              const SizedBox(height: 10,),
              Padding(padding:EdgeInsets.only(right: 10.0),child: const ViolationClausesTitleSubtitleView(title: 'Enter your remarks here',subTitle: 'Remarks',isEnabled: true,)),
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 2,right: 2),
            //margin: EdgeInsets.fromLTRB(0, 0,0, 0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              '1',
              style: Theme.of(context).textTheme.bodySmall
            ),
          ),
        ),
      ],
    );
  }
}


class ViolationClausesTitleSubtitleView extends StatelessWidget {
  const ViolationClausesTitleSubtitleView({
    required this.title, required this.subTitle, this.isArabic = false, this.isEnabled = false,
    super.key,
  });
  final String title;
  final String subTitle;
  final bool isArabic;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            enabled: isEnabled,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16,color: isEnabled ? Colors.black: null),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              //errorText: field.valid ? null : "required field".tr(),
              hintText: title,
            ),
            onChanged: null
        ),
        const SizedBox(height: 1,),
        Text(subTitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
        ),
      ],
    );
  }
}
