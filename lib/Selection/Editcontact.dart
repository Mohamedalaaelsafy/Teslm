import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tslm/Size/size.dart';
import 'package:tslm/sqflite/dbhelper.dart';
import 'package:tslm/sqflite/sqlmode.dart';

class EditContact extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  EditContact(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return EditContactState(this.note, this.appBarTitle);
  }
}

class EditContactState extends State<EditContact> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  EditContactState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
        ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () {
        // Write some code to control things, when user press Back navigation button in device navigationBar
        moveToLastScreen();
        return null;
      },
      child: Scaffold(
        backgroundColor:Color(0xffe8eff7),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('assets/logo_full.png'))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                child: Center(
                    child: Divider(
              height: 20,
              indent: 40,
              endIndent: 40,
              thickness: 1,
            ))),
            SizedBox(
              height: 90,
            ),
            Center(
                child: Text('Contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff27186),
                    ))),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
              height: _height * 5,
                width: _width * 80,
                child: TextFormField(
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  style: new TextStyle(color: Colors.black),
                 
                  controller: titleController,
                  obscureText: false,
                  decoration: InputDecoration(
                     contentPadding: EdgeInsets.only(top: _height , left: _width*3),
                    filled: true,
                    hintStyle: TextStyle(
                      //  fontSize: 13,
                        color: Color(0xFFbdc6cf),
                        fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xff3979b7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Container(
                height: _height * 5,
                width: _width * 80,
                child: TextFormField(
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateDescription();
                  },
                  style: new TextStyle(color: Colors.black),
                 
                  keyboardType: TextInputType.number,
                  controller: descriptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                     contentPadding: EdgeInsets.only(top: _height , left: _width*3), 
                    filled: true,
                    hintStyle: TextStyle(
                       // fontSize: 13,
                        color: Color(0xFFbdc6cf),
                        fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    hintText: 'phoneNumber',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xff3979b7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    
                width: _width * 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _getdata();
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Center(
                  child: Container(
                    width: _width*30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditContact());

                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
