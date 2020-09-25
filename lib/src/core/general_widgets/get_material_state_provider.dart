
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_state_provider..dart';
import '../platform/local_database/models/base_model.dart';
import '../platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import '../platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import '../platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import '../platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
MaterialStateProvider<BaseUploadingModel,BaseUploadingModel> getMaterialStateProvider(BuildContext context,{listen = true,@required String account_type}){
  bool isAcademic = account_type != 'schteachers' && account_type != 'schstudents';
  if(isAcademic){
    return Provider.of<MaterialStateProvider<CollegeUploadedPDF,CollegeUploadedVideo>>(context,listen:listen);
  }else{
    return Provider.of<MaterialStateProvider<SchoolUploadedPDF,SchoolUploadedVideo>>(context,listen:listen);
  }
}