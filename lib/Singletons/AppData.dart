//    @Singletons Factory Class
//    @Frankis (Mrpixel)

class AppData{

  static final AppData _appData = new AppData._internal();

  String userid = '', email = '', name = '', phoneno = '';

  factory AppData(){
    return _appData;
  }

  AppData._internal();

  void clear(){
    userid = '';
    email = '';
    name = '';
    phoneno = '';
  }

}

final appData = AppData();

//NANTI DEMO DATANG INFORM KAWE..KAWE NAK AJAR CARA NAK GUNA SINGLETONS