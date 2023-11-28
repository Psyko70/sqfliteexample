import 'package:flutter/material.dart';
import 'package:untitled3/database_helper.dart';
import 'package:untitled3/note.dart';

import 'User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController NameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController IdController = TextEditingController();
  TextEditingController IndexController = TextEditingController();
  TextEditingController SearchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formSearch = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  User futureUser = User(id: "", name: "");
  void _loadrecords() async{
      User UserDetails = await dbHelper.fetchAlbum();
      setState(() {
        futureUser = UserDetails;
      });
  }


  void _loadNotes() async {
    List<Note> notes = await dbHelper.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _search(String query) async{
    List<Note> notes = await dbHelper.FindAllNotes(query);
    setState(() {
      _notes = notes;
    });  
  }

  void _addNote() async {
    Note newNote = Note(
      name: NameController.text,
      description: DescriptionController.text,
    );
    int id = await dbHelper.insert(newNote);
    setState(() {
      newNote.id = id;
      _notes.add(newNote);
    });
  }

  void Edit_node(int index){
    NameController.text = _notes[index].name;
    DescriptionController.text = _notes[index].description;
    IdController.text = _notes[index].id.toString();
    IndexController.text = index.toString();
  }

  void _updateNote() async {
    int index = int.parse(IndexController.text.toString());
    int id = int.parse(IdController.text.toString());
    Note updatedNote = Note(
      id: id,
      name: NameController.text,
      description: DescriptionController.text,
    );
    await dbHelper.update(updatedNote);
    setState(() {
      _notes[index] = updatedNote;
    });
  }

  void _deleteNote(int index, int? id) async {
    await dbHelper.delete(id!);
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SQLite CRUD'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("ID: ${futureUser.id} ${futureUser.name}"),
                Form(
                  key: _formSearch,
                  child:
                  TextFormField(
                    controller: SearchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Type Name of your note",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if(_formSearch.currentState!.validate()){
                            _search(SearchController.text);
                          }
                        },
                        icon: Icon(Icons.search),
                      )
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Field Required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: NameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Type title of your note",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Field Required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: DescriptionController,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Type title of your note",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Field Required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String x = IndexController.text;
                              _updateNote();
                            }
                          },
                          child: Text("Update")
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: _notes.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.black12,
                      title: Text(_notes[index].name),
                      subtitle: Text(_notes[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Edit_node(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteNote(index, _notes[index].id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if(_formKey.currentState!.validate()){
            _addNote();
          }
        },
      ),
    );
  }
}
