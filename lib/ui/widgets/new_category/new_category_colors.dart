import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/ui/strings/strings.dart';
import 'package:to_do/models/new_category.dart';
import 'package:to_do/ui/widgets/new_category/colors_list.dart';

class CategoryColor extends StatelessWidget {
  final Function onNextPressed;

  const CategoryColor({
    Key key,
    @required this.onNextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Strings s = Provider.of<Strings>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0.0),
          child: Consumer<NewCategory>(
            builder: (_, value, __) => Text(
              value.name,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Expanded(child: ColorsList()),
        Text(
          s.color,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Spacer(),
        Row(
          children: [
            SizedBox(width: 16.0),
            FlatButton(
              color: Colors.grey[400],
              child: Text(s.cancel),
              onPressed: () {
                Provider.of<NewCategory>(context, listen: false)
                    .addingNewCategoryCompleted = false;
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            FlatButton(
              autofocus: true,
              color: Colors.green,
              child: Text(s.next),
              onPressed: onNextPressed,
            ),
            SizedBox(width: 16.0),
          ],
        )
      ],
    );
  }
}
