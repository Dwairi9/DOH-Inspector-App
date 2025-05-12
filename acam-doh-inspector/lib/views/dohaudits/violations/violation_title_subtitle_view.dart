import 'package:flutter/material.dart';

class ViolationTitleSubtitleView extends StatelessWidget {
  const ViolationTitleSubtitleView({
    required this.title, required this.subTitle, this.isArabic = false, this.width, this.enabled = true, this.onChange, this.onSubmitted,
    super.key,
  });
  final String title;
  final String subTitle;
  final bool isArabic;
  final double? width;
  final bool enabled;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final widthFactor = width ?? 0.65;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*widthFactor,
          child: TextField(
            enabled: enabled,
            textDirection: isArabic ? TextDirection.rtl : null,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              //errorText: field.valid ? null : "required field".tr(),
              hintText: title,
            ),
            onChanged: onChange,
            onSubmitted: onSubmitted,
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 4),
        //
        //   decoration: BoxDecoration(
        //     border:  Border.all(color: Colors.grey.shade700),
        //   ),
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width*0.44,
        //     child: Text(title,
        //       style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey.shade700,),
        //       textDirection: isArabic ?
        //       TextDirection.rtl : null,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 1,),
        Text(subTitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 14,),
        ),
      ],
    );
  }
}


