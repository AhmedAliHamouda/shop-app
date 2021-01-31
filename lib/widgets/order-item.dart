import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order-provider.dart';

class OrderItemProducts extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemProducts(this.orderItem);

  @override
  _OrderItemProductsState createState() => _OrderItemProductsState();
}

class _OrderItemProductsState extends State<OrderItemProducts> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _expanded
          ? min(widget.orderItem.products.length * 20.0 + 110, 280) : 95,
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orderItem.total.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm a')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: _expanded ? min(
                  widget.orderItem.products.length * 20.0 + 10,
                  180):0,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: ListView.builder(
                  itemCount: widget.orderItem.products.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.orderItem.products[index].title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.orderItem.products[index].quantity} x \$${widget.orderItem.products[index].price}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
