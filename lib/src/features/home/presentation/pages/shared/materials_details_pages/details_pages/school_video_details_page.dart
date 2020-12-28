import 'package:flutter/material.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolVideoDetailsPage<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolVideoDetailsPage({@required this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('School video details page '),
      ),
    );
  }
}
