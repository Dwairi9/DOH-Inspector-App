import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionNotifier = ref.watch(userSessionProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "My Profile".tr(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 40,
                child: Text(
                  userSessionNotifier.getInitials(),
                  style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          userSessionNotifier.getDisplayName(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(width: 4),
                        AutoSizeText(
                          "(${userSessionNotifier.userId})",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    AutoSizeText(
                      userSessionNotifier.getEmail(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView(
              children: [
                Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => launchUrl(
                      Uri.parse("privacyPolicyUrl".tr()),
                    ),
                    leading: const Icon(
                      Icons.privacy_tip,
                      //   color: themeNotifier.errorColor,
                    ),
                    title: Text('Privacy Policy'.tr(), style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => UserManageUtils.logoutConfirm(context),
                    leading: const Icon(
                      Icons.logout,
                    ),
                    title: Text('Logout'.tr(), style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
