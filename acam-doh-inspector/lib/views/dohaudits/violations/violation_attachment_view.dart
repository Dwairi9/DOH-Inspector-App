import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:printing/printing.dart';

import '../../../Widgets/acam_widgets.dart';
import '../../../data_models/attachment.dart';
import '../../../repositories/attachment_repository.dart';
import '../../../themes/theme_provider.dart';
import '../../../user_management/providers/user_session_provider.dart';
import '../../../utility/utility.dart';
import '../../../view_providers/dohaudits/audit_visit_view_provider.dart';
import '../../../view_widgets/acam_utility.dart';

class ViolationAttachmentView extends ConsumerWidget {
  final ChangeNotifierProvider<AuditVisitViewProvider> auditVisitViewProvider;
  const ViolationAttachmentView({required this.auditVisitViewProvider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(auditVisitViewProvider);
    final themeNotifier = ref.watch(themeProvider);

    var attachments = provider.violationAttachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.isLoading)
          LinearProgressIndicator(
            color: themeNotifier.primaryColor,
            backgroundColor: Colors.transparent,
          )
        else if (provider.isDeleting)
          LinearProgressIndicator(
            color: themeNotifier.errorColor,
            backgroundColor: Colors.transparent,
          )
        else if (provider.isUploading)
            LinearProgressIndicator(
              color: themeNotifier.primaryColor,
              backgroundColor: Colors.transparent,
              value: provider.uploadProgress,
            )
          else
            const SizedBox(
              height: 4,
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22.0, 0, 22, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  maxLines: 1,
                  minFontSize: 14,
                  "Attached Documents".tr(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Row(
                children: [
                  Text(
                    "Count".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ClipOval(
                    child: Material(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(attachments.length.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(height: 1.6)),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        if(provider.isViolationEditable)
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8, 24, 8),
            child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.isPreventOperations()
                      ? null
                      : () async {
                    try {
                      ImagePicker picker = ImagePicker();
                      XFile? media = await picker.pickMedia();

                      if (media != null) {
                        var file = File(media.path);

                        var res = await provider.uploadAttachment(file);
                        if (context.mounted)
                          AcamUtility.showMessageForActionObject(context, res);

                        if (res.success) {
                          provider.loadAttachments();
                        }
                      }
                    } catch (ex) {}
                  },
                  child: Text("Add Attachment".tr()),
                )),
          ),
        const SizedBox(
          height: 12,
        ),
        if (attachments.isEmpty) ...[
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.file_present,
                      size: 140,
                      color: themeNotifier.light3Color,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'There are no attached documents'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: themeNotifier.light4Color),
                    ),
                    if (!provider.isReadOnly)
                      Text(
                        'Tap on Add Attachment button to add attachments'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: themeNotifier.light4Color),
                      ),
                  ],
                )),
          ),
          const SizedBox(
            height: 24,
          )
        ] else
          ListView.builder(
              itemCount: attachments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: AttachmentItemWidget(
                      attachment: attachments[index], provider: provider),
                );
              }),
      ],
    );
  }
}

class AttachmentItemWidget extends ConsumerWidget {
  const AttachmentItemWidget({
    super.key,
    required this.attachment,
    required this.provider,
  });

  final Attachment attachment;
  final AuditVisitViewProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeNotifier = ref.read(themeProvider);
    // var uploadDate = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').parse(attachment.uploadDate);
    // var formattedDate = DateFormat('dd MMMM yyyy', Utility.isRTL(context) ? 'ar_AE' : 'en_US').format(uploadDate);
    return Column(
      children: [
        const SizedBox(height: 10),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(8),
          color: themeNotifier.light0Color,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ImageFrameWidget(
                      attachment: attachment,
                      auditVisitViewProvider: provider,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          attachment.fileName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 15),
                          maxLines: 2,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          attachment.category,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 11),
                          maxLines: 1,
                          minFontSize: 9,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          attachment.fileType,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 11),
                          maxLines: 1,
                          minFontSize: 9,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          Utility.getFileSizeString(bytes: attachment.size),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 11),
                          maxLines: 1,
                          minFontSize: 9,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 42, right: 42),
                child: Row(
                  mainAxisAlignment: provider.isReadOnly
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!Platform.isIOS)
                      AcamIcon(
                        icon: Icons.file_download_outlined,
                        text: "Save".tr(),
                        condensed: true,
                        iconSize: 34,
                        iconColor: themeNotifier.primaryColor,
                        disabled: provider.isPreventOperations(),
                        onTap: () {
                          AttachmentRepository.downloadDocument(
                              attachment.documentNo,
                              attachment.fileName,
                              false);
                          // Utility.downloadFile(attachments[index].documentNo, attachments[index].fileName, context);
                        },
                      ),
                    if(provider.isViolationEditable)
                      AcamIcon(
                        icon: Icons.delete_outline,
                        text: "Delete".tr(),
                        condensed: true,
                        iconSize: 34,
                        disabled: provider.isPreventOperations(),
                        iconColor: themeNotifier.errorColor,
                        onTap: () {
                          // show confirmation dialog
                          showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: Text("Delete Attachment".tr()),
                                  content: Text(
                                      "Are you sure you want to delete this attachment?"
                                          .tr()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: Text("Cancel".tr()),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(dialogContext).pop();
                                        var actionObject =
                                        await provider.deleteAttachment(attachment.documentNo);

                                        if (context.mounted)
                                          AcamUtility.showMessageForActionObject(context, actionObject);

                                        if (actionObject.success) {
                                          provider.loadAttachments();
                                        }
                                      },
                                      child: Text("Delete".tr()),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ImageFrameWidget extends ConsumerWidget {
  const ImageFrameWidget({
    Key? key,
    required this.attachment,
    required this.auditVisitViewProvider,
  }) : super(key: key);

  final Attachment attachment;
  final AuditVisitViewProvider auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String mimeType = attachment.fileType;

    final userSessionNotifier = ref.watch(userSessionProvider);
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              if (mimeType.contains("image"))
                InkWell(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Utility.getImageFromAccela(
                        attachment.documentNo, userSessionNotifier.getToken(),
                        boxFit: BoxFit.cover),
                  ),
                  onTap: () {
                    openImage(context, attachment.documentNo,
                        attachment.fileName, userSessionNotifier);
                  },
                ),
              if (mimeType.contains("pdf"))
                InkWell(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: () {
                    openPdf(context, attachment.documentNo, attachment.fileName,
                        auditVisitViewProvider);
                  },
                ),
              if (!mimeType.contains("pdf") && !mimeType.contains("image"))
                Container(
                  constraints: const BoxConstraints.expand(),
                  child: Icon(
                    Icons.file_present,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }

  openImage(BuildContext context, String documentNo, String title,
      UserSessionProvider userSessionNotifier) async {
    var url = Utility.getImageUrl(documentNo, userSessionNotifier.getToken());
    var headers = Utility.getImageHeaders(documentNo);
    WidgetUtil.showFullScreenDialog(
        context,
        PhotoView(
          imageProvider: CachedNetworkImageProvider(url, headers: headers),
        ),
        title,
        [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }

  openPdf(BuildContext context, String documentNo, String fileName,
      AuditVisitViewProvider provider) async {
    provider.downloadAttachment(documentNo, fileName);
    WidgetUtil.showFullScreenDialog(
        context,
        AttachmentPdfViewerWidget(
          auditVisitViewProvider: provider,
        ),
        fileName,
        [], onClose: (BuildContext context) {
      Navigator.pop(context);
    });
  }
}

class AttachmentPdfViewerWidget extends ConsumerWidget {
  const AttachmentPdfViewerWidget(
      {Key? key, required this.auditVisitViewProvider})
      : super(key: key);

  final AuditVisitViewProvider auditVisitViewProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
    ref.watch(ChangeNotifierProvider((ref) => auditVisitViewProvider));
    if (provider.isDownloading) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 40),
              Text(
                "Loading PDF Document".tr(),
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ));
    } else if (!provider.downloadResult.success) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Failed to load PDF Document".tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                provider.downloadResult.message,
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ));
    }

    return PdfPreview(
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      dynamicLayout: true,
      build: (format) {
        final file = File(provider.downloadResult.content);
        return file.readAsBytes();
      },
    );
  }
}
