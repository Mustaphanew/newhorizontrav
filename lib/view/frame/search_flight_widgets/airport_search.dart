import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/airport_search_controller.dart';
import 'package:newhorizontrav/model/airport_model.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/utils/app_vars.dart';
import 'package:newhorizontrav/utils/enums.dart';
import 'package:newhorizontrav/utils/widgets.dart';

class AirportSearch extends StatelessWidget {
  const AirportSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AirportSearchController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConsts.primaryColor,
        // surfaceTintColor: AppConsts.primaryColor,
        leading: IconButton(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          tooltip: 'رجوع',
        ),
        title: const Text(
          'البحث عن موقع',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // مربع البحث ثابت بالأعلى
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Obx(
              () => TextField(
                controller: c.textCtrl,
                focusNode: c.focusNode,
                textInputAction: TextInputAction.search,
                // onSubmitted: c.search,
                onChanged: c.onChangeText,
                decoration: InputDecoration(
                  hintText: 'اكتب اسم المدينة، أو الرمز (مثل NYC)، أو الوصف…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: c.query.value.isEmpty
                      ? null
                      : IconButton(
                          onPressed: c.clear,
                          tooltip: 'مسح',
                          icon: const Icon(Icons.clear),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                autofocus: true,
              ),
            ),
          ),
      
          // النتائج قابلة للتمرير تحت مربع البحث
          Expanded(
            child: Obx(() {
              if (c.error.isNotEmpty) {
                return _ErrorState(
                  message: c.error.value,
                  onRetry: () => c.search(c.query.value),
                );
              }
      
              // if (c.query.value.trim().isEmpty) {
              //   return const HintState();
              // }
      
              if (c.loading.value) {
                return const Center(child: LoadingData());
              }
      
              if (c.results.isEmpty) {
                return const _EmptyState();
              }
      
              return Material(
                // color: Colors.white,
                child: ListView.separated(
                  // physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: c.results.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final AirportModel item = AirportModel.fromJson(
                      c.results[index],
                    );
                    return ListTile(
                      onTap: () => Get.back(
                        result: item,
                      ), // يرجع الاختيار للصفحة السابقة
                      leading: CircleAvatar(
                        child: Text(item.code.substring(0, 2)),
                      ),
                      title: _highlightedText(
                        text: '${item.code} — ${item.name[AppVars.lang]}',
                        query: c.query.value,
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      subtitle: _highlightedText(
                        text: item.body[AppVars.lang],
                        query: c.query.value,
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      trailing: Wrap(
                        direction: Axis.horizontal,
                        children: [

                          // item.type == LocationType.airport
                          //     ? const Icon(Icons.flight_outlined)
                          //     : const Icon(Icons.location_on_outlined),

                          const Icon(Icons.flight_outlined),
                      
                          // const Icon(Icons.navigate_next),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// عناصر واجهة لحالات مختلفة
class HintState extends StatelessWidget {
  const HintState({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.travel_explore, size: 48),
          const SizedBox(height: 12),
          Text(
            'ابدأ الكتابة للبحث عن مدينة أو مطار',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48),
          const SizedBox(height: 12),
          Text(
            'لا توجد نتائج مطابقة',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('اعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

// إبراز الجزء المطابق من النص (Highlight)
Widget _highlightedText({
  required String text,
  required String query,
  required TextStyle style,
}) {
  if (query.trim().isEmpty) {
    return Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  final q = query.trim();
  final lowerText = text.toLowerCase();
  final lowerQ = q.toLowerCase();
  final spans = <TextSpan>[];
  int start = 0;
  while (true) {
    final index = lowerText.indexOf(lowerQ, start);
    if (index < 0) {
      spans.add(TextSpan(text: text.substring(start)));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index)));
    }
    spans.add(
      TextSpan(
        text: text.substring(index, index + q.length),
        style: style.copyWith(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
    start = index + q.length;
    if (start >= text.length) break;
  }
  return RichText(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(style: style, children: spans),
  );
}
