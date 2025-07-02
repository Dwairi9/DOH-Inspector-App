import 'package:aca_mobile_app/views/dohaudits/violations/violation_title_subtitle_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViolationProfessionalWidget extends StatelessWidget {
  const ViolationProfessionalWidget({
    required this.licenseNumber, required this.englishName, required this.arabicName, required this.category, required this.major, required this.profession,
    required this.licenseIssueDate, required this.licenseExpiryDate, required this.onProfessionalLicenseNumberChanged,
    super.key,
  });

  final String licenseNumber;
  final String englishName;
  final String arabicName;
  final String category;
  final String major;
  final String profession;
  final String licenseIssueDate;
  final String licenseExpiryDate;
  final ValueChanged<String> onProfessionalLicenseNumberChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Professional Information',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
        const SizedBox(height: 10,),
        ViolationTitleSubtitleView(title: licenseNumber ,subTitle: 'Professional License Number', onSubmitted: onProfessionalLicenseNumberChanged),
        const SizedBox(height: 10,),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: englishName ,subTitle: 'Professional Name (English)', width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: arabicName, subTitle: 'Professional Name (Arabic)',isArabic: true, width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViolationTitleSubtitleView(title: category, subTitle: 'Category', enabled: false,),
                    const SizedBox(height: 10,),
                    ViolationTitleSubtitleView(title: major, subTitle: 'Major', enabled: false,)
                  ],
                )),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViolationTitleSubtitleView(title: profession, subTitle: 'Profession', enabled: false,),
                  ],
                )),
          ],),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: licenseIssueDate, subTitle: 'Professional License Issue Date', width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViolationTitleSubtitleView(title: licenseExpiryDate, subTitle: 'Professional License Expiry Date', width: 0.9, enabled: false),
          ],),
        const SizedBox(height: 10,),
      ],
    );
  }
}