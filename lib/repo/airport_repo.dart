import 'package:newhorizontrav/model/airport_model.dart';
import 'package:newhorizontrav/utils/app_vars.dart';

class AirportRepo {
  // يمكنك إضافة المزيد من المدن لاحقًا
  static const List<Map<String, dynamic>> _data = [
    {
      "id": 1,
      "code": "DXB",
      "name": {"en": "Dubai International Airport", "ar": "مطار دبي الدولي"},
      "body": {"en": "Dubai, United Arab Emirates", "ar": "دبي، الإمارات العربية المتحدة"},
    },
    {
      "id": 2,
      "code": "DWC",
      "name": {"en": "Al Maktoum International Airport", "ar": "مطار آل مكتوم الدولي"},
      "body": {"en": "Dubai, United Arab Emirates", "ar": "دبي، الإمارات العربية المتحدة"},
    },
    {
      "id": 3,
      "code": "AUH",
      "name": {"en": "Abu Dhabi International Airport", "ar": "مطار أبوظبي الدولي"},
      "body": {"en": "Abu Dhabi, United Arab Emirates", "ar": "أبوظبي، الإمارات العربية المتحدة"},
    },
    {
      "id": 4,
      "code": "SHJ",
      "name": {"en": "Sharjah International Airport", "ar": "مطار الشارقة الدولي"},
      "body": {"en": "Sharjah, United Arab Emirates", "ar": "الشارقة، الإمارات العربية المتحدة"},
    },
    {
      "id": 5,
      "code": "RUH",
      "name": {"en": "King Khalid International Airport", "ar": "مطار الملك خالد الدولي"},
      "body": {"en": "Riyadh, Saudi Arabia", "ar": "الرياض، المملكة العربية السعودية"},
    },
    {
      "id": 6,
      "code": "JED",
      "name": {"en": "King Abdulaziz International Airport", "ar": "مطار الملك عبدالعزيز الدولي"},
      "body": {"en": "Jeddah, Saudi Arabia", "ar": "جدّة، المملكة العربية السعودية"},
    },
    {
      "id": 7,
      "code": "MED",
      "name": {"en": "Prince Mohammad bin Abdulaziz Airport", "ar": "مطار الأمير محمد بن عبدالعزيز"},
      "body": {"en": "Medina, Saudi Arabia", "ar": "المدينة المنورة، المملكة العربية السعودية"},
    },
    {
      "id": 8,
      "code": "DMM",
      "name": {"en": "King Fahd International Airport", "ar": "مطار الملك فهد الدولي"},
      "body": {"en": "Dammam, Saudi Arabia", "ar": "الدمام، المملكة العربية السعودية"},
    },
    {
      "id": 9,
      "code": "DOH",
      "name": {"en": "Hamad International Airport", "ar": "مطار حمد الدولي"},
      "body": {"en": "Doha, Qatar", "ar": "الدوحة، قطر"},
    },
    {
      "id": 10,
      "code": "BAH",
      "name": {"en": "Bahrain International Airport", "ar": "مطار البحرين الدولي"},
      "body": {"en": "Manama, Bahrain", "ar": "المنامة، البحرين"},
    },
    {
      "id": 11,
      "code": "KWI",
      "name": {"en": "Kuwait International Airport", "ar": "مطار الكويت الدولي"},
      "body": {"en": "Kuwait City, Kuwait", "ar": "مدينة الكويت، الكويت"},
    },
    {
      "id": 12,
      "code": "MCT",
      "name": {"en": "Muscat International Airport", "ar": "مطار مسقط الدولي"},
      "body": {"en": "Muscat, Oman", "ar": "مسقط، عُمان"},
    },
    {
      "id": 13,
      "code": "CAI",
      "name": {"en": "Cairo International Airport", "ar": "مطار القاهرة الدولي"},
      "body": {"en": "Cairo, Egypt", "ar": "القاهرة، مصر"},
    },
    {
      "id": 14,
      "code": "HBE",
      "name": {"en": "Borg El Arab International Airport", "ar": "مطار برج العرب الدولي"},
      "body": {"en": "Alexandria, Egypt", "ar": "الإسكندرية، مصر"},
    },
    {
      "id": 15,
      "code": "SSH",
      "name": {"en": "Sharm El Sheikh International Airport", "ar": "مطار شرم الشيخ الدولي"},
      "body": {"en": "Sharm El Sheikh, Egypt", "ar": "شرم الشيخ، مصر"},
    },
    {
      "id": 16,
      "code": "AMM",
      "name": {"en": "Queen Alia International Airport", "ar": "مطار الملكة علياء الدولي"},
      "body": {"en": "Amman, Jordan", "ar": "عمّان، الأردن"},
    },
    {
      "id": 17,
      "code": "BEY",
      "name": {"en": "Beirut–Rafic Hariri International Airport", "ar": "مطار بيروت رفيق الحريري الدولي"},
      "body": {"en": "Beirut, Lebanon", "ar": "بيروت، لبنان"},
    },
    {
      "id": 18,
      "code": "IST",
      "name": {"en": "Istanbul Airport", "ar": "مطار إسطنبول"},
      "body": {"en": "Istanbul, Türkiye", "ar": "إسطنبول، تركيا"},
    },
    {
      "id": 19,
      "code": "SAW",
      "name": {"en": "Istanbul Sabiha Gökçen Airport", "ar": "مطار صبيحة كوكجن الدولي"},
      "body": {"en": "Istanbul, Türkiye", "ar": "إسطنبول، تركيا"},
    },
    {
      "id": 20,
      "code": "LHR",
      "name": {"en": "London Heathrow Airport", "ar": "مطار لندن هيثرو"},
      "body": {"en": "London, United Kingdom", "ar": "لندن، المملكة المتحدة"},
    },
    {
      "id": 21,
      "code": "LGW",
      "name": {"en": "London Gatwick Airport", "ar": "مطار لندن غاتويك"},
      "body": {"en": "London, United Kingdom", "ar": "لندن، المملكة المتحدة"},
    },
    {
      "id": 22,
      "code": "STN",
      "name": {"en": "London Stansted Airport", "ar": "مطار لندن ستانستد"},
      "body": {"en": "London, United Kingdom", "ar": "لندن، المملكة المتحدة"},
    },
    {
      "id": 23,
      "code": "LTN",
      "name": {"en": "London Luton Airport", "ar": "مطار لندن لوتن"},
      "body": {"en": "Luton, United Kingdom", "ar": "لوتن، المملكة المتحدة"},
    },
    {
      "id": 24,
      "code": "LCY",
      "name": {"en": "London City Airport", "ar": "مطار لندن سيتي"},
      "body": {"en": "London, United Kingdom", "ar": "لندن، المملكة المتحدة"},
    },
    {
      "id": 25,
      "code": "MAN",
      "name": {"en": "Manchester Airport", "ar": "مطار مانشستر"},
      "body": {"en": "Manchester, United Kingdom", "ar": "مانشستر، المملكة المتحدة"},
    },
    {
      "id": 26,
      "code": "CDG",
      "name": {"en": "Paris Charles de Gaulle Airport", "ar": "مطار باريس شارل ديغول"},
      "body": {"en": "Paris, France", "ar": "باريس، فرنسا"},
    },
    {
      "id": 27,
      "code": "ORY",
      "name": {"en": "Paris Orly Airport", "ar": "مطار باريس أورلي"},
      "body": {"en": "Paris, France", "ar": "باريس، فرنسا"},
    },
    {
      "id": 28,
      "code": "AMS",
      "name": {"en": "Amsterdam Schiphol Airport", "ar": "مطار أمستردام سخيبول"},
      "body": {"en": "Amsterdam, Netherlands", "ar": "أمستردام، هولندا"},
    },
    {
      "id": 29,
      "code": "FRA",
      "name": {"en": "Frankfurt Airport", "ar": "مطار فرانكفورت"},
      "body": {"en": "Frankfurt, Germany", "ar": "فرانكفورت، ألمانيا"},
    },
    {
      "id": 30,
      "code": "MUC",
      "name": {"en": "Munich Airport", "ar": "مطار ميونخ"},
      "body": {"en": "Munich, Germany", "ar": "ميونخ، ألمانيا"},
    },
    {
      "id": 31,
      "code": "BER",
      "name": {"en": "Berlin Brandenburg Airport", "ar": "مطار برلين براندنبورغ"},
      "body": {"en": "Berlin, Germany", "ar": "برلين، ألمانيا"},
    },
    {
      "id": 32,
      "code": "MAD",
      "name": {"en": "Adolfo Suárez Madrid–Barajas Airport", "ar": "مطار مدريد باراخاس"},
      "body": {"en": "Madrid, Spain", "ar": "مدريد، إسبانيا"},
    },
    {
      "id": 33,
      "code": "BCN",
      "name": {"en": "Barcelona–El Prat Airport", "ar": "مطار برشلونة إل برات"},
      "body": {"en": "Barcelona, Spain", "ar": "برشلونة، إسبانيا"},
    },
    {
      "id": 34,
      "code": "FCO",
      "name": {"en": "Rome Fiumicino Airport", "ar": "مطار روما فيوميتشينو"},
      "body": {"en": "Rome, Italy", "ar": "روما، إيطاليا"},
    },
    {
      "id": 35,
      "code": "MXP",
      "name": {"en": "Milan Malpensa Airport", "ar": "مطار ميلانو مالبينسا"},
      "body": {"en": "Milan, Italy", "ar": "ميلانو، إيطاليا"},
    },
    {
      "id": 36,
      "code": "ATH",
      "name": {"en": "Athens International Airport", "ar": "مطار أثينا الدولي"},
      "body": {"en": "Athens, Greece", "ar": "أثينا، اليونان"},
    },
    {
      "id": 37,
      "code": "ZRH",
      "name": {"en": "Zurich Airport", "ar": "مطار زيورخ"},
      "body": {"en": "Zurich, Switzerland", "ar": "زيورخ، سويسرا"},
    },
    {
      "id": 38,
      "code": "VIE",
      "name": {"en": "Vienna International Airport", "ar": "مطار فيينا الدولي"},
      "body": {"en": "Vienna, Austria", "ar": "فيينا، النمسا"},
    },
    {
      "id": 39,
      "code": "CPH",
      "name": {"en": "Copenhagen Airport", "ar": "مطار كوبنهاغن"},
      "body": {"en": "Copenhagen, Denmark", "ar": "كوبنهاغن، الدنمارك"},
    },
    {
      "id": 40,
      "code": "ARN",
      "name": {"en": "Stockholm Arlanda Airport", "ar": "مطار ستوكهولم آرلاندا"},
      "body": {"en": "Stockholm, Sweden", "ar": "ستوكهولم، السويد"},
    },
    {
      "id": 41,
      "code": "OSL",
      "name": {"en": "Oslo Gardermoen Airport", "ar": "مطار أوسلو غاردرموين"},
      "body": {"en": "Oslo, Norway", "ar": "أوسلو، النرويج"},
    },
    {
      "id": 42,
      "code": "HEL",
      "name": {"en": "Helsinki-Vantaa Airport", "ar": "مطار هلسنكي فانتا"},
      "body": {"en": "Helsinki, Finland", "ar": "هلسنكي، فنلندا"},
    },
    {
      "id": 43,
      "code": "JFK",
      "name": {"en": "John F. Kennedy International Airport", "ar": "مطار جون إف كينيدي الدولي"},
      "body": {"en": "New York, United States", "ar": "نيويورك، الولايات المتحدة"},
    },
    {
      "id": 44,
      "code": "EWR",
      "name": {"en": "Newark Liberty International Airport", "ar": "مطار نيوآرك ليبرتي الدولي"},
      "body": {"en": "Newark, United States", "ar": "نيوآرك، الولايات المتحدة"},
    },
    {
      "id": 45,
      "code": "LGA",
      "name": {"en": "LaGuardia Airport", "ar": "مطار لاغوارديا"},
      "body": {"en": "New York, United States", "ar": "نيويورك، الولايات المتحدة"},
    },
    {
      "id": 46,
      "code": "LAX",
      "name": {"en": "Los Angeles International Airport", "ar": "مطار لوس أنجلِس الدولي"},
      "body": {"en": "Los Angeles, United States", "ar": "لوس أنجلِس، الولايات المتحدة"},
    },
    {
      "id": 47,
      "code": "SFO",
      "name": {"en": "San Francisco International Airport", "ar": "مطار سان فرانسيسكو الدولي"},
      "body": {"en": "San Francisco, United States", "ar": "سان فرانسيسكو، الولايات المتحدة"},
    },
    {
      "id": 48,
      "code": "ORD",
      "name": {"en": "Chicago O'Hare International Airport", "ar": "مطار شيكاغو أوهير الدولي"},
      "body": {"en": "Chicago, United States", "ar": "شيكاغو، الولايات المتحدة"},
    },
    {
      "id": 49,
      "code": "ATL",
      "name": {"en": "Hartsfield–Jackson Atlanta International Airport", "ar": "مطار هارتسفيلد جاكسون أتلانتا الدولي"},
      "body": {"en": "Atlanta, United States", "ar": "أتلانتا، الولايات المتحدة"},
    },
    {
      "id": 50,
      "code": "DFW",
      "name": {"en": "Dallas/Fort Worth International Airport", "ar": "مطار دالاس فورت وورث الدولي"},
      "body": {"en": "Dallas–Fort Worth, United States", "ar": "دالاس - فورت وورث، الولايات المتحدة"},
    },
    {
      "id": 51,
      "code": "MIA",
      "name": {"en": "Miami International Airport", "ar": "مطار ميامي الدولي"},
      "body": {"en": "Miami, United States", "ar": "ميامي، الولايات المتحدة"},
    },
    {
      "id": 52,
      "code": "SEA",
      "name": {"en": "Seattle–Tacoma International Airport", "ar": "مطار سياتل تاكوما الدولي"},
      "body": {"en": "Seattle, United States", "ar": "سياتل، الولايات المتحدة"},
    },
    {
      "id": 53,
      "code": "BOS",
      "name": {"en": "Logan International Airport", "ar": "مطار لوغان الدولي"},
      "body": {"en": "Boston, United States", "ar": "بوسطن، الولايات المتحدة"},
    },
    {
      "id": 54,
      "code": "YYZ",
      "name": {"en": "Toronto Pearson International Airport", "ar": "مطار تورونتو بيرسون الدولي"},
      "body": {"en": "Toronto, Canada", "ar": "تورونتو، كندا"},
    },
    {
      "id": 55,
      "code": "YUL",
      "name": {"en": "Montréal–Trudeau International Airport", "ar": "مطار مونتريال بيير ترودو الدولي"},
      "body": {"en": "Montreal, Canada", "ar": "مونتريال، كندا"},
    },
    {
      "id": 56,
      "code": "YVR",
      "name": {"en": "Vancouver International Airport", "ar": "مطار فانكوفر الدولي"},
      "body": {"en": "Vancouver, Canada", "ar": "فانكوفر، كندا"},
    },
    {
      "id": 57,
      "code": "GRU",
      "name": {"en": "São Paulo–Guarulhos International Airport", "ar": "مطار ساو باولو غواروليوس الدولي"},
      "body": {"en": "São Paulo, Brazil", "ar": "ساو باولو، البرازيل"},
    },
    {
      "id": 58,
      "code": "GIG",
      "name": {"en": "Rio de Janeiro–Galeão International Airport", "ar": "مطار ريو دي جانيرو غاليانو الدولي"},
      "body": {"en": "Rio de Janeiro, Brazil", "ar": "ريو دي جانيرو، البرازيل"},
    },
    {
      "id": 59,
      "code": "HND",
      "name": {"en": "Tokyo Haneda Airport", "ar": "مطار طوكيو هانيدا"},
      "body": {"en": "Tokyo, Japan", "ar": "طوكيو، اليابان"},
    },
    {
      "id": 60,
      "code": "NRT",
      "name": {"en": "Tokyo Narita Airport", "ar": "مطار طوكيو ناريتا"},
      "body": {"en": "Tokyo, Japan", "ar": "طوكيو، اليابان"},
    },
    {
      "id": 61,
      "code": "ICN",
      "name": {"en": "Incheon International Airport", "ar": "مطار إنتشون الدولي"},
      "body": {"en": "Seoul, South Korea", "ar": "سيول، كوريا الجنوبية"},
    },
    {
      "id": 62,
      "code": "HKG",
      "name": {"en": "Hong Kong International Airport", "ar": "مطار هونغ كونغ الدولي"},
      "body": {"en": "Hong Kong, China", "ar": "هونغ كونغ، الصين"},
    },
    {
      "id": 63,
      "code": "SIN",
      "name": {"en": "Singapore Changi Airport", "ar": "مطار سنغافورة تشانغي"},
      "body": {"en": "Singapore", "ar": "سنغافورة"},
    },
    {
      "id": 64,
      "code": "KUL",
      "name": {"en": "Kuala Lumpur International Airport", "ar": "مطار كوالالمبور الدولي"},
      "body": {"en": "Kuala Lumpur, Malaysia", "ar": "كوالالمبور، ماليزيا"},
    },
    {
      "id": 65,
      "code": "BKK",
      "name": {"en": "Suvarnabhumi Airport", "ar": "مطار سوفارنابومي"},
      "body": {"en": "Bangkok, Thailand", "ar": "بانكوك، تايلاند"},
    },
    {
      "id": 66,
      "code": "HKT",
      "name": {"en": "Phuket International Airport", "ar": "مطار بوكيت الدولي"},
      "body": {"en": "Phuket, Thailand", "ar": "بوكيت، تايلاند"},
    },
    {
      "id": 67,
      "code": "SYD",
      "name": {"en": "Sydney Kingsford Smith Airport", "ar": "مطار سيدني كنغسفورد سميث"},
      "body": {"en": "Sydney, Australia", "ar": "سيدني، أستراليا"},
    },
    {
      "id": 68,
      "code": "MEL",
      "name": {"en": "Melbourne Airport", "ar": "مطار ملبورن"},
      "body": {"en": "Melbourne, Australia", "ar": "ملبورن، أستراليا"},
    },
    {
      "id": 69,
      "code": "AKL",
      "name": {"en": "Auckland Airport", "ar": "مطار أوكلاند"},
      "body": {"en": "Auckland, New Zealand", "ar": "أوكلاند، نيوزيلندا"},
    },
    {
      "id": 70,
      "code": "DEL",
      "name": {"en": "Indira Gandhi International Airport", "ar": "مطار إنديرا غاندي الدولي"},
      "body": {"en": "Delhi, India", "ar": "دلهي، الهند"},
    },
    {
      "id": 71,
      "code": "BOM",
      "name": {"en": "Chhatrapati Shivaji Maharaj International Airport", "ar": "مطار تشاتراباتي شيفاجي ماهاراج الدولي"},
      "body": {"en": "Mumbai, India", "ar": "مومباي، الهند"},
    },
  ];

  Future<List<Map<String, dynamic>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // تأخير بسيط
    final q = query.trim().toLowerCase();
    // if (q.isEmpty) return [];
    // البحث بالرمز أو الاسم أو الوصف
    final res = _data.where((element) {
      print("element: $element");
      final e = AirportModel.fromJson(element); 
      return e.code.toLowerCase().contains(q) ||
          e.name[AppVars.lang].toString().toLowerCase().contains(q) ||
          e.body[AppVars.lang].toString().toLowerCase().contains(q);
    }).toList();
    // حد أقصى (لإنقاص الحمل)
    print("res.take(100).toList(): ${res.take(100).toList().length}");
    return res.toList();
  }
}
