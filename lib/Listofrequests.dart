import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Listofrequests extends StatefulWidget {
  final String inputID;
  const Listofrequests({super.key, required this.inputID});

  @override
  State<Listofrequests> createState() => _ListofrequestsState();
}

class _ListofrequestsState extends State<Listofrequests> {
  Stream<List<Map<String, dynamic>>> ordersStream() {
    return FirebaseFirestore.instance
        .collection('delivery')
        .doc(widget.inputID)
        .collection('Orders')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                'address': doc['address'],
                'customerName': doc['customerName'],
                'customerphon': doc['customerphon'],
                'orderTime': doc['orderTime'],
                'prodectnane': doc['prodectnane'],
                'totalPrice': doc['totalPrice'],
              };
            }).toList());
  }

  Future<void> markAsDelivered(
      String orderId, Map<String, dynamic> orderData) async {
    await FirebaseFirestore.instance.collection('deliveredOrders').add({
      ...orderData,
      'deliveryTime': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('delivery')
        .doc(widget.inputID)
        .collection('Orders')
        .doc(orderId)
        .delete();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تفاصيل الطلب',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              Divider(),
              _orderDetailRow('📌 اسم العميل:', order['customerName']),
              _orderDetailRow('📞 رقم الهاتف:', order['customerphon']),
              _orderDetailRow('📍 العنوان:', order['address']),
              _orderDetailRow('🛍️ المنتج:', order['prodectnane']),
              _orderDetailRow('💰 السعر:', '${order['totalPrice']} ج.م'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await markAsDelivered(order['id'], order);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('تم التسليم',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFd33452))),
          SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 18, color: Colors.black87),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d375a),
      appBar: AppBar(
        title: Text('قائمة الطلبات',
            style: TextStyle(fontSize: 22, color: Colors.yellow)),
        backgroundColor: Color(0xFF1d375a),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ordersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('حدث خطأ!', style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('لا توجد طلبات حاليًا',
                    style: TextStyle(color: Colors.white, fontSize: 18)));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return GestureDetector(
                onTap: () => _showOrderDetails(order),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🛍️ ${order['prodectnane']}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 5),
                        Text('📌 العميل: ${order['customerName']}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54)),
                        Text('📞 الهاتف: ${order['customerphon']}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54)),
                        Text('💰 السعر: ${order['totalPrice']} ج.م',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
