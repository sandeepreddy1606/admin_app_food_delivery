import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/firestore_service.dart';

class AddEditMenuItemPage extends StatefulWidget {
  final String restaurantId;
  final MenuItem? menuItem;
  const AddEditMenuItemPage({super.key, required this.restaurantId, this.menuItem});
  @override
  State<AddEditMenuItemPage> createState() => _AddEditMenuItemPageState();
}

class _AddEditMenuItemPageState extends State<AddEditMenuItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  
  bool _isAvailable = true;
  bool _isVegetarian = false;
  bool _isSpicy = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final menuItem = widget.menuItem;
    _nameController = TextEditingController(text: menuItem?.name ?? '');
    _descriptionController = TextEditingController(text: menuItem?.description ?? '');
    _priceController = TextEditingController(text: menuItem?.price.toString() ?? '');
    _imageUrlController = TextEditingController(text: menuItem?.imageUrl ?? '');
    _categoryController = TextEditingController(text: menuItem?.category ?? '');
    
    if (menuItem != null) {
      _isAvailable = menuItem.isAvailable;
      _isVegetarian = menuItem.isVegetarian;
      _isSpicy = menuItem.isSpicy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.menuItem != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty == true ? 'Price is required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Category is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
                activeColor: Colors.orange,
              ),
              
              SwitchListTile(
                title: const Text('Vegetarian'),
                value: _isVegetarian,
                onChanged: (value) => setState(() => _isVegetarian = value),
                activeColor: Colors.green,
              ),
              
              SwitchListTile(
                title: const Text('Spicy'),
                value: _isSpicy,
                onChanged: (value) => setState(() => _isSpicy = value),
                activeColor: Colors.red,
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveMenuItem,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: _loading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? 'Update Menu Item' : 'Add Menu Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMenuItem() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    
    try {
      final menuItem = MenuItem(
        id: widget.menuItem?.id ?? '',
        restaurantId: widget.restaurantId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        category: _categoryController.text,
        isAvailable: _isAvailable,
        isVegetarian: _isVegetarian,
        isSpicy: _isSpicy,
        createdAt: widget.menuItem?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.menuItem != null) {
        await FirestoreService.updateMenuItem(widget.restaurantId, menuItem);
      } else {
        await FirestoreService.addMenuItem(widget.restaurantId, menuItem);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.menuItem != null ? 'Menu item updated!' : 'Menu item added!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
