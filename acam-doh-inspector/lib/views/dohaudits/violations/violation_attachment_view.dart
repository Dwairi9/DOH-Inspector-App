import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViolationAttachmentView extends StatelessWidget {
  const ViolationAttachmentView({super.key});

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
                Text('Attached Documents',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold)),
                Text('Count 0',style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight:   FontWeight.bold,fontSize: 15)),
              ],
            ),
            Divider(
              height: 25,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          height: 50,
          child: Column(
            children: [
              Divider(
               // height: 25,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 10,),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        try{
                          ImagePicker picker = ImagePicker();
                          XFile? media = await picker.pickMedia();

                          if (media != null) {
                          var file = File(media.path);

                          // var res = await provider.uploadAttachment(file);
                          // if (context.mounted) AcamUtility.showMessageForActionObject(context, res);
                          // if (res.success) {
                          // //provider.loadAttachments();
                          // }
                          }
                          } catch (ex) {}
                      },
                        child: Icon(Icons.attach_file_sharp,color: Theme.of(context).primaryColor,)),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        try{
                          ImagePicker picker = ImagePicker();
                          XFile? media = await picker.pickImage(source: ImageSource.gallery);

                          if (media != null) {
                            var file = File(media.path);

                            // var res = await provider.uploadAttachment(file);
                            // if (context.mounted) AcamUtility.showMessageForActionObject(context, res);
                            // if (res.success) {
                            // //provider.loadAttachments();
                            // }
                          }
                        } catch (ex) {}
                      },
                        child: Icon(Icons.camera_alt_outlined,color: Theme.of(context).primaryColor,)),
                  )
                ],
              ),
              // Divider(
              //   color: Colors.grey.shade700,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
