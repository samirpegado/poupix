import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class ProfileOption extends StatelessWidget {
  final String label;
  final Icon icone;
  final Function? action;
  final Color? labelColor;
  const ProfileOption(
      {super.key, required this.label, required this.icone, this.action, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (action != null) await action!();
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              icone,
              SizedBox(width: 16),
              Expanded(
                child: Text(label,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(color: labelColor )),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.black1,
                size: 24,
              ),
            ]),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.alternate,
          ),
        ],
      ),
    );
  }
}
