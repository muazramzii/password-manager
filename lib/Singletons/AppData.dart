//    @Singletons Factory Class
//    @Frankis (Mrpixel)

class AppData{

  static final AppData _appData = new AppData._internal();

  String  email= '',name = '', phoneno = '', password = '', nokp = '', address = '' ;
  int userid = 0, usertype = 0;


  factory AppData(){
    return _appData;
  }

  AppData._internal();

}

final appData = AppData();

//NANTI DEMO DATANG INFORM KAWE..KAWE NAK AJAR CARA NAK GUNA SINGLETONS