import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:newhorizontrav/controller/flight/flight_detail_controller.dart';
import 'package:newhorizontrav/controller/passport/travelers_review/travelers_review_controller.dart';
import 'package:newhorizontrav/model/booking_data_model.dart';
import 'package:newhorizontrav/model/contact_model.dart';
import 'package:newhorizontrav/model/passport/passport_model.dart';
import 'package:newhorizontrav/model/passport/traveler_review/traveler_review_model.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/utils/app_funs.dart';
import 'package:newhorizontrav/view/frame/flights/flight_detail/flight_detail_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newhorizontrav/view/frame/issuing/issuing_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TravelersReviewPage extends StatefulWidget {
  final List<TravelerReviewModel> travelers;
  final int insertId;
  final ContactModel contact;

  const TravelersReviewPage({super.key, required this.travelers, required this.insertId, required this.contact});

  /// Chip بسيطة لعرض معلومة (ممكن تستخدم لاحقًا لو حبيت)
  static Widget infoChip({required IconData icon, required String label, required String value, required ThemeData theme}) {
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text('$label: ', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.8))),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  State<TravelersReviewPage> createState() => _TravelersReviewPageState();
}

class _TravelersReviewPageState extends State<TravelersReviewPage> {
  final FlightDetailApiController flightDetailApiController = Get.find<FlightDetailApiController>();

  int _currentTravelerIndex = 0; // 👈 مؤشر السلايدر

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GetBuilder<TravelersReviewController>(
      init: TravelersReviewController(widget.travelers),
      builder: (c) {
        return SafeArea(
          bottom: true,
          top: false,
          left: false,
          right: false,
          child: Scaffold(
            appBar: AppBar(title: Text('Travelers review'.tr)),
            body: Column(
              children: [
                // ======= المحتوى الرئيسي القابل للتمرير =======
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 33),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (flightDetailApiController.revalidatedDetails.value != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                            child: FlightMainCard(revalidatedDetails: flightDetailApiController.revalidatedDetails.value!),
                          ),
                          SizedBox(height: 8),
                        ],

                        // ======= قائمة المسافرين كسلايدر =======
                        if (c.travelers.isNotEmpty) ...[
                          const SizedBox(height: 0),

                          CarouselSlider.builder(
                            itemCount: c.travelers.length,
                            itemBuilder: (context, index, realIndex) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: _buildTravelerTile(
                                  context: context,
                                  index: index,
                                  traveler: c.travelers[index],
                                  travelersCount: c.travelers.length,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              viewportFraction: 0.98, // الكرت ياخذ 90% من عرض الشاشة
                              enlargeCenterPage: true, // يكبر الكرت اللي في النص
                              enableInfiniteScroll: false, // بدون سكول لا نهائي
                              height: 300, // عدّلها حسب ارتفاع الكرت عندك
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentTravelerIndex = index;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 0),

                        ],

                        // ======= بيانات الاتصال =======
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8), child: _buildContactTile(context)),
                      ],
                    ),
                  ),
                ),

                // ======= شريط التلخيص + زر التأكيد =======
                _buildSummaryBar(context, c, cs),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  //  Widgets فرعية
  // ---------------------------------------------------------------------------

  Widget _buildTravelerTile({
    required BuildContext context,
    required int index,
    required TravelerReviewModel traveler,
    required int travelersCount,
  }) {
    final cs = Theme.of(context).colorScheme;
    final p = traveler.passport;

    final ageGroupLabel = p.ageGroupLabel;
    final fareLabel = AppFuns.priceWithCoin(traveler.totalFare, '\$');

    return Card(
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 عشان نحط الـ dots تحت
          children: [
            // ---------------- معلومات المسافر ----------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   
                  children: [
                    // العنوان: Traveler 1: Adult
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // border under line
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            '${'Traveler'.tr} ${index + 1}: ',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppConsts.xlg),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(ageGroupLabel, style: const TextStyle(fontSize: AppConsts.xlg),),
                        const Spacer(),
                        Text('${index + 1} / $travelersCount'),
                      ],
                    ),
                    const SizedBox(height: 8),
                        
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [ 
                            ...[
                              Text('Full name', style: const TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.bold),),
                              Text(p.fullName, style: const TextStyle(fontSize: AppConsts.normal),),
                            ],
                            ...[
                              Text('Passport number', style: const TextStyle(fontSize: AppConsts.normal, fontWeight: FontWeight.bold),),
                              Text(p.documentNumber??'_', style: const TextStyle(fontSize: AppConsts.normal),),
                            ],
                            const SizedBox(height: 4),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date of birth', style: const TextStyle(fontWeight: FontWeight.bold),),  
                                    Text(AppFuns.formatDobPretty(p.dateOfBirth, locale: 'en')), 
                                    const SizedBox(height: 4),
                                    Text('Nationality', style: const TextStyle(fontWeight: FontWeight.bold),),  
                                    Text(p.nationality?.name['en'] ?? '-',), 
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date of expiry', style: const TextStyle(fontWeight: FontWeight.bold),),  
                                    Text(AppFuns.formatDobPretty(p.dateOfExpiry, locale: 'en')), 
                                    const SizedBox(height: 4),
                                    Text('Issuing country', style: const TextStyle(fontWeight: FontWeight.bold),),  
                                    Text(p.issuingCountry?.name['en'] ?? '-'), 
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
      
            // ---------------- الـ dots داخل الكرت ----------------
            Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentTravelerIndex, // 👈 من الـ State
                count: travelersCount, // = c.travelers.length
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 6,
                  activeDotColor: cs.primaryContainer,
                  dotColor: cs.outline.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContactTile(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final firstName = widget.contact.firstName;
    final lastName = widget.contact.lastName;
    final fullname = (firstName.isEmpty && lastName.isEmpty) ? '-' : '$firstName $lastName';

    final email = widget.contact.email;

    final dialCode = widget.contact.phoneCountry.dialcode;
    final phoneNumber = widget.contact.phone;

    final phoneLabel = (dialCode.isEmpty && phoneNumber.isEmpty) ? '-' : '${dialCode.isNotEmpty ? dialCode + ' ' : ''}$phoneNumber';
    final nationality = widget.contact.nationality.name['en'];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: cs.surfaceContainer,
      onTap: () {},
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              // border under line
              border: Border(
                bottom: BorderSide(
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Contact: '.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppConsts.xlg),
            ),
          ),
        ],
      ),
      subtitle: Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              const SizedBox(height: 4),
              ...[
                Text('Full name', style: const TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.bold),),
                Text(fullname, style: const TextStyle(fontSize: AppConsts.lg),),
              ],
              const SizedBox(height: 2),
              ...[
                Text('Email', style: const TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.bold),),
                Text(email.isEmpty ? '-' : email, style: const TextStyle(fontSize: AppConsts.normal),),
              ],
              const SizedBox(height: 2),
              ...[
                Text('Phone', style: const TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.bold),),
                Text('+' + phoneLabel, style: const TextStyle(fontSize: AppConsts.normal),),
              ],
              // const SizedBox(height: 2),
              // ...[
              //   Text('Nationality', style: const TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.bold),),
              //   Text(nationality, style: const TextStyle(fontSize: AppConsts.normal),),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBar(BuildContext context, TravelersReviewController c, ColorScheme cs) {
    return Container(
      
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(top: 12, start: 16, end: 16, bottom: 26),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primaryFixed,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======= تفاصيل الأسعار =======
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Adult
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text('Adult'.tr + ' ${c.summary.adultCount}', style: const TextStyle(fontSize: AppConsts.lg)),
                        Text(
                          ': ${AppFuns.priceWithCoin(c.summary.adultTotalFare ?? 0.0, '\$')}',
                          style: const TextStyle(fontSize: AppConsts.lg),
                        ),
                      ],
                    ),

                    // Child
                    if (c.summary.childTotalFare != null)
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Text('Child'.tr + ' ${c.summary.childCount}', style: const TextStyle(fontSize: AppConsts.lg)),
                          Text(
                            ': ${AppFuns.priceWithCoin(c.summary.childTotalFare!, '\$')}',
                            style: const TextStyle(fontSize: AppConsts.lg),
                          ),
                        ],
                      ),

                    // Infant
                    if (c.summary.infantLapTotalFare != null)
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Text('Infant'.tr + ' ${c.summary.infantLapCount}', style: const TextStyle(fontSize: AppConsts.lg)),
                          Text(
                            ': ${AppFuns.priceWithCoin(c.summary.infantLapTotalFare!, '\$')}',
                            style: const TextStyle(fontSize: AppConsts.lg),
                          ),
                        ],
                      ),

                    // 🔹 Divider الآن بعرض الـ Column (يعني على قد النص)
                    Divider(color: cs.primaryFixed),

                    // Total
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          'Total'.tr,
                          style: TextStyle(color: cs.primaryContainer, fontSize: AppConsts.xxlg, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ': ${AppFuns.priceWithCoin(c.summary.totalPrice, '\$')}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: cs.primaryContainer, fontSize: AppConsts.xxlg),
                        ),
                        Text(" "),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ======= زر تأكيد الحجز =======
          ElevatedButton.icon(
            onPressed: () async {
              context.loaderOverlay.show();
              // await c.confirmBooking(widget.insertId); 
              Get.to(() => IssuingPage(
                offerDetail: flightDetailApiController.revalidatedDetails.value!, 
                travelers: c.travelers, 
                contact: widget.contact,
                pnr: "tmp",
                booking: BookingDataModel(
                  id: "123", 
                  companyId: "123", 
                  customerId: "123", 
                  module: "Flight", 
                  status: BookingStatus.notFound, 
                  createdOn: DateTime.now(),
                  travelDate: DateTime.now(), 
                  bookedBy: "123",  
                  bookingId: "123", 
                  countryCode: null, 
                  mobileNo: "123", 
                  currency: "123",
                ),
              ));
              if(context.mounted) context.loaderOverlay.hide();
            },
            icon: Text('Confirm Booking'.tr),
            label: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
