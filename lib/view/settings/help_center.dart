// lib/view/pages/help_center_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:newhorizontrav/controller/help_center_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/utils/widgets.dart';

class HelpCenterPage extends StatefulWidget {
  final String? title;
  const HelpCenterPage({super.key, this.title });

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  HelpCenterController helpCenterController = Get.put(HelpCenterController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<HelpCenterController>(
      builder: (c) {
        if (c.loading) {
          return LoadingData();
        } else if (c.items == null) {
          return ErrorData();
        } else if (c.items!.isEmpty) {
          return EmptyData();
        }
        return Container(
          color: theme.colorScheme.surfaceContainer,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.title != null)
                Text(widget.title!.tr, style: theme.textTheme.titleMedium),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemCount: c.items!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 👈 عنصران في الصف
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05, // اضبطها لقياساتك
                ),
                itemBuilder: (_, i) {
                  final item = c.items![i];
                  return TextButton(
                    style: TextButton.styleFrom(
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      // border
                      side: BorderSide(
                        // 👈 الحد (الـ border)
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                      // backgroundColor: theme.colorScheme.error,
                    ),
                    onPressed: () => c.openItem(item),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الصورة من الأصول (استبدل بـ Image.network لو عندك صور خارجية)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            "https://newhorizontrav.com/${item.image??''}", 
                            width: 56,
                            height: 56, 
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) {
                              if (item.url.toString().contains('whatsapp')) {
                                return const Icon(FontAwesomeIcons.squareWhatsapp, size: 48);
                              } else if (item.url.toString().contains('t.me')) {
                                return const Icon(FontAwesomeIcons.telegram, size: 48);
                              } else if (item.url.toString().contains('tel:')) {
                                return const Icon(FontAwesomeIcons.squarePhone, size: 48);
                              } else if (item.url.toString().contains('sms:')) {
                                return const Icon(Icons.sms, size: 48);
                              } else if (item.url.toString().contains('mailto:')) {
                                return const Icon(Icons.email, size: 48);
                              } else if (item.url == AppConsts.baseUrl) {
                                return const Icon(FontAwesomeIcons.globe, size: 48);
                              }
                              return const Icon(Icons.help_outline, size: 48);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name.tr,
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
