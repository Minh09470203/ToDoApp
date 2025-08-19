import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBody extends StatelessWidget {
  CardBody({
    super.key, required this.item, required this.onDelete,
  });
  var item;
  final Function onDelete;
  void _handleOntap() {
    onDelete(item.id); // Call the onDelete function with the item's id
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFFDFDFDF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.check_circle_outline, color: Colors.lightBlueAccent, size: 30),
                ),
                SizedBox(width: 16),
                Text(
                  item.name, // Replace with dynamic task name
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF4B4B4B),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  if (await confirm(context)) {
                    _handleOntap();
                  }
                  return;
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.10),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
