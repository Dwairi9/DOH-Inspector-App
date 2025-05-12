import 'package:aca_mobile_app/views/dohaudits/violations/violation_title_subtitle_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViolationFacilityWidget extends StatelessWidget {
  const ViolationFacilityWidget({
    required this.licenseNumber, required this.englishName, required this.arabicName, required this.type, required this.subType, required this.category,
    required this.licenseIssueDate, required this.licenseExpiryDate, required this.region, required this.city,
    super.key,
  });

  final String licenseNumber;
  final String englishName;
  final String arabicName;
  final String type;
  final String subType;
  final String category;
  final String licenseIssueDate;
  final String licenseExpiryDate;
  final String region;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facility Information',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
        const SizedBox(height: 10,),
        ViolationTitleSubtitleView(title: licenseNumber ,subTitle: 'Facility License Number', enabled: false,),
        const SizedBox(height: 10,),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: englishName ,subTitle: 'Facility Name (English)', width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: arabicName, subTitle: 'Facility Name (Arabic)',isArabic: true, width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViolationTitleSubtitleView(title: type, subTitle: 'Facility Type', enabled: false,),
                    const SizedBox(height: 10,),
                    ViolationTitleSubtitleView(title: category, subTitle: 'Facility Category', enabled: false,),
                  ],
                )),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViolationTitleSubtitleView(title: subType, subTitle: 'Facility Sub Type', enabled: false,),
                  ],
                )),
          ],),
        const SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViolationTitleSubtitleView(title: licenseIssueDate, subTitle: 'Facility License Issue Date', width: 0.9, enabled: false),
            ],),
          const SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViolationTitleSubtitleView(title: licenseIssueDate, subTitle: 'Facility License Expiry Date', width: 0.9, enabled: false),
            ],),
          const SizedBox(height: 10,),
          const SizedBox(height: 10,),
      ],
    );
  }
}