import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';

class TappableListItem extends StatelessWidget {
  const TappableListItem(
      {Key? key,
      required this.themeNotifier,
      required this.title,
      required this.icon,
      required this.count,
      required this.onTap,
      this.showCount = true,
      this.subtitle = ""})
      : super(key: key);

  final ThemeNotifier themeNotifier;
  final String title;
  final String subtitle;
  final IconData icon;
  final int count;
  final Function? onTap;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Material(
        color: themeNotifier.light5Color,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 12),
              SizedBox(
                height: 28,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(icon, color: themeNotifier.dark2Color),
                    const SizedBox(width: 28),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Expanded(child: SizedBox()),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    if (showCount)
                      ClipOval(
                        child: Material(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(count.toString(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.6)),
                        )),
                      ),
                    // badges.Badge(
                    //   //   padding: const EdgeInsets.all(8),
                    //   badgeContent: Text(
                    //     count.toString(),
                    //     style: Theme.of(context).textTheme.headlineMedium,
                    //   ),
                    //   badgeColor: themeNotifier.light2Color,

                    //   //   shape: badges.BadgeShape.circle,
                    //   elevation: 0,
                    //   // borderRadius: BorderRadius.circular(12),
                    // ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}
