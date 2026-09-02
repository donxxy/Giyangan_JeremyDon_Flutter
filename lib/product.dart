import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String category;
  final IconData icon;
  final String description;

  const Product({
    required this.name,
    required this.price,
    required this.category,
    required this.icon,
    required this.description,
  });
}

const List<Product> allProducts = [
  Product(
    name: 'Wireless Mouse',
    price: 299.00,
    category: 'Electronics',
    icon: Icons.mouse,
    description: 'A smooth wireless mouse with an ergonomic design.',
  ),
  Product(
    name: 'Bluetooth Speaker',
    price: 899.00,
    category: 'Electronics',
    icon: Icons.speaker,
    description: 'Portable speaker with deep bass and a 10-hour battery.',
  ),
  Product(
    name: 'Running Shoes',
    price: 1499.00,
    category: 'Apparel',
    icon: Icons.directions_run,
    description: 'Lightweight running shoes for everyday training.',
  ),
  Product(
    name: 'Denim Jacket',
    price: 1299.00,
    category: 'Apparel',
    icon: Icons.checkroom,
    description: 'Classic denim jacket with a unisex fit.',
  ),
  Product(
    name: 'Instant Coffee',
    price: 149.00,
    category: 'Grocery',
    icon: Icons.coffee,
    description: 'Rich and aromatic instant coffee, 200g jar.',
  ),
  Product(
    name: 'Organic Honey',
    price: 259.00,
    category: 'Grocery',
    icon: Icons.emoji_food_beverage,
    description: 'Pure organic honey, harvested locally.',
  ),
];