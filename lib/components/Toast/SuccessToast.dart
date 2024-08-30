import 'package:flutter/material.dart';
import 'dart:ui';

class Successtoast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 10, // Adjust this value for vertical positioning
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxWidth: 500, // Adjust if needed
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.7), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: 
                      
                      
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 24, // Adjust size if needed
                      ),
                      SizedBox(width: 10,),
                            Text(
                              message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              
                              // Center text if needed
                            ),
                          ],
                        ),
                      ),
                    
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
