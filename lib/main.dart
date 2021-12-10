import 'dart:collection';

import 'package:bisnisreview/SQLHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'mceasy',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> datas = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    datas = data;
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  Future<void> filterSearchResults(value) async {
    final data = await SQLHelper.getItems();
    if (value.isNotEmpty) {
      setState(() {
        _journals = data
            .where((nama) =>
        nama['nama'].toLowerCase().contains(value.toLowerCase()) ||
            nama['nomor_induk'].toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    } else {
      _journals = data;

    }
  }

  Future<void> filterJoin() async {
    final data = await SQLHelper.getItems();
    _journals =data;
    List<Map<String, dynamic>> _journalsCopy = List.of(_journals);

    setState(() {
      _journalsCopy.sort((a,b)=> a["tempGabung"].compareTo(b["tempGabung"]));
      _journals=[];
      _journals.clear();
      _journals =_journalsCopy.take(3).toList();

    });
  }

  Future<void> filterSearchCuti(value) async {
    final data = await SQLHelper.getItems();
    if (value.isNotEmpty) {
      setState(() {
        _journals = data
            .where((nama) =>
        nama['cuti'].toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    } else {
      _journals = data;

    }
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _noIndukController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _ttlController = TextEditingController();
  final TextEditingController _cutiController = TextEditingController();
  final TextEditingController _lamaController = TextEditingController();
  final TextEditingController _ketController = TextEditingController();
  final TextEditingController _joinController = TextEditingController();
  final TextEditingController _sisaController = TextEditingController();
  var DataTampung = "";
  var temCuti = "";
  var temGabung="";
  String  formatTtl="";
  String  formatJoin="";
  String  formatCuti="";

  var inputText = "";
  var _controller = TextEditingController();
  var index = 0;
  final DateFormat format = DateFormat("dd MMM yyyy");


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (_ttlController.text == "") {
      _ttlController.text = "Tanggal Lahir";
    }
    if (_joinController.text == "") {
      _joinController.text = "Tanggal Bergabung";
    }
    // if (id != null) {
    //   // id == null -> create new item
    //   // id != null -> update an existing item
    //   final existingJournal =
    //       _journals.firstWhere((element) => element['id'] == id);
    //   _noIndukController.text = existingJournal['nomor_induk'];
    //   _namaController.text = existingJournal['nama'];
    //   _alamatController.text = existingJournal['alamat'];
    //   _joinController.text = existingJournal['date'];
    //   _ttlController.text = existingJournal['ttl'];
    // }

    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 300,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(15)),
              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _noIndukController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Nomor Induk',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _namaController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Nama Lengkap',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _alamatController,
                            keyboardType: TextInputType.streetAddress,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Alamat',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialogPicker("ttl", "add", 0);
                                  // getListData();
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _ttlController.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 18,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialogPicker("gabung", "add", 0);
                                  // getListData();
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _joinController.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 18,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: () async {
                                _noIndukController.text = '';
                                _namaController.text = '';
                                _alamatController.text = '';
                                _ttlController.text = '';
                                _joinController.text = '';
                              },
                              child: Text(' Hapus ',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Save new journal
                                if (id == null) {
                                  await _addItem();
                                }

                                if (id != null) {
                                  await _updateItem(id);
                                }

                                // Clear the text fields
                                _noIndukController.text = '';
                                _namaController.text = '';
                                _alamatController.text = '';
                                _ttlController.text = '';
                                _joinController.text = '';



                                // Close the bottom sheet
                                Navigator.of(context).pop();
                              },
                              child: Text(id == null ? 'Tambah' : 'Simpan'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showFormUpdateCuti(int? id, String data) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _noIndukController.text = existingJournal['nomor_induk'];
      _namaController.text = existingJournal['nama'];
      _alamatController.text = existingJournal['alamat'];
      _ttlController.text = existingJournal['ttl'];
      _joinController.text = existingJournal['date'];
      _lamaController.text = existingJournal['lama_cuti'];
      _ketController.text = existingJournal['ket_cuti'];
      _sisaController.text = existingJournal['sisa'];
      if(existingJournal['cuti']=="cuti"){
        temCuti="cuti lebih";
      }

        if (data == "") {
          data = existingJournal['ttl_cuti'];
        }


      // data = existingJournal['ttl_cuti'];

      print(data);
    }

    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 300,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(15)),
              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _noIndukController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Nomor Induk',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _namaController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Nama Lengkap',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _alamatController,
                            keyboardType: TextInputType.streetAddress,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Alamat',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialogPicker("ttl", "update", id!);
                                  // getListData();
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _ttlController.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 18,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialogPicker("gabung", "update", id!);
                                  // getListData();
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _joinController.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 18,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialogPicker("cuti", "update", id!);
                                  // getListData();
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          data,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 18,
                                            height: 18,
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _lamaController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Lama Cuti',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _ketController,
                            keyboardType: TextInputType.streetAddress,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              // isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              border: OutlineInputBorder(),
                              hintText: 'Keterangan',
                              fillColor: Colors.purple,
                              focusColor: Colors.purple,
                              hoverColor: Colors.purple,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            )
                            // decoration: const InputDecoration(hintText: 'Alamat'),
                            ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {

                                if(_cutiController.text==""){

                                  if (id == null) {
                                    await _addItem();
                                  }

                                  if (id != null) {
                                    print("Save Normal");
                                    await _updateItem(id);
                                  }

                                  // Clear the text fields
                                  _noIndukController.text = '';
                                  _namaController.text = '';
                                  _alamatController.text = '';
                                  _ttlController.text = '';
                                  _cutiController.text = '';
                                  _lamaController.text = '';
                                  _ketController.text = '';
                                  _joinController.text = '';

                                  // Close the bottom sheet
                                  Navigator.of(context).pop();
                                }else{
                                  if(_lamaController.text=="" || _ketController.text==""){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Lama Cuti dan Keterangan Cuti tidak boleh kosong!",
                                          textAlign: TextAlign.center),
                                      duration: const Duration(seconds: 2),
                                    ));
                                  }else{
                                    int val = int.parse(_lamaController.text);
                                    int val2 = int.parse(_sisaController.text);
                                    if (val >= 5) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Maksimal Cuti hanya 4 hari kerja!",
                                            textAlign: TextAlign.center),
                                        duration: const Duration(seconds: 2),
                                      ));
                                    } else {
                                      if(val>val2){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Sisa Cuti Anda kurang dari "+val.toString(),
                                              textAlign: TextAlign.center),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      }else{
                                        int result= val2-val;
                                        _sisaController.text=result.toString();
                                        print ("Sisa Cuti Anda : "+result.toString());
                                        if (id == null) {
                                          await _addItem();
                                        }

                                        if (id != null) {
                                          print("Masuk Pak Eko");
                                          _cutiController.text = data;
                                          await _updateItem(id);
                                        }

                                        // Clear the text fields
                                        _noIndukController.text = '';
                                        _namaController.text = '';
                                        _alamatController.text = '';
                                        _ttlController.text = '';
                                        _cutiController.text = '';
                                        _lamaController.text = '';
                                        _ketController.text = '';
                                        _joinController.text = '';

                                        // Close the bottom sheet
                                        Navigator.of(context).pop();
                                      }

                                    }
                                  }

                                }




                              },
                              child: Text(id == null ? 'Tambah' : 'Simpan'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _noIndukController.text,
        _namaController.text,
        _alamatController.text,
        _ttlController.text,
        "Tanggal Cuti",
        "",
        "",
        "belum",
        _joinController.text,
        "12",
      temGabung);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    if (_cutiController.text == "") {
      temCuti="belum";
      await SQLHelper.updateItem(
        id,
        _noIndukController.text,
        _namaController.text,
        _alamatController.text,
        _ttlController.text,
        _cutiController.text,
        _lamaController.text,
        _ketController.text,
        temCuti,
       _joinController.text,
        _sisaController.text,
        _joinController.text,
      );
      _refreshJournals();
    } else {
      if(temCuti==""){
        temCuti="cuti";
        await SQLHelper.updateItem(
          id,
          _noIndukController.text,
          _namaController.text,
          _alamatController.text,
          _ttlController.text,
          _cutiController.text,
          _lamaController.text,
          _ketController.text,
          temCuti,
          _joinController.text,
          _sisaController.text,
          _joinController.text,
        );
        _refreshJournals();
      }else{
        await SQLHelper.updateItem(
          id,
          _noIndukController.text,
          _namaController.text,
          _alamatController.text,
          _ttlController.text,
          _cutiController.text,
          _lamaController.text,
          _ketController.text,
          temCuti,
          _joinController.text,
          _sisaController.text,
          _joinController.text,
        );
        _refreshJournals();
      }

    }
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Berhasil menghapus data pegawai!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('mceasy'),
      // ),
      body: Column(
        children: <Widget>[
          Stack(children: [
            Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.amber),
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 75, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1.25,
                      padding:
                          EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                      child: TextField(
                        cursorColor: Color(0xFF505050),
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                            filterSearchResults(value);
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 16, top: 0, bottom: 0, right: 16),
                          hintText: "cari “nomor induk atau nama”",
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            // borderSide: BorderSide(color: Color(0xFFB4B4B4), width: 1),
                            borderSide:
                                BorderSide(color: Color(0xB4B4B4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Color(0xB4B4B4)),
                          ),
                          prefixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.search),
                            iconSize: 18,
                            color: Color(0xFFEFB305),
                            onPressed: () {},
                          ),
                        suffixIcon: hidingIcon()),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(69, 69, 69, 1.0),
                            fontSize: 13.0),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showDialog();
                            },
                            child: const Icon(
                              Icons.sort,
                              size: 22,
                              color: Colors.black54,
                            ))),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 45, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 9, right: 9),
                              child: Text(
                                "MCEASY",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Expanded(
                      child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: _journals.length,
                            itemBuilder: (context, index) => Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 0, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                      title: Text(_journals[index]['nama'], style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Poppins')),
                                      subtitle: Text("Sisa Cuti : "+_journals[index]['sisa']),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,color: Colors.green,),
                                              onPressed: () => _showFormUpdateCuti(
                                                  _journals[index]['id'], ""),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,color: Colors.red,),
                                              onPressed: () => _deleteItem(
                                                  _journals[index]['id']),
                                            ),
                                          ],
                                        ),
                                      )),
                                  ListTile(
                                      // contentPadding:EdgeInsets.all(0),
                                      title: Text("Alamat : "+_journals[index]['alamat'], style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          fontFamily: 'Poppins')),
                                      ),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15,bottom: 3),
                                      child: Text(
                                        "Nomor Induk : "+_journals[index]['nomor_induk'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            height: 0,
                                            fontFamily: 'Poppins'),
                                      )),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15,bottom: 10),
                                      child: Text(
                                        "Tanggal Gabung : "+format.format(DateTime.parse(_journals[index]['date'])),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Poppins'),
                                      )),
                                  // Padding(
                                  //     padding:
                                  //     EdgeInsets.only(left: 15, right: 15,bottom: 3),
                                  //     child: Text(
                                  //       "Status Cuti : "+_journals[index]['cuti'],
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.normal,
                                  //           height: 0,
                                  //           fontFamily: 'Poppins'),
                                  //     )),
                                ],
                              ),
                            ),
                          )))),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  Widget? hidingIcon() {
    if (inputText.length > 0) {
      return IconButton(
          icon: Icon(
            Icons.clear,
            size: 18,
            color: Colors.red,
          ),
          splashColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              _controller.clear();
              inputText = "";
              _journals = datas;
            });
          });
    } else {
      return null;
    }
  }

  void showDialogPicker(String status, String type, int id) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 320,
              height: 251,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(15)),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 3),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: (status == "cuti")
                            ? DateTime(2021, 1, 1)
                            : DateTime(1980, 1, 1),
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            if (status == "ttl") {
                              _ttlController.text =
                                  formatTtl = DateFormat('dd MMM yyyy').format(newDateTime);

                            } else if (status == "gabung") {
                              _joinController.text =
                                  newDateTime.toString().substring(0,10);
                              temGabung=newDateTime.toString().substring(0,10);
                              print(_joinController.text);
                            } else if (status == "cuti") {
                              _cutiController.text =
                                  formatCuti= DateFormat('dd MMM yyyy').format(newDateTime);
                              DataTampung =
                                  formatCuti= DateFormat('dd MMM yyyy').format(newDateTime);
                              print(_cutiController.text);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 300,
                    color: Colors.black54,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(149876462),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15))),
                    child: FlatButton(
                        onPressed: () {
                          if (type == "update") {
                            Navigator.of(context, rootNavigator: true).pop();
                            _showFormUpdateCuti(id, DataTampung);
                          } else if (type == "add") {
                            Navigator.of(context, rootNavigator: true).pop();
                            _showForm(null);
                          }
                        },
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'PILIH',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ])),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 250,
              height: 230,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(buildContext, rootNavigator: true)
                                  .pop();
                              filterJoin();
                            },
                            child: Row(children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 14,
                                    height: 14,
                                    child: Image.asset('assets/menu.png'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'PERTAMA GABUNG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ])),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(buildContext, rootNavigator: true)
                                  .pop();
                              filterSearchCuti("cuti");
                            },
                            child: Row(children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 14,
                                    height: 14,
                                    child: Image.asset('assets/menu.png'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'CUTI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ])),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(buildContext, rootNavigator: true)
                                  .pop();
                              filterSearchCuti("cuti lebih");
                            },
                            child: Row(children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 14,
                                    height: 14,
                                    child: Image.asset('assets/menu.png'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'CUTI > 1x',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ])),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(buildContext, rootNavigator: true)
                                  .pop();
                              _refreshJournals();
                            },
                            child: Row(children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 14,
                                    height: 14,
                                    child: Image.asset(
                                      'assets/menu.png',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'SEMUA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
