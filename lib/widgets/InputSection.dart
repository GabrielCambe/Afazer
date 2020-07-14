import 'package:flutter/material.dart';
class InputSection extends StatelessWidget{
  TextEditingController newTaskCtrl;
  TextEditingController ptsCtrl;

  InputSection(TextEditingController newTaskCtrl, TextEditingController ptsCtrl){
    this.newTaskCtrl = newTaskCtrl;
    this.ptsCtrl = ptsCtrl;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              controller: newTaskCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3),),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                icon: Icon(Icons.add_box),
                hintText: "Título",
              ),
            ),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              controller: ptsCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3),),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                icon: Icon(Icons.add_box),
                hintText: "Pontos",
              ),
            ),
          ),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
