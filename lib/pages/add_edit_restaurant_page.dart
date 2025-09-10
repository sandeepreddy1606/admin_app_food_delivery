import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';

class AddEditRestaurantPage extends StatefulWidget {
  final Restaurant? restaurant;
  const AddEditRestaurantPage({super.key, this.restaurant});
  
  @override
  State<AddEditRestaurantPage> createState() => _AddEditRestaurantPageState();
}

class _AddEditRestaurantPageState extends State<AddEditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _deliveryTimeController;
  late TextEditingController _deliveryFeeController;
  
  String _selectedCuisine = 'American';
  bool _isOpen = true;
  bool _loading = false;

  final List<String> _cuisineTypes = [
    'American', 'Italian', 'Chinese', 'Japanese', 'Mexican', 
    'Indian', 'Thai', 'French', 'Mediterranean', 'Fast Food',
    'Korean', 'Vietnamese', 'Greek', 'Turkish', 'Lebanese'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final restaurant = widget.restaurant;
    _nameController = TextEditingController(text: restaurant?.name ?? '');
    _descriptionController = TextEditingController(text: restaurant?.description ?? '');
    _imageUrlController = TextEditingController(text: restaurant?.imageUrl ?? '');
    _addressController = TextEditingController(text: restaurant?.address ?? '');
    _phoneController = TextEditingController(text: restaurant?.phoneNumber ?? '');
    _emailController = TextEditingController(text: restaurant?.ownerEmail ?? '');
    _deliveryTimeController = TextEditingController(
      text: restaurant?.deliveryTime.toString() ?? '30'
    );
    _deliveryFeeController = TextEditingController(
      text: restaurant?.deliveryFee.toString() ?? '2.99'
    );
    
    if (restaurant != null) {
      _selectedCuisine = restaurant.cuisineType;
      _isOpen = restaurant.isOpen;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _deliveryTimeController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.restaurant != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Restaurant' : 'Add Restaurant'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.restaurant,
                            color: Colors.orange,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Restaurant Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Restaurant Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Restaurant Name *',
                          prefixIcon: const Icon(Icons.store),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty == true) {
                            return 'Restaurant name is required';
                          }
                          if (value!.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description *',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.trim().isEmpty == true) {
                            return 'Description is required';
                          }
                          if (value!.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      
                      // Image URL - FIXED THE ERROR HERE
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          prefixIcon: const Icon(Icons.image),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          hintText: 'https://example.com/image.jpg',
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value?.isNotEmpty == true) {
                            final uri = Uri.tryParse(value!);
                            if (uri == null || !uri.hasAbsolutePath) {
                              return 'Please enter a valid URL';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Cuisine Type
                      DropdownButtonFormField<String>(
                        value: _selectedCuisine,
                        decoration: InputDecoration(
                          labelText: 'Cuisine Type *',
                          prefixIcon: const Icon(Icons.restaurant_menu),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: _cuisineTypes.map((cuisine) => DropdownMenuItem(
                          value: cuisine,
                          child: Text(cuisine),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedCuisine = value!),
                        validator: (value) => value == null ? 'Please select a cuisine type' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contact Information Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.contact_mail,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Contact Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address *',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value?.trim().isEmpty == true) {
                            return 'Address is required';
                          }
                          if (value!.trim().length < 10) {
                            return 'Please enter a complete address';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone and Email Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number *',
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value?.trim().isEmpty == true) {
                                  return 'Phone is required';
                                }
                                if (value!.trim().length < 10) {
                                  return 'Enter valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Owner Email *',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.trim().isEmpty == true) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                  return 'Enter valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Delivery Information Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.delivery_dining,
                            color: Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delivery Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Delivery Time and Fee Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _deliveryTimeController,
                              decoration: InputDecoration(
                                labelText: 'Delivery Time (min) *',
                                prefixIcon: const Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                suffixText: 'min',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.trim().isEmpty == true) {
                                  return 'Delivery time is required';
                                }
                                final time = int.tryParse(value!);
                                if (time == null || time < 5 || time > 120) {
                                  return 'Time must be 5-120 minutes';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _deliveryFeeController,
                              decoration: InputDecoration(
                                labelText: 'Delivery Fee *',
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                prefixText: '\$',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                if (value?.trim().isEmpty == true) {
                                  return 'Delivery fee is required';
                                }
                                final fee = double.tryParse(value!);
                                if (fee == null || fee < 0 || fee > 20) {
                                  return 'Fee must be \$0-20';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Status Switch
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: SwitchListTile(
                          title: const Text(
                            'Currently Open',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            _isOpen ? 'Restaurant is accepting orders' : 'Restaurant is closed',
                            style: TextStyle(
                              color: _isOpen ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          value: _isOpen,
                          onChanged: (value) => setState(() => _isOpen = value),
                          activeColor: Colors.orange,
                          secondary: Icon(
                            _isOpen ? Icons.store : Icons.store_mall_directory_outlined,
                            color: _isOpen ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveRestaurant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _loading 
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isEditing ? 'Updating...' : 'Adding...',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.update : Icons.add,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEditing ? 'Update Restaurant' : 'Add Restaurant',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    
    try {
      final restaurant = Restaurant(
        id: widget.restaurant?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        rating: widget.restaurant?.rating ?? 4.5,
        cuisineType: _selectedCuisine,
        deliveryTime: int.parse(_deliveryTimeController.text.trim()),
        deliveryFee: double.parse(_deliveryFeeController.text.trim()),
        isOpen: _isOpen,
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        ownerEmail: _emailController.text.trim(),
        createdAt: widget.restaurant?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.restaurant != null) {
        await FirestoreService.updateRestaurant(restaurant);
      } else {
        await FirestoreService.addRestaurant(restaurant);
      }

      // Return true to indicate success
      Navigator.pop(context, true);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.restaurant != null 
                  ? 'Restaurant updated successfully!' 
                  : 'Restaurant added successfully!',
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Error: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _saveRestaurant,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}
