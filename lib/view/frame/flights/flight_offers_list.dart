// lib/view/frame/flights/flight_offers_list.dart
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:loader_overlay/loader_overlay.dart';

import 'package:newhorizontrav/controller/airline_controller.dart';
import 'package:newhorizontrav/controller/flight/flight_detail_controller.dart';
import 'package:newhorizontrav/model/flight/flight_offer_model.dart';
import 'package:newhorizontrav/model/flight/flight_leg_model.dart';
import 'package:newhorizontrav/model/flight/revalidated_flight_model.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/utils/app_funs.dart';
import 'package:newhorizontrav/utils/app_vars.dart';
import 'package:newhorizontrav/utils/widgets.dart';
import 'package:newhorizontrav/view/frame/flights/flight_detail/flight_detail_page.dart';
import 'package:newhorizontrav/view/frame/flights/flight_detail/more_flight_detail_page.dart';
import 'package:newhorizontrav/view/settings/settings.dart';

class FlightOffersList extends StatefulWidget {
  final List flightOffers;

  const FlightOffersList({super.key, required this.flightOffers});

  @override
  State<FlightOffersList> createState() => _FlightOffersListState();
}

class _FlightOffersListState extends State<FlightOffersList> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final detailCtrl = Get.put(FlightDetailApiController(), permanent: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Offers'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   tooltip: 'Setting',
          //   onPressed: () {
          //     Get.to(() => const SettingsPage());
          //   },
          // ),
          // fillter button
          OutlinedButton.icon(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            icon: const Icon(Icons.filter_alt_outlined),
            label: const Text('Filter', style: TextStyle(fontSize: AppConsts.lg)),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: (widget.flightOffers.isNotEmpty)
          ? CupertinoScrollbar(
              controller: scrollController,
              child: ListView.separated(
                controller: scrollController,
                itemCount: widget.flightOffers.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final offerJson = widget.flightOffers[index] as Map<String, dynamic>;
                  final offer = FlightOfferModel.fromJson(offerJson);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: FlightOfferCard(
                      offer: offer,
                      onBook: () async {
                        context.loaderOverlay.show();
                        await detailCtrl.revalidateAndOpen(offer: offer);
                        if (context.mounted) context.loaderOverlay.hide();
                      },
                      onDetails: () {
                        Get.to(
                          () => FlightDetailPage(
                            detail: RevalidatedFlightModel(
                              offer: offer,
                              isRefundable: offer.isRefundable,
                              isPassportMandatory: false,
                              firstNameCharacterLimit: 0,
                              lastNameCharacterLimit: 0,
                              paxNameCharacterLimit: 0,
                              fareRules: const [],
                            ),
                            showContinueButton: false, 
                          ),
                        );
                      },
                      onMoreDetails: () {
                        Get.to(() => MoreFlightDetailPage(flightOffer: offer));
                      },
                    ),
                  );
                },
              ),
            )
          : const Center(child: Text('No offers found')),
    );
  }
}

class FlightOfferCard extends StatefulWidget {
  final FlightOfferModel offer;
  final VoidCallback? onBook;
  final VoidCallback? onDetails;
  final VoidCallback? onMoreDetails;
  final bool? showFare;
  final bool showSeatLeft;
  final bool showBaggage;

  const FlightOfferCard({super.key, required this.offer, this.onBook, this.onDetails, this.onMoreDetails, this.showFare = true, this.showSeatLeft = true, this.showBaggage = true});

  @override
  State<FlightOfferCard> createState() => _FlightOfferCardState();
}

class _FlightOfferCardState extends State<FlightOfferCard> {
  final AirlineController airlineController = Get.find();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final offer = widget.offer;

    final timeFormat = DateFormat('hh:mm a', 'en');
    final dateFormat = DateFormat('EEE, dd MMM', 'en');

    // ===== شركات طيران مسار الذهاب فقط (للهيدر) =====
    final outboundLeg = offer.outbound;
    final outboundCodes = _uniqueMarketingCodesForLeg(outboundLeg);
    final headerCodes = outboundCodes.isNotEmpty ? outboundCodes : <String>[offer.airlineCode];

    final primaryCode = headerCodes.first;
    final primaryName = airlineController.getAirlineName(primaryCode);

    String? secondaryCode;
    if (headerCodes.length > 1) secondaryCode = headerCodes[1];
    final String? secondaryName = secondaryCode != null ? airlineController.getAirlineName(secondaryCode) : null;

    final String airlineNamesText = secondaryName == null ? primaryName : '$primaryName, $secondaryName';

    // final String airlineNamesTextWithCode = secondaryName == null ? '$primaryName ($primaryCode)' : '$primaryName ($primaryCode), $secondaryName ($secondaryCode)';

    return Card(
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== الهيدر: شعارات + أسماء الذهاب + السعر ======
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شعارات + أسماء الذهاب
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: CacheImg("http://172.16.0.66/newhorizon/storage/images/airline/$primaryCode.png", sizeCircleLoading: 14),
                      ),
                      const SizedBox(width: 4),
                      if (secondaryCode != null) ...[
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: CacheImg("http://172.16.0.66/newhorizon/storage/images/airline/$secondaryCode.png", sizeCircleLoading: 14),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          airlineNamesText,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // السعر
                if (widget.showFare ?? true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppFuns.priceWithCoin(offer.totalAmount, offer.currency),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.error),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // ====== مسار الذهاب ======
            _LegRow(
              leg: outboundLeg,
              type: "departure",
              dateFormat: dateFormat,
              timeFormat: timeFormat,
              showLegAirlinesHeader: false, // شعارات الذهاب موجودة في الهيدر
            ),

            // ====== مسار العودة (إن وجد) مع شعارات خاصة به ======
            if (offer.isRoundTrip && offer.inbound != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _LegRow(
                leg: offer.inbound!,
                type: "return",
                dateFormat: dateFormat,
                timeFormat: timeFormat,
                showLegAirlinesHeader: true, // نعرض شعارات وأسماء العودة هنا
              ),
            ],

            const SizedBox(height: 12),

            // ====== المعلومات أسفل الكرت ======
            Row(
              children: [
                if (widget.showSeatLeft)
                Row(
                  children: [
                    const Icon(Icons.event_seat, size: 18),
                    const SizedBox(width: 4),
                      Text("${offer.seatsRemaining} ${"Seats left".tr}", style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(width: 12),
                if (widget.showBaggage)
                Row(
                  children: [
                    const Icon(Icons.luggage, size: 18),
                    const SizedBox(width: 4),
                    
                      Text((offer.baggageInfo ?? '').split(',').first, style: theme.textTheme.bodySmall),
                  ],
                ),
                if(widget.showSeatLeft && widget.showBaggage)
                const Spacer(),
                Text(offer.cabinClassText, style: theme.textTheme.bodySmall),
              ], 
            ),

            const SizedBox(height: 12),

            // ====== الأزرار ======
            if (widget.onBook != null || widget.onDetails != null)
              Row(
                children: [
                  if (widget.onBook != null)
                    Expanded(
                      child: ElevatedButton.icon(onPressed: widget.onBook!, icon: const Icon(Icons.lock), label: Text("Book now".tr)),
                    ),
                  if (widget.onBook != null && widget.onDetails != null) ...[
                    const SizedBox(width: 8),
                  ],
                  if (widget.onDetails != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.onDetails!,
                        icon: const Icon(Icons.info_outline),
                        label: Text("Details".tr),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// شركات التسويق بدون تكرار لمسار واحد
List<String> _uniqueMarketingCodesForLeg(FlightLegModel leg) {
  final seen = <String>{};
  final codes = <String>[];
  for (final seg in leg.segments) {
    if (seg.marketingAirlineCode.isNotEmpty && seen.add(seg.marketingAirlineCode)) {
      codes.add(seg.marketingAirlineCode);
    }
  }
  return codes;
}

/// مسار واحد (ذهاب أو عودة)
class _LegRow extends StatelessWidget {
  final FlightLegModel leg;
  final DateFormat dateFormat;
  final DateFormat timeFormat;
  final String type;

  /// هل نعرض شعارات وأسماء شركات هذا المسار؟
  final bool showLegAirlinesHeader;

  const _LegRow({
    required this.leg,
    required this.dateFormat,
    required this.timeFormat,
    required this.showLegAirlinesHeader,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final airlineController = Get.find<AirlineController>();

    final depTimeFull = timeFormat.format(leg.departureDateTime);
    final arrTimeFull = timeFormat.format(leg.arrivalDateTime);
    final depDate = dateFormat.format(leg.departureDateTime);
    final arrDate = dateFormat.format(leg.arrivalDateTime);

    final justDepTime = depTimeFull.split(' ')[0];
    final periodDepTime = depTimeFull.split(' ')[1];
    final justArrTime = arrTimeFull.split(' ')[0];
    final periodArrTime = arrTimeFull.split(' ')[1];

    // نص التوقفات
    String stopsText;
    if (leg.stops == 0) {
      stopsText = "Direct".tr;
    } else if (leg.stops == 1) {
      stopsText = "1 Stop".tr;
    } else {
      stopsText = "${leg.stops} ${"Stops".tr}";
    }

    // شركات هذا المسار (بدون تكرار)
    final legCodes = _uniqueMarketingCodesForLeg(leg);
    final legNames = legCodes.map((c) => airlineController.getAirlineName(c)).where((name) => name.isNotEmpty).toList();
    final legNamesText = legNames.join(', ');

    // اتجاه الطائرة ثابت حسب اللغة (نفسه في الذهاب والعودة)
    final bool isArabic = AppVars.lang == "ar";
    final double planeAngle = isArabic ? -math.pi / 2 : math.pi / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ===== صف شعارات وأسماء شركات هذا المسار (يظهر فقط في العودة) =====
        if (showLegAirlinesHeader) ...[
          Row(
            children: [
              // الشعارات بحجم 32 مثل الهيدر
              Row(
                children: [
                  if (legCodes.isNotEmpty)
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: CacheImg("http://172.16.0.66/newhorizon/storage/images/airline/${legCodes.first}.png", sizeCircleLoading: 14),
                    ),
                  if (legCodes.length > 1) ...[
                    const SizedBox(width: 4),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: CacheImg("http://172.16.0.66/newhorizon/storage/images/airline/${legCodes[1]}.png", sizeCircleLoading: 14),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  legNamesText,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],

        // ===== الصف الرئيسي (من / مدة / إلى) =====
        // return Directionality inverted
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // المغادرة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(depDate, style: theme.textTheme.bodySmall),
                  Row(
                    children: [
                      if (AppVars.lang == "en") ...[
                        Text(justDepTime, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            periodDepTime,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            periodDepTime,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(justDepTime, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(leg.fromCode, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(leg.fromName, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                ],
              ),
            ),

            // المنتصف (مدة الرحلة + الخط + الطائرة فوقه)
            Column(
              children: [
                Text(leg.totalDurationText, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                // const SizedBox(height: 4),
                SizedBox(
                  width: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox.shrink(),
                      DividerLine(),
                      Transform.rotate(angle: planeAngle, child: const Icon(Icons.airplanemode_active, size: 27)),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                Text(stopsText, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 26),
              ],
            ),

            // الوصول
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(arrDate, style: theme.textTheme.bodySmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (AppVars.lang == "en") ...[
                        Text(justArrTime, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            periodArrTime,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            periodArrTime,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(justArrTime, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(leg.toCode, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    leg.toName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
