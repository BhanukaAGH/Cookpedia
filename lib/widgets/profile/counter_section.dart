import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterSection extends StatelessWidget {
  final String title;
  final int count;

  const CounterSection({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3 - 12,
      height: 50,
      child: GridTile(
        footer: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        child: Text(
          '$count',
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
