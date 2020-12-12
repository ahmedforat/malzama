import 'package:flutter/material.dart';

import '../../../lectures_pages/state/material_state_repo.dart';

class SchoolPDFDetailsPage<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolPDFDetailsPage({@required this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('School PDF details page'),
      ),
    );
  }
}
