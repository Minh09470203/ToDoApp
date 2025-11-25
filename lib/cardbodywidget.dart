import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBody extends StatelessWidget {
  CardBody({
    super.key, required this.item, required this.onDelete, required this.onEdit, required this.onCheck
  });
  var item;
  final Function onDelete;
  final Function onEdit;
  final Function onCheck;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 5, right: 5),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  if (item.deadline != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            // Format ngày đơn giản: DD/MM/YYYY
                            "${item.deadline!.day}/${item.deadline!.month}/${item.deadline!.year}",
                            style: TextStyle(
                              fontSize: 14,
                              // Nếu quá hạn (trước ngày hôm nay) thì hiện màu Đỏ, còn lại màu Xám
                              color: item.deadline!.isBefore(DateTime.now().subtract(Duration(days: 1)))
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => onEdit(item),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(item),
          ),
          IconButton(
              icon: Icon(Icons.check, color: item.isCompleted ? Colors.green : Colors.grey),
              onPressed: () => onCheck(item)
          )
        ],
      ),
    );
  }
}
