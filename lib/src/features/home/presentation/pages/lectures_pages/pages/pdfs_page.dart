import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../shared/accessory_widgets/load_more_widget_for_pagination.dart';
import '../../shared/accessory_widgets/no_materials_yet_widget.dart';
import '../../shared/material_holding_widgets/college/college_pdf_holding_widget.dart';
import '../../shared/material_holding_widgets/school/school_pdf_holding_widget.dart';
import '../../shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import '../state/pdf_state_provider.dart';

class DisplayHomePage extends StatelessWidget {
  const DisplayHomePage();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          print(pdfState.materials.last.id);
        },
      ),
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
              return FailedToLoadMaterialsWidget(
                onReload: pdfState.fetchInitialData,
                message: 'Failed to Load lectures',
              );
            }

            if (pdfState.materials.isEmpty) {
              return NoMaterialYetWidget(
                materialName: 'Lectures',
                onReload: pdfState.fetchInitialData,
              );
            }
            return _LecturesList();
          }),
    );
  }
}

class _LecturesList extends StatelessWidget {
  const _LecturesList();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    PDFStateProvider pdfStateProvider = Provider.of<PDFStateProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        await locator<PDFStateProvider>().onRefresh();
      },
      child: Selector<PDFStateProvider, int>(
        selector: (context, stateProvider) => stateProvider.materials.length,
        builder: (context, count, _) => ListView.builder(
          itemCount: count,
          itemBuilder: (context, pos) {
            if (pos == count - 1 && count >= 10) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  pdfStateProvider.isAcademic
                      ? CollegePDFHoldingWidget<PDFStateProvider>(pos: pos)
                      : SchoolPDFHoldingWidget<PDFStateProvider>(pos: pos),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  LoadMoreWidget<PDFStateProvider>(
                    onLoadMore: pdfStateProvider.fetchForPagination,
                  ),
                ],
              );
            }

            return pdfStateProvider.isAcademic
                ? CollegePDFHoldingWidget<PDFStateProvider>(
                    pos: pos,
                  )
                : SchoolPDFHoldingWidget<PDFStateProvider>(pos: pos);
          },
        ),
      ),
    );
  }
}
