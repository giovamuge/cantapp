import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String _title;
  final String _subtitle;
  final Widget _leading;
  final GestureTapCallback _onTap;

  const SettingsTile(
      {String title, Widget leading, String subtitle, GestureTapCallback onTap})
      : _title = title,
        _leading = leading,
        _subtitle = subtitle,
        _onTap = onTap;

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
          onTap: _onTap,
          leading: _leading,
          trailing: Icon(Icons.navigate_next)),
    );
  }
}
