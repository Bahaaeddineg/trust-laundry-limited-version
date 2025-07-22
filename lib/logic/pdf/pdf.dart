// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
// import '../id/id.dart';
// import '../../models/request.dart';
// import '../../models/sub.dart';
// import '../../ui/home/home_screen.dart';
// import '../../ui/order/order.dart';
// import '../../constants/strings.dart';
// import '../../models/app_user.dart';
// import '../../models/order.dart';

// import '../../models/my_address.dart';

// Future<bool> sendEmailWithPDF(
//     String userEmail, File pdfBytes, String orderId) async {
//   // Replace with your SMTP server configuration
//   final smtpServer = SmtpServer(
//     'smtp.gmail.com', // Replace with your SMTP host
//     port: 587, // Use 465 for SSL
//     username: 'trust.laundryy@gmail.com',
//     password:
//         await ApiKeyManager.decryptKey(g), // Use app password if 2FA is enabled
//   );

//   // Create email message
//   final message = Message()
//     ..from = const Address('trust.laundryy@gmail.com', 'Trust Laundry')
//     ..recipients.add(userEmail)
//     ..subject = 'Invoice for Your Order ${generateShortDisplayId(orderId)}}'
//     ..text = 'Attached is the invoice for your order.'
//     ..attachments = [
//       FileAttachment(pdfBytes,
//           contentType: "pdf",
//           fileName: "Invoice#${generateShortDisplayId(orderId)}.pdf")
//         ..location = Location.inline
//         ..cid = '<myimg@3.141>'
//     ];

//   try {
//     await send(message, smtpServer);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }

// Future<File> uint8ListToFile(Uint8List data, String filename) async {
//   final tempDir = await getTemporaryDirectory();
//   final filePath = '${tempDir.path}/$filename';
//   final file = File(filePath);
//   await file.writeAsBytes(data);
//   return file;
// }

// void sharePdf(File pdfFile) {
//   Share.shareXFiles([XFile(pdfFile.path)], text: 'Here is the order details.');
// }

// Future<void> handleOrderSharing(
//     UserOrder order, MyAddress address, AppUser user) async {
//   try {
//     // Generate the PDF
//     final pdfFile = await generatePdf(order, address, user);

//     // Share the PDF
//     sharePdf(pdfFile);
//   } catch (e) {
    
//   }
// }

// Future<void> handleDriverOrderSharing(request, AppUser user) async {
//   try {
//     // Generate the PDF
//     final pdfFile = await generateReqPdf(request, user);

//     // Share the PDF
//     sharePdf(pdfFile);
//   } catch (e) {
    
//   }
// }

// Future<File> generatePdf(
//     UserOrder order, MyAddress address, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Order Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Order date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Order ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.id ?? 'N/A'}\n'),
//                   pw.TextSpan(
//                     text: 'User ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.userId}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Order Status: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.status}\n'),
//                   pw.TextSpan(
//                     text: 'Fast Delivery: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.fast ? 'Yes' : 'No'}\n'),
//                   if (!order.fast)
//                     pw.TextSpan(
//                       text: 'Price: ',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   if (!order.fast)
//                     pw.TextSpan(text: '${order.price.toStringAsFixed(2)}KWD\n'),
//                 ],
//               ),
//             ),
//             if (order.fast)
//               pw.RichText(
//                 text: pw.TextSpan(
//                   children: [
//                     pw.TextSpan(
//                       text: 'Fast Price: ',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                     pw.TextSpan(
//                       text: '${order.fastPrice.toStringAsFixed(2)}KWD\n',
//                     ),
//                   ],
//                 ),
//               ),
//             pw.SizedBox(height: 10),
//             // Dates Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Pickup Date and Time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.pickUpDateAndTime}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 10),
//             // Payment Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Payed: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.didPay ? 'YES' : "NO"}\n'),
//                   pw.TextSpan(
//                     text: 'Payment Method: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(
//                       text:
//                           '${order.paymentMethod.toString().split('.').last}\n'),
//                 ],
//               ),
//             ),

//             pw.SizedBox(height: 10),
//             // Instructions Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Instructions: \n',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(
//                       text:
//                           '${order.instructions.isNotEmpty ? order.instructions : 'None'}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             // Address Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 text: 'Address Details\n',
//                 style:
//                     pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.Text(
//               address.isExact
//                   ? 'Google Maps exact position link:'
//                   : 'Area: ${address.area}\nCity: ${address.city}\nBoulevard: ${address.boulevard}\nBuilding: ${address.building}\nApartment Number: ${address.apartmentNum}',
//               style: pw.TextStyle(),
//             ),
//             if (address.isExact)
//               pw.UrlLink(
//                 destination:
//                     'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lng}',
//                 child: pw.Text(
//                   'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lng}',
//                   style: const pw.TextStyle(
//                     color: PdfColors.blue, // Make the link blue
//                     decoration: pw.TextDecoration
//                         .underline, // Add underline for a link appearance
//                   ),
//                 ),
//               ),

//             pw.SizedBox(height: 20),
//             // Items Section
//             pw.Text(
//               'Ordered Items',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 10),
//             pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: order.subItems.map((item) {
//                 return pw.Text(
//                   '- ${item.titleEn} (Quantity: ${item.quantity}, Price: ${item.price.toStringAsFixed(2)}KWD, Service type: ${item.laundryTypeEn})',
//                   style: pw.TextStyle(fontSize: 12),
//                 );
//               }).toList(),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/order_${order.id ?? 'unknown'}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }

// Future<File> generateReqPdf(Request request, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Driver Request Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Driver Request date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Order ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.id}\n'),
//                   pw.TextSpan(
//                     text: 'User ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.userId}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Driver Request Status: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.status}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             // Address Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 text: 'Address Details\n',
//                 style:
//                     pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.Text(
//               request.address.isExact
//                   ? 'Google Maps directions link:'
//                   : 'Area: ${request.address.area}\nCity: ${request.address.city}\nBoulevard: ${request.address.boulevard}\nBuilding: ${request.address.building}\nApartment Number: ${request.address.apartmentNum}',
//               style: pw.TextStyle(),
//             ),
//             if (request.address.isExact)
//               pw.UrlLink(
//                 destination:
//                     'https://www.google.com/maps/dir/?api=1&destination=${request.address.lat},${request.address.lng}',
//                 child: pw.Text(
//                   'https://www.google.com/maps/dir/?api=1&destination=${request.address.lat},${request.address.lng}',
//                   style: const pw.TextStyle(
//                     color: PdfColors.blue,
//                     decoration: pw.TextDecoration.underline,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/driver_request${request.id}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }

// Future<File> generateSubPdf(MySub sub, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Subscription Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Subscription date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                   pw.TextSpan(
//                     text: 'Balance: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.balance} KWD\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'You payed: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.pay} KWD\n'),
//                 ],
//               ),
//             ),
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'You got: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.get} KWD\n'),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/subscription${user.phoneNumber}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }

// Future<Uint8List> generateArabicReceiptPdf(
//     UserOrder order, MyAddress address, AppUser user, String email) async {
//   final pdf = pw.Document();
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);

//   // Load Arabic font
//   final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
//   final ttf = pw.Font.ttf(fontData);
//   final arabicStyle = pw.TextStyle(font: ttf, fontSize: 9);
//   final arabicBold =
//       pw.TextStyle(font: ttf, fontSize: 10, fontWeight: pw.FontWeight.bold);
//   final arabicHeader =
//       pw.TextStyle(font: ttf, fontSize: 11, fontWeight: pw.FontWeight.bold);
//   final arabicSmall = pw.TextStyle(font: ttf, fontSize: 7);
//   final englishStyle = pw.TextStyle(fontSize: 9);

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       margin: pw.EdgeInsets.all(12),
//       build: (pw.Context context) {
//         return pw.Directionality(
//           textDirection: pw.TextDirection.rtl,
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Image(logoImage, height: 36),
//               pw.Text('مصبغة ترست', style: arabicHeader),
//               pw.Text('Trust Laundry', style: englishStyle),
//               pw.Text('أندلس، الأندلس', style: arabicStyle),

//               pw.Divider(thickness: 0.5),
//               // Order Info
//               pw.Container(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Text('بيانات الطلب / Order Information',
//                     style: arabicHeader),
//               ),
//               pw.Wrap(
//                 alignment: pw.WrapAlignment.spaceBetween,
//                 spacing: 8,
//                 runSpacing: 0,
//                 children: [
//                   boldLabelValue(
//                       'رقم الطلب: ',
//                       generateShortDisplayId(order.id ?? ""),
//                       arabicBold,
//                       arabicStyle),
//                   boldLabelValue(
//                       'التاريخ: ',
//                       order.timeStamp.toDate().toString().substring(0, 16),
//                       arabicBold,
//                       arabicStyle),
//                   boldLabelValue('دفع: ', order.didPay ? 'نعم' : 'لا',
//                       arabicBold, arabicStyle),
//                   boldLabelValue(
//                       'طريقة الدفع: ',
//                       order.paymentMethod == UserPaymentMethod.cash
//                           ? 'نقدي'
//                           : 'أونلاين',
//                       arabicBold,
//                       arabicStyle),
//                   boldLabelValue('نوع الخدمة: ', order.fast ? 'مستعجل' : 'عادي',
//                       arabicBold, arabicStyle),
//                   order.fast
//                       ? boldLabelValue('سعر مستعجل: ',
//                           order.fastPrice.toString(), arabicBold, arabicStyle)
//                       : boldLabelValue('سعر عادي: ', order.price.toString(),
//                           arabicBold, arabicStyle),
//                   boldLabelValue('تاريخ استلام الأغراض: ',
//                       order.pickUpDateAndTime, arabicBold, arabicStyle),
//                 ],
//               ),
//               // Customer Info
//               pw.Container(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Text('العميل / Customer', style: arabicHeader),
//               ),
//               pw.Wrap(
//                 alignment: pw.WrapAlignment.spaceBetween,
//                 spacing: 8,
//                 runSpacing: 0,
//                 children: [
//                   boldLabelValue(
//                       ' البريدالالكتروني: ', email, arabicBold, arabicStyle),
//                   boldLabelValue('رقم الهاتف: ', user.phoneNumber, arabicBold,
//                       arabicStyle),
//                   boldLabelValue('الرصيد: ', (user.balance ?? '').toString(),
//                       arabicBold, arabicStyle),
//                   if (user.joinedAt != null)
//                     boldLabelValue(
//                         'تاريخ الانضمام: ',
//                         user.joinedAt!.toString().substring(0, 16),
//                         arabicBold,
//                         arabicStyle),
//                 ],
//               ),
//               // Address Info
//               pw.Container(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Text('عنوان العميل / Address', style: arabicHeader),
//               ),
//               pw.Wrap(
//                 alignment: pw.WrapAlignment.spaceBetween,
//                 spacing: 8,
//                 runSpacing: 0,
//                 children: [
//                   boldLabelValue('عنوان / Title', address.addressTitle,
//                       arabicBold, arabicStyle),
//                   if (address.area != null)
//                     boldLabelValue(
//                         'منطقة: ', address.area!, arabicBold, arabicStyle),
//                   if (address.city != null)
//                     boldLabelValue(
//                         'مدينة: ', address.city!, arabicBold, arabicStyle),
//                   if (address.boulevard != null)
//                     boldLabelValue(
//                         'جادة : ', address.boulevard!, arabicBold, arabicStyle),
//                   if (address.street != null)
//                     boldLabelValue(
//                         'شارع: ', address.street!, arabicBold, arabicStyle),
//                   if (address.building != null)
//                     boldLabelValue(
//                         'مبنى: ', address.building!, arabicBold, arabicStyle),
//                   if (address.apartmentNum != null)
//                     boldLabelValue('شقة: ', address.apartmentNum!, arabicBold,
//                         arabicStyle),
//                 ],
//               ),
//               if (address.isExact)
//                 pw.UrlLink(
//                   destination:
//                       'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lng}',
//                   child: pw.Text('فتح العنوان على الخريطة / Open In Maps',
//                       style: arabicSmall.copyWith(
//                           color: PdfColors.blue,
//                           decoration: pw.TextDecoration.underline)),
//                 ),
//               // Instructions
//               pw.Container(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Text('تعليمات خاصة / Instructions:',
//                     style: arabicHeader),
//               ),
//               pw.Text(order.instructions, style: arabicStyle),
//               // Items Table
//               pw.Container(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Text('تفاصيل الطلب / Order Details',
//                     style: arabicHeader),
//               ),
//               pw.Table(
//                 border: pw.TableBorder.all(width: 0.5),
//                 defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//                 children: [
//                   pw.TableRow(
//                     children: [
//                       pw.Center(child: pw.Text('الصنف)', style: arabicBold)),
//                       pw.Center(
//                           child: pw.Text('نوع الخدمة', style: arabicBold)),
//                       pw.Center(
//                           child: pw.Text(order.fast ? 'مستعجل' : 'عادي',
//                               style: arabicBold)),
//                       pw.Center(child: pw.Text('عدد', style: arabicBold)),
//                       pw.Center(child: pw.Text('الإجمالي', style: arabicBold)),
//                     ],
//                   ),
//                   ...order.subItems.map((item) => pw.TableRow(
//                         children: [
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.symmetric(
//                                 horizontal: 1, vertical: 0),
//                             child: pw.Text(item.titleAr, style: arabicStyle),
//                           ),
//                           pw.Center(
//                               child: pw.Text(item.laundryTypeAr ?? '',
//                                   style: arabicStyle)),
//                           pw.Center(
//                               child: pw.Text(
//                                   order.fast
//                                       ? item.priceFast.toString()
//                                       : item.price.toString(),
//                                   style: englishStyle)),
//                           pw.Center(
//                               child: pw.Text(item.quantity.toString(),
//                                   style: englishStyle)),
//                           pw.Center(
//                               child: pw.Text(
//                                   (item.price * item.quantity)
//                                       .toStringAsFixed(3),
//                                   style: englishStyle)),
//                         ],
//                       )),
//                 ],
//               ),
//               // Totals
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('الإجمالي / Total:', style: arabicBold),
//                   pw.Text(
//                       order.fast
//                           ? order.fastPrice.toStringAsFixed(3)
//                           : order.price.toStringAsFixed(3),
//                       style: arabicBold),
//                 ],
//               ),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('عدد القطع:', style: arabicBold),
//                   pw.Text(
//                       order.subItems
//                           .fold<int>(
//                               0, (sum, item) => sum + (item.quantity ?? 1))
//                           .toString(),
//                       style: arabicBold),
//                 ],
//               ),
//               pw.Divider(thickness: 0.5),
//               pw.Text(
//                   'ملاحظة: في حالة الفقد أو التلف المصبغة غير مسؤولة عن القطعة الغير مطالبة بعد التسليم. 30 يوم من تاريخ الاستلام.',
//                   style: arabicSmall),
//             ],
//           ),
//         );
//       },
//     ),
//   );
//   return pdf.save();
// }


// // Helper for bold label + regular value
// pw.Widget boldLabelValue(String label, String value, pw.TextStyle labelStyle,
//     pw.TextStyle valueStyle) {
//   return pw.RichText(
//     text: pw.TextSpan(
//       children: [
//         pw.TextSpan(text: label, style: labelStyle),
//         pw.TextSpan(text: value, style: valueStyle),
//       ],
//     ),
//   );
// }
