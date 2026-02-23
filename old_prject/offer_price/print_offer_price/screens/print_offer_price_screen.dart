import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/authentication/profile/presentation/blocs/profile_bloc.dart';
import 'package:fatoorahapp/feature/invoice_setting/presentation/blocs/invoice_setting_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/invoice_section/print_offer_price_admin_section.dart';
import 'package:fatoorahapp/feature/print_invoice_screen/widget/print_invoice_spacer_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/blocs/offer_price_details_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/clients_section/print_offer_price_client_section.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/invoice_section/print_offer_price_footer_section.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/invoice_section/print_offer_price_header_section.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/payment_section/print_offer_price_payment_section.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/product_section/print_offer_price_products_section.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/widgets/summary_section/print_offer_price_price_details_section.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/app_bar_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/button_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:fatoorahapp/widgets/ui_states/not_found_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_internet_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PrintOfferPriceScreen extends StatefulWidget {
  final String uuid;
  final bool? fromHome;

  PrintOfferPriceScreen({super.key, required this.uuid, this.fromHome = false});

  @override
  State<PrintOfferPriceScreen> createState() => _PrintOfferPriceScreenState();
}

class _PrintOfferPriceScreenState extends State<PrintOfferPriceScreen> {
  @override
  void initState() {
    if ((context.read<ProfileBloc>().state is ProfileErrorState)) {
      context.read<ProfileBloc>().add(ProfileSubmitted());
    }
    context.read<OfferPriceDetailsBloc>().add(
      GetOfferPriceDetailsEvent(offerPriceId: widget.uuid),
    );
    super.initState();
  }

  final GlobalKey _invoiceContentKey = GlobalKey();

  Future<Uint8List?> capturePng() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      RenderRepaintBoundary boundary =
          _invoiceContentKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null && pngBytes.isNotEmpty) {
        print('Image captured successfully: ${pngBytes.length} bytes');
      } else {
        print('Failed to capture image data');
      }

      return pngBytes;
    } catch (e) {
      print('Error capturing offer price: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pushNamed(Routes.offerPriceRoute);
        return false;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return profileState is ProfileLoadingState
              ? const Scaffold(
                  body: Center(child: CustomCircularProgressIndicator()),
                )
              : profileState is ProfileErrorState
              ? Scaffold(
                  body: ErrorState(
                    onPressed: () {
                      context.read<ProfileBloc>().add(ProfileSubmitted());
                    },
                  ),
                )
              : profileState is ProfileSuccessState
              ? BlocBuilder<OfferPriceDetailsBloc, OfferPriceDetailsState>(
                  builder: (context, state) {
                    return state is OfferPriceDetailsLoading
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            body: const Center(
                              child: CustomCircularProgressIndicator(),
                            ),
                          )
                        : state is OfferPriceDetailsNotFoundState
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            body: NotFoundState(
                              onPressed: () {
                                context.read<OfferPriceDetailsBloc>().add(
                                  GetOfferPriceDetailsEvent(
                                    offerPriceId: widget.uuid,
                                  ),
                                );
                              },
                            ),
                          )
                        : state is OfferPriceDetailsNoInternetState
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            appBar: CustomAppBar(
                              onBackPressed: () {
                                context.pushNamed(Routes.offerPriceRoute);
                              },
                              title: TranslationsController.instance
                                  .getTranslations()
                                  .quotationDetails,
                              withBack: true,
                              backgroundColor:
                                  ColorManager.secondaryScaffoldBackgroundColor,
                            ),
                            body: NoInternetState(
                              onPressed: () {
                                context.read<OfferPriceDetailsBloc>().add(
                                  GetOfferPriceDetailsEvent(
                                    offerPriceId: widget.uuid,
                                  ),
                                );
                              },
                            ),
                          )
                        : state is OfferPriceDetailsNoDataState
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            appBar: CustomAppBar(
                              onBackPressed: () {
                                context.pushNamed(Routes.offerPriceRoute);
                              },
                              title: TranslationsController.instance
                                  .getTranslations()
                                  .quotationDetails,
                              withBack: true,
                              backgroundColor:
                                  ColorManager.secondaryScaffoldBackgroundColor,
                            ),
                            body: NoDataState(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        : state is OfferPriceDetailsError
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            appBar: CustomAppBar(
                              onBackPressed: () {
                                context.pushNamed(Routes.offerPriceRoute);
                              },
                              title: TranslationsController.instance
                                  .getTranslations()
                                  .quotationDetails,
                              withBack: true,
                              backgroundColor:
                                  ColorManager.secondaryScaffoldBackgroundColor,
                            ),
                            body: ErrorState(
                              onPressed: () {
                                context.read<OfferPriceDetailsBloc>().add(
                                  GetOfferPriceDetailsEvent(
                                    offerPriceId: widget.uuid,
                                  ),
                                );
                              },
                            ),
                          )
                        : state is OfferPriceDetailsSuccess
                        ? Scaffold(
                            backgroundColor:
                                ColorManager.secondaryScaffoldBackgroundColor,
                            appBar: CustomAppBar(
                              onBackPressed: () {
                                context.pushNamed(Routes.offerPriceRoute);
                              },
                              title: TranslationsController.instance
                                  .getTranslations()
                                  .quotationDetails,
                              withBack: true,
                              backgroundColor:
                                  ColorManager.secondaryScaffoldBackgroundColor,
                            ),
                            bottomNavigationBar: Padding(
                              padding: EdgeInsetsDirectional.only(bottom: 30.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomElevatedButton(
                                    width: 150.w,
                                    onPressed: () async {
                                      // Show loading indicator
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            TranslationsController.instance
                                                .getTranslations()
                                                .preparingPrint,
                                          ),
                                        ),
                                      );

                                      final imageBytes = await capturePng();
                                      if (imageBytes != null) {
                                        await Printing.layoutPdf(
                                          format: PdfPageFormat.roll80,
                                          onLayout:
                                              (PdfPageFormat format) async {
                                                final pdf = pw.Document();
                                                final image = pw.MemoryImage(
                                                  imageBytes,
                                                );
                                                final pageFormat = format
                                                    .copyWith(
                                                      marginLeft: 0,
                                                      marginRight: 0,
                                                      marginTop: 0,
                                                      marginBottom: 0,
                                                    );

                                                pdf.addPage(
                                                  pw.Page(
                                                    pageFormat: pageFormat,
                                                    build:
                                                        (pw.Context context) {
                                                          return pw.Center(
                                                            child: pw.Image(
                                                              image,
                                                            ),
                                                          );
                                                        },
                                                  ),
                                                );
                                                return pdf.save();
                                              },
                                        );
                                      }
                                    },
                                    borderColor: ColorManager.transparent,
                                    elevation: 0,
                                    borderRadius: AppRadius.r100,
                                    text: TranslationsController.instance
                                        .getTranslations()
                                        .print,
                                    textColor: ColorManager.white,
                                  ),
                                  CustomElevatedButton(
                                    width: 150.w,
                                    onPressed: () async {
                                      // 1. Show a loading indicator
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            TranslationsController.instance
                                                .getTranslations()
                                                .preparingFile,
                                          ),
                                        ),
                                      );

                                      // 2. Capture the offer price widget as an image
                                      final imageBytes = await capturePng();
                                      if (imageBytes == null) {
                                        // Use mounted check before showing another SnackBar
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              TranslationsController.instance
                                                  .getTranslations()
                                                  .failedToPrepareReport,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 3. Create a PDF document from the captured image
                                      final pdf = pw.Document();
                                      final image = pw.MemoryImage(imageBytes);

                                      pdf.addPage(
                                        pw.Page(
                                          pageFormat: PdfPageFormat.a4,
                                          build: (pw.Context context) {
                                            // Center and fit the image on the A4 page
                                            return pw.Center(
                                              child: pw.Image(
                                                image,
                                                fit: pw.BoxFit.contain,
                                              ),
                                            );
                                          },
                                        ),
                                      );

                                      // 4. Save the generated PDF to a temporary file
                                      final pdfBytes = await pdf.save();
                                      final directory =
                                          await getTemporaryDirectory();
                                      final timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      final fileName =
                                          'offer_price_${state.offerPriceDetails.identificationNumber}_${state.offerPriceDetails.date}_$timestamp.pdf';
                                      final pdfFile = File(
                                        '${directory.path}/$fileName',
                                      );
                                      await pdfFile.writeAsBytes(pdfBytes);
                                      await Share.shareXFiles(
                                        [
                                          XFile(
                                            pdfFile.path,
                                            mimeType: 'application/pdf',
                                          ),
                                        ],
                                        text:
                                            "${state.offerPriceDetails.user.name} - ${state.offerPriceDetails.date} - ${state.offerPriceDetails.identificationNumber} - عرض السعر",
                                      );
                                    },
                                    borderColor: ColorManager.buttonColor,
                                    elevation: 0,
                                    color: ColorManager.transparent,
                                    borderRadius: AppRadius.r100,
                                    text: TranslationsController.instance
                                        .getTranslations()
                                        .share,
                                    icon: IconAssets.share,
                                    textColor: ColorManager.buttonColor,
                                  ),
                                ],
                              ),
                            ),
                            body: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.s5.h,
                                  horizontal: AppSize.s10.w,
                                ),
                                child: RepaintBoundary(
                                  key: _invoiceContentKey,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PrintOfferPriceHeaderSection(
                                          myInfo: profileState.profileEntity,
                                          data: state.offerPriceDetails,
                                        ),
                                        BlocBuilder<
                                          InvoiceSettingBloc,
                                          InvoiceSettingState
                                        >(
                                          builder: (context, invoiceSettingState) {
                                            return invoiceSettingState
                                                    is InvoiceSettingSuccessState
                                                ? invoiceSettingState
                                                              .invoiceSettingEntity
                                                              .showEmployee ==
                                                          1
                                                      ? printOfferPriceAdminWidget(
                                                          myInfo: profileState
                                                              .profileEntity,
                                                          data: state
                                                              .offerPriceDetails,
                                                        )
                                                      : Container()
                                                : Container();
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: AppSize.s3.h,
                                          ),
                                          child: PrintInvoiceSpacerWidget(),
                                        ),
                                        PrintOfferPriceClientSection(
                                          data: state.offerPriceDetails,
                                        ),
                                        PrintInvoiceSpacerWidget(),
                                        verticalSpace(height: AppHeight.s4),
                                        PrintOfferPriceProductsSection(
                                          offerPriceEntity:
                                              state.offerPriceDetails,
                                        ),
                                        verticalSpace(height: AppHeight.s8),
                                        PrintOfferPricePriceDetailsSection(
                                          data: state.offerPriceDetails,
                                        ),
                                        verticalSpace(height: AppHeight.s4),
                                        PrintInvoiceSpacerWidget(),
                                        verticalSpace(height: AppHeight.s4),
                                        PrintOfferPricePaymentSection(
                                          data: state.offerPriceDetails,
                                        ),
                                        PrintOfferPriceFooterSection(
                                          data: state.offerPriceDetails,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  },
                )
              : Container();
        },
      ),
    );
  }
}
