import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/widgets/college_pdf_holding_widget.dart';
import 'package:provider/provider.dart';


import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import '../state/pdf_state_provider.dart';
import '../widgets/school_pdf_holding_widget.dart';

class DisplayHomePage extends StatelessWidget {
  const DisplayHomePage();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: Selector<PDFStateProvider, List<bool>>(
          selector: (context, stateProvider) => [
                stateProvider.isAcademic,
                stateProvider.isFetching,
                stateProvider.failureOfInitialFetch,
              ],
          builder: (context, data, __) {
            if (data[0] == null || data[1]) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (data[2]) {
              return FailedToLoadMaterialsWidget(isVideo: false);
            }

            if (pdfState.materials.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {

                  await locator<PDFStateProvider>().onRefresh();
                },
                child: Container(
                  child: Center(
                    child: Text('No PDF lectures to show'),
                  ),
                ),
              );
            }
            return _buildLecturesList(context);
          }),
    );
  }
}

Widget _buildLecturesList(BuildContext context) => RefreshIndicator(
      onRefresh: () async {

        await locator<PDFStateProvider>().onRefresh();
      },
      child: ListView.builder(
        itemCount: locator<PDFStateProvider>().materials.length,
        itemBuilder: (context, pos) => locator<PDFStateProvider>().isAcademic ? CollegePDFHoldingWidget(
          pos: pos,
        ) : SchoolPDFHoldingWidget(pos: pos),
      ),
    );
