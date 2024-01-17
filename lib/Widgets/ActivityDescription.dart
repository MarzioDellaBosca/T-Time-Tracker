import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';

class ActivityDescription extends StatefulWidget {
  final Activity activity;

  ActivityDescription({required this.activity});

  @override
  _ActivityDescriptionState createState() => _ActivityDescriptionState();
}

class _ActivityDescriptionState extends State<ActivityDescription> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 1.0, // Occupa tutta la larghezza
        //heightFactor: 0.8, // Occupa tutta l'altezza
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
                              text: widget.activity.getTitle(),
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
                              text: widget.activity.getDate(),
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
                              text: '${widget.activity.getDuration()} h',
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
                              text: widget.activity.getCategory(),
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(widget.activity.getDescription()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
