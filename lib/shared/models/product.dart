import 'package:equatable/equatable.dart';

/// Inventory product model.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.stock,
    required this.unit,
    this.barcode,
    this.lowStockThreshold = 10,
    this.gstRate = 18,
  });

  final String id;
  final String name;
  final String sku;
  final String category;
  final double sellingPrice;
  final double purchasePrice;
  final int stock;
  final String unit;
  final String? barcode;
  final int lowStockThreshold;
  final double gstRate;

  double get stockValue => stock * purchasePrice;
  bool get isLowStock => stock <= lowStockThreshold;
  bool get isOutOfStock => stock <= 0;

  StockStatus get stockStatus {
    if (isOutOfStock) return StockStatus.outOfStock;
    if (isLowStock) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  @override
  List<Object?> get props =>
      [id, name, sku, category, sellingPrice, purchasePrice, stock, unit, barcode];
}

enum StockStatus { inStock, lowStock, outOfStock }
