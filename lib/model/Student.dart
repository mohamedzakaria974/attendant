import 'dart:convert';

import 'package:attendant/helpers/Constants.dart';

import 'School.dart';
import 'Stop.dart';

import 'dart:typed_data';

class Student {
  int studentId;
  int studentNID;
  String studentName;
  String studentMobile;
  String studentClass;
  Uint8List photo;
  School studentSchool;
  Stop stopStation;

  int pickedUpSerial;

  int remainningStations;

  static List<Student> studentsList = [];

  Student(
      {this.studentId,
      this.studentNID,
      this.studentName,
      this.studentMobile,
      this.studentClass,
      this.photo,
      this.studentSchool,
      this.stopStation});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['STUDENT_ID'],
      studentNID: json['STUDENT_NID'],
      studentName: json['STUDENT_NAME'],
      studentMobile: json['STUDENT_MOBILE'],
      studentClass: json['CLASS'],
      stopStation: Stop(
          stopId: json['STOP_ID'],
          latitude: json['LATITUDE'],
          longitude: json['LONGITUDE'],
          stopName: json['STOP_NAME']),
      studentSchool: School(
        schoolId: json['SCHOOL_ID'],
        schoolLatitude: json['SCHOOL_LATITUDE'],
        eduLevel: json['EDU_LEVEL'],
        schoolLongitude: json['SCHOOL_LONGITUDE'],
        schoolName: json['SCHOOL_NAME'],
      ),
      photo: json['PHOTO'] == null ? base64.decode(base64String) : base64.decode(json['PHOTO']),
    );
  }

  static getStudentIndexFromList(int id, List<Student> lst) {
    for (int i = 0; i < lst.length; i++) {
      if (lst[i].studentId == id) {
        return i;
      }
    }
  }

//  static List<Student> sortStudents(List students) {
//    for (int i = 0; i < students.length; i++) {
//      for (int y = 1; y < students.length; y++) {
//        if (students[i].remainningStations > students[y].remainningStations) {
//          Student temp = students[i];
//          students[i] = students[y];
//          students[y] = temp;
//        }
//      }
//    }
//    print(students);
//    return students;
//  }
}

//  static List<Student> getDummyStudent() {
//    List<Student> dummyStudent = [
//      new Student(
//        name: "احمد محمد",
//        school: "السلام",
//        academicYear: "الصف الرابع",
//        imageURL:
//            "https://i1.wp.com/www.pnwumc.org/news/wp-content/uploads/2015/04/john-wesley.jpg?fit=700%2C365&ssl=1",
//        stopStation: "مدينة نصر",
//        remainningStations: 5,
//      ),
//      new Student(
//        name: "محمد ابراهيم",
//        school: "المستقبل",
//        academicYear: "الصف السادس",
//        imageURL:
//            "https://fm.cnbc.com/applications/cnbc.com/resources/img/editorial/2018/07/11/105322791-1531301768595gettyimages-467620670.1910x1000.jpg?v=1545151032",
//        stopStation: "العباسية",
//        remainningStations: 3,
//      ),
//      new Student(
//        name: "كريم ابراهيم",
//        school: "طيبة",
//        academicYear: "الصف الثالث",
//        imageURL:
//            "https://9to5mac.com/wp-content/uploads/sites/6/2019/01/Tim-Cook-Huawei.jpg?quality=82&strip=all&w=1500",
//        stopStation: "كلية البنات",
//        remainningStations: 6,
//      ),
//      new Student(
//        name: "اميرة محمود",
//        school: "حورس",
//        academicYear: "الصف الاول ",
//        imageURL:
//            "https://timedotcom.files.wordpress.com/2018/01/mark-zuckerberg-new-years-resolution-facebook.jpg",
//        stopStation: "الحى السادس",
//        remainningStations: 7,
//      ),
//      new Student(
//        name: "محمود محمد",
//        school: "سفينكس",
//        academicYear: "الصف الثانى",
//        imageURL:
//            "https://img.etimg.com/thumb/msid-50318943,width-643,imgsize-337990,resizemode-4/four-things-even-google-doesnt-know-about-its-ceo-sundar-pichai.jpg",
//        stopStation: "الحى السابع",
//        remainningStations: 2,
//      ),
//      new Student(
//        name: "محى احمد",
//        school: "الصفوة",
//        academicYear: "الصف الاول",
//        imageURL:
//            "https://fm.cnbc.com/applications/cnbc.com/resources/img/editorial/2017/01/18/104225995-_95A5004.530x298.jpg?v=1540458420",
//        stopStation: "المقطم",
//        remainningStations: 1,
//      ),
//      new Student(
//        name: "مصطفى محمود",
//        school: "الايمان",
//        academicYear: "الصف الخامس",
//        imageURL:
//            "https://media.newyorker.com/photos/5a666a6a6731fd1ea7517e21/master/w_727,c_limit/Angler-Im-Jeff-Bezos-Im-Your-Dad-Now.jpg",
//        stopStation: "مكرم عبيد",
//        remainningStations: 8,
//      ),
//    ];
//
//    return dummyStudent;
//  }
