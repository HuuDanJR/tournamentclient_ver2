import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Widget textcustom({text,size,isBold,color}) {
  return Text(text,style: GoogleFonts.nunitoSans(
    
    fontSize: size,fontWeight:isBold==true? FontWeight.bold:FontWeight.normal),);
}
Widget textcustomColor({text,size,isBold,color}) {
  return Text(text,style: GoogleFonts.nunitoSans(
    color:  color,
    fontSize: size,fontWeight:isBold==true? FontWeight.bold:FontWeight.normal),);
}
