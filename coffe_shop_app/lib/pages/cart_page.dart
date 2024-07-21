import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cart_tile.dart';
import '../components/coffee_tile.dart';
import '../components/my_button.dart';
import '../model/coffee.dart';
import '../model/coffee_item.dart';
import 'coffee_order_page.dart';

class CartPage extends StatefulWidget {

  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Coffee coffee) {
    Provider.of<CoffeeItem>(context, listen:false).removeFromCart(coffee);
  }

  Widget build(BuildContext context) {
    return Consumer<CoffeeItem>(
      builder: (context, value, child){
        double totalPrice = value.userCart.fold(0, (sum, item) => sum + item.price * item.quantity);
        int totalQuantity = value.userCart.fold(0, (sum, item) => sum + item.quantity);

        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
                  child: Text('Your Cart', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: value.userCart.length,
                itemBuilder: (context, index) {
                  Coffee coffee = value.userCart[index];
                  return CartTile(
                    coffee: coffee,
                    onPressed: () => removeFromCart(coffee),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Totale Quantity:', 
                        style: TextStyle(fontSize: 16),
                      ),
                      Text('\$${totalQuantity.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Totale Price:', 
                        style: TextStyle(fontSize: 16),
                      ),
                      Text('\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
      
    );
  }
}