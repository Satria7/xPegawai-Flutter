class MemoModel{
  final int id;
  final String judul;
  final String konten;


  MemoModel({required this.id,required this.judul,required this.konten});


  Map<String,dynamic> toMap(){ // digunakan saat menambahkan data ke database
    return <String,dynamic>{
      "id" : id,
      "judul" : judul,
      "konten" : konten,
    };
  }
}