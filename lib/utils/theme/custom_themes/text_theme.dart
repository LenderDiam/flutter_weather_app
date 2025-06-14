import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static final TextTheme light = TextTheme(
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    titleLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyMedium: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
    labelSmall: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
  );

  static final TextTheme dark = TextTheme(
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    bodyMedium: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
    labelSmall: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
  );
}
