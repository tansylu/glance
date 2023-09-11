import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarApp(),
    ),
  );
}

class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  List<PhotoItem> _items = [];
  late String currentMonthName; // Store the current month name

  @override
  void initState() {
    super.initState();
    _generateCalendarItems();
    _setCurrentMonthName();
  }

  void _generateCalendarItems() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(now.year, now.month, day);
      final weekday = DateFormat('EEEE').format(date);
      _items.add(PhotoItem(day, weekday, null));
    }
  }

  void _setCurrentMonthName() {
    final now = DateTime.now();
    currentMonthName = DateFormat('MMMM').format(now);
  }

  Future<void> _selectImage(PhotoItem item) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        item.image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[ Text(
          'daily.app', // Display the current month name
          style: montserratTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ), Text(
    currentMonthName, // Display the current month name
    style: montserratTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),])),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 3,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (_items[index].image != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteTwo(
                        image: _items[index].image,
                        date: _items[index].day.toString(),
                        weekday: _items[index].weekday,
                      ),
                    ),
                  );
                } else {
                  _selectImage(_items[index]);
                }
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    image: _items[index].image != null
                        ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_items[index].image!),
                    )
                        : null,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _items[index].day.toString(),
                          style: montserratTextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _items[index].weekday,
                          style: montserratTextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}

class PhotoItem {
  final int day;
  final String weekday;
  File? image;

  PhotoItem(this.day, this.weekday, this.image);
}

class RouteTwo extends StatelessWidget {
  final File? image;
  final String date;
  final String weekday;

  RouteTwo({Key? key, required this.image, required this.date, required this.weekday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('the one where'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image != null
                ? Image.file(image!, width: 150, height: 150, fit: BoxFit.cover)
                : Placeholder(),
            SizedBox(height: 20),
            Text(
              'Date: $date',
              style: montserratTextStyle(fontSize: 16),
            ),
            Text(
              'Weekday: $weekday',
              style: montserratTextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle montserratTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'Montserrat',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}