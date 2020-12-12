import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/load_more_widget_for_pagination.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/no_materials_yet_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import 'package:provider/provider.dart';

import '../../../../shared/material_holding_widgets/college/college_pdf_holding_widget.dart';
import '../../../../shared/material_holding_widgets/school/school_pdf_holding_widget.dart';
import '../state_provider/saved_pdf_state_provider.dart';

class SavedPDFList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MySavedPDFStateProvider savedPDFStateProvider = Provider.of<MySavedPDFStateProvider>(context, listen: false);
    return Scaffold(
      key: savedPDFStateProvider.scaffoldKey,
      body: Selector<MySavedPDFStateProvider, List<bool>>(
        selector: (context, stateProvider) => [
          stateProvider.isFetching,
          stateProvider.failureOfInitialFetch,
        ],
        builder: (context, data, _) {
          if (data.first) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (data.last) {
            return FailedToLoadMaterialsWidget(
              onReload: savedPDFStateProvider.fetchInitialData,
              message: 'Failed to load saved lectures',
              onReloadOnly: true,
            );
          }

          if (savedPDFStateProvider.materials.isEmpty) {
            return NoMaterialYetWidget(
              onReload: savedPDFStateProvider.fetchInitialData,
              materialName: 'saved lectures',
            );
          }

          return Selector<MySavedPDFStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.materials.length,
            builder: (context, count, _) => ListView.builder(
              itemCount: count,
              itemBuilder: (context, pos) {
                if (pos == count - 1 && count >= 7) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      savedPDFStateProvider.isAcademic
                          ? CollegePDFHoldingWidget<MySavedPDFStateProvider>(pos: pos)
                          : SchoolPDFHoldingWidget<MySavedPDFStateProvider>(pos: pos),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      LoadMoreWidget<MySavedPDFStateProvider>(
                        onLoadMore: savedPDFStateProvider.fetchForPagination,
                      ),
                    ],
                  );
                }

                return savedPDFStateProvider.isAcademic
                    ? CollegePDFHoldingWidget<MySavedPDFStateProvider>(
                        pos: pos,
                      )
                    : SchoolPDFHoldingWidget<MySavedPDFStateProvider>(pos: pos);
              },
            ),
          );
        },
      ),
    );
  }
}
