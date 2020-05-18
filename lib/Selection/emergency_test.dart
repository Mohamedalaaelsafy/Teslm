import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tslm/sqflite/dbhelper.dart';
import 'package:tslm/sqflite/sqlmode.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Editcontact.dart';
import 'package:tslm/Size/size.dart';

class EmergencyText extends StatefulWidget {
  @override
  _EmergencyTextState createState() => _EmergencyTextState();
}

class _EmergencyTextState extends State<EmergencyText> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xffe8eff7),
      body: Padding(
        padding: EdgeInsets.only(
          top: _height * 8,
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: _width * 85),
                child: GestureDetector(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: ExactAssetImage('assets/icons-10.png'),
                    )),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: _width * 8),
                    child: Text(
                      'Emergency Contact',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff3979b7),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width * 42),
                    child: Image.asset(
                      'assets/icons-09.png',
                      scale: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: _width,
                  ),
                  Image.asset(
                    'assets/icons-07.png',
                    scale: 12.0,
                  ),
                  SizedBox(
                    width: _width,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: _width * 6),
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/icons-08.png',
                          scale: 12.0,
                        ),
                        onTap: () {
                          debugPrint('FAB clicked');
                          navigateToDetail(Note('', '', 2), 'Add Note');
                        },
                      ),
                    ),
                  )
                ],
              ),
              Center(
                child: Container(
                  width: _width * 95,

                  //color: Colors.transparent,
                  height: _height * 55,
                  child:
                      //getNoteListView(),
                      AnimationLimiter(
                    child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                                child: Column(
                              children: <Widget>[
                                Container(
                                  height: _height * 6,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Container(
                                      child: ListTile(
                                        leading: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: ExactAssetImage(
                                                'assets/—Pngtree—business white shirt white-collar male_4154888.png'),
                                          ),
                                        ),
                                        title: Text(
                                          this.noteList[index].title,
                                          style: TextStyle(
                                              color: Color(0xff3979b7)),
                                        ),
                                        subtitle: Text(
                                            this.noteList[index].description,
                                            style: TextStyle(
                                                color: Color(0xff3979b7))),
                                        trailing: GestureDetector(
                                          child: Image.asset(
                                            'assets/icons-06.png',
                                            scale: 7,
                                          ),
                                          onTap: () {
                                            var call = this
                                                .noteList[index]
                                                .description;
                                            launch("tel://$call");
                                          },
                                        ),
                                        onTap: () {
                                          debugPrint("ListTile Tapped");
                                          navigateToDetail(this.noteList[index],
                                              'Edit Note');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView getNoteListView() {
    // TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: ExactAssetImage(
                          'assets/—Pngtree—business white shirt white-collar male_4154888.png'),
                    ),
                    title: Text("${this.noteList[position].title}",
                        style: TextStyle(color: Color(0xff3979b7c))),
                    subtitle: Text(
                      "${this.noteList[position].description}",
                      style: TextStyle(color: Color(0xff3979b7c)),
                    ),
                    trailing: GestureDetector(
                      child: Image.asset(
                        'assets/icons-06.png',
                        scale: 7,
                      ),
                      onTap: () {
                        var call = this.noteList[position].description;
                        launch("tel://$call");
                      },
                    ),
                    onTap: () {
                      debugPrint("ListTile Tapped");
                      navigateToDetail(this.noteList[position], 'Edit Note');
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditContact(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
