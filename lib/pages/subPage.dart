import 'package:afazer/widgets/InputSection.dart';
import 'package:afazer/widgets/TodoCounter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:afazer/models/item.dart';
import 'package:afazer/db_management/todoDatabase.dart';

var newTaskCtrl = TextEditingController();
var ptsCtrl = TextEditingController();

class SubPage extends StatefulWidget{
  String parent = '';
  int total_points = 0;
  final Future<Database> database;
  List<TodoItem> todo;

  SubPage({this.parent, this.total_points, this.database, this.todo});

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  Future<void> init_state() async {
      List<Map<String, dynamic>> map = await read_from_database(widget.database, widget.parent);
      var prefs = await SharedPreferences.getInstance();
      var points = prefs.getInt('points');
      setState(() {
        widget.todo = get_list_from_map(map);
        if (points == null) {
          widget.total_points = 0;
        } else {
          widget.total_points = points;
        }
        print("init_state()");
      });
  }

  Future<void> save() async {
    List<Map<String, dynamic>> map = await get_map_from_list(widget.todo, widget.parent);
    await save_to_database(widget.database, map);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', widget.total_points);
    print("save()");
    init_state();
  }

  Future<void> remove(int index) async {
    await remove_from_database(widget.database, widget.todo[index]);
    setState(() {
      widget.todo.removeAt(index);
    });
    save();
    print("remove()");
  }

  void add(){
    if(newTaskCtrl.text.isNotEmpty && ptsCtrl.text.isNotEmpty && int.tryParse(ptsCtrl.text) != null){
      setState(() {
        widget.todo.add(
          TodoItem(
            id: newTaskCtrl.text,
            points: int.parse(ptsCtrl.text),
            done: false,
            subtasks: List<TodoItem>(),
          ),
        );
        newTaskCtrl.clear();
        ptsCtrl.clear();
      });
      save();
    }
    print("add()");
  }

  _SubPageState(){
    init_state();
  }

  @override
  Widget build(BuildContext context) {
//    setState(() {
    init_state();
//    });
    return Scaffold(
      backgroundColor: Color(0xffFFFAC9),
      appBar: AppBar(
        title: Row(children: <Widget>[
          Expanded(child: Text(widget.parent, style: TextStyle(color: Colors.white),)),
          SizedBox(child: Text(widget.total_points.toString()+" pts.", style: TextStyle(color: Colors.white),), width: 100, ),
        ]
        ),
        backgroundColor: Color(0xff00CDFF),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              InputSection(newTaskCtrl, ptsCtrl),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.todo.length,
                  itemBuilder: (BuildContext context, int index){
                    final item = widget.todo[index];
                    return Dismissible(
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              value: item.done,
                              onChanged: (value) {
                                //setState(() {
                                  item.done = value;
                                  if(value == true){
                                    widget.total_points = widget.total_points + item.points;
                                  }else{
                                    widget.total_points = widget.total_points - item.points;
                                  }
                                //});
                                save();
                              }
                          ),
                          Expanded(
                            flex: 12,
                            child: GestureDetector(
                              child: Container(
                                child: Text(item.id),
                                padding: EdgeInsets.all(12.5),
                              ),
                              onTap: () async {
                                if(item.subtasks == null) {
                                  item.subtasks = new List<TodoItem>();
                                }
                                List aux = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SubPage(
                                          parent: item.id,
                                          total_points: widget.total_points,
                                          database: widget.database,
                                          todo: item.subtasks)
                                  ),
                                );
                                setState(() {
                                  if(aux != null){
                                    if(aux[0] != null) {
                                      item.subtasks = aux[0];
                                    }
                                    widget.total_points = aux[1];
                                  }
                                  save();
                                });
                              },
                            ),
                          ),
                          Spacer(flex: 1,),
                          if(item.subtasks.isNotEmpty) TodoCounter(item),
                          if(item.subtasks.isNotEmpty) Spacer(flex: 1,),
                          Text(item.points.toString()+" pts."),
                          Spacer(flex: 1,),
                        ],
                      ),
                      key: Key(item.id),
                      background: Container(
                        color: Colors.red,
                        child: Center(
                          child: Text("Excluir Tarefa", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      onDismissed: (direction){
                        remove(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              right: 2.0,
              bottom: 75.0,
              //alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: (){
                  Navigator.of(context).pop([widget.todo, widget.total_points]);
                  save();
                },
                child: Icon(Icons.done, color: Colors.white,),
                backgroundColor: Colors.green,

              ),
            ),
            Positioned(
              right: 2.0,
              bottom: 2.0,
              //alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: add,
                child: Icon(Icons.add, color: Colors.white,),
                backgroundColor: Colors.green,

              ),
            ),
          ]
      ),
    );
  }
}