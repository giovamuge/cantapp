import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String _title;
  final String _subtitle;
  final Widget _leading;
  final ValueChanged<bool> _onChanged;
  final bool _switchValue;

  const SettingsSwitchTile(
      {String title,
      Widget leading,
      String subtitle,
      ValueChanged<bool> onChanged,
      bool switchValue})
      : _title = title,
        _leading = leading,
        _subtitle = subtitle,
        _onChanged = onChanged,
        _switchValue = switchValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        title: Text(_title ?? ""),
        subtitle: Text(
          _subtitle ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: _leading,
        trailing: Platform.isIOS
            ? CupertinoSwitch(
                value: _switchValue ?? null,
                onChanged: _onChanged ?? () => {},
              )
            : Switch(
                value: _switchValue ?? null,
                onChanged: _onChanged ?? () => {},
              ),
      ),
    );
  }
}
