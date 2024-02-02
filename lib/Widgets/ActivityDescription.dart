import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';

class ActivityDescription extends StatelessWidget {
  final Activity activity;

  ActivityDescription({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Title: ',
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: activity.getTitle(),
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Date: ',
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: activity.getDate(),
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Duration: ',
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${activity.getDuration()} h',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Type: ',
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: activity.getCategory(),
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(activity.getDescription()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
