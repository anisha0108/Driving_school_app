import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> student;

  const AttendanceScreen({
    super.key,
    required this.documentId,
    required this.student,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;

Future<void> markAttendance(String status) async {
await FirebaseFirestore.instance
.collection("students")
.doc(widget.documentId)
.collection("attendance")
.add({
"date": Timestamp.now(),
"status": status,
});
}

bool hasAttendance(DateTime day, List<QueryDocumentSnapshot> attendance) {
for (var doc in attendance) {
final data = doc.data() as Map<String, dynamic>;

Timestamp ts = data["date"];
DateTime date = ts.toDate();

if (date.year == day.year &&
date.month == day.month &&
date.day == day.day) {
return true;
}
}
return false;
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text("${widget.student["name"]} Attendance"),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection("students")
.doc(widget.documentId)
.collection("attendance")
.orderBy("date", descending: true)
.snapshots(),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}

final attendance = snapshot.data!.docs;

int totalClasses = attendance.length;

int present = attendance.where((doc) {
final data = doc.data() as Map<String, dynamic>;
return data["status"] == "Present";
}).length;

int absent = totalClasses - present;

double percentage = totalClasses == 0
? 0
: (present / totalClasses) * 100;

return Column(
children: [

Padding(
padding: const EdgeInsets.all(15),
child: Row(
children: [

Expanded(
child: ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
icon: const Icon(Icons.check),
label: const Text("Present"),
onPressed: () async {
await markAttendance("Present");
},
),
),

const SizedBox(width: 10),

Expanded(
child: ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
),
icon: const Icon(Icons.close),
label: const Text("Absent"),
onPressed: () async {
await markAttendance("Absent");
},
),
),

],
),
),

Card(
margin: const EdgeInsets.all(10),
child: TableCalendar(
firstDay: DateTime.utc(2020, 1, 1),
lastDay: DateTime.utc(2035, 12, 31),
focusedDay: _focusedDay,

selectedDayPredicate: (day) {
return isSameDay(_selectedDay, day);
},

onDaySelected: (selectedDay, focusedDay) {
setState(() {
_selectedDay = selectedDay;
_focusedDay = focusedDay;
});
},

calendarStyle: const CalendarStyle(
todayDecoration: BoxDecoration(
color: Colors.blue,
shape: BoxShape.circle,
),
selectedDecoration: BoxDecoration(
color: Colors.green,
shape: BoxShape.circle,
),
),

calendarBuilders: CalendarBuilders(
defaultBuilder: (context, day, focusedDay) {
if (hasAttendance(day, attendance)) {
return Container(
margin: const EdgeInsets.all(4),
decoration: const BoxDecoration(
color: Colors.green,
shape: BoxShape.circle,
),
child: Center(
child: Text(
"${day.day}",
style: const TextStyle(
color: Colors.white,
),
),
),
);
}
return null;
},
),
),
),

Card(
margin: const EdgeInsets.all(12),
elevation: 4,
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [

const Text(
"Attendance Summary",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

LinearProgressIndicator(
value: percentage / 100,
minHeight: 10,
),

const SizedBox(height: 15),

Text(
"${percentage.toStringAsFixed(1)}%",
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 15),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceAround,
children: [

Column(
children: [
Text(
"$totalClasses",
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
const Text("Total Classes"),
],
),

Column(
children: [
Text(
"$present",
style: const TextStyle(
fontSize: 22,
color: Colors.green,
fontWeight: FontWeight.bold,
),
),
const Text("Present"),
],
),

Column(
children: [
Text(
"$absent",
style: const TextStyle(
fontSize: 22,
color: Colors.red,
fontWeight: FontWeight.bold,
),
),
const Text("Absent"),
],
),

],
),

],
),
),
),
  Expanded(
    child: attendance.isEmpty
        ? const Center(
      child: Text(
        "No Attendance Found",
        style: TextStyle(fontSize: 18),
      ),
    )
        : ListView.builder(
      itemCount: attendance.length,
      itemBuilder: (context, index) {
        final data = attendance[index].data()
        as Map<String, dynamic>;

        Timestamp ts = data["date"];
        DateTime dt = ts.toDate();

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
              data["status"] == "Present"
                  ? Colors.green
                  : Colors.red,
              child: Icon(
                data["status"] == "Present"
                    ? Icons.check
                    : Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(
              data["status"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "${dt.day}/${dt.month}/${dt.year}",
            ),
          ),
        );
      },
    ),
  ),
],
);
},
),
);
}
}