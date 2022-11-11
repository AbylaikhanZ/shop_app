import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_prov.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-products";
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  //variable created to not run changedependencies twice
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  //initial or default values of the fields
  var _editedProduct =
      Product(id: null, description: "", imageUrl: "", price: 0, title: "");

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products_Prov>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
        //retrieving the id of the product. if id is null, it means that we have loaded
        //this page from the "plus" button and we want to add a new product
        //if it is not null, it means that we want to edit the existing product
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  //it is necessary to dispose all the focus nodes when stop working with the inputs

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg") &&
              !_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".bmp"))) {
        return;
      }
      //checks if it is a valid image before updating
      setState(() {});
    }
  }
  //this function updates the image when we do not press submit on the image url
  //text form, but just tap out of it

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products_Prov>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products_Prov>(context, listen: false)
          .addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Products"),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            //form manages different types of input
            child: ListView(
              //ListView is ok when the input is not too long, and the
              //scroll is not too long either. If the content requires
              //a lot of vertical space, it is better to use a column
              //wrapped in singlechildscrollview, because listview
              //stops rendering objects that are not on the screen
              children: [
                TextFormField(
                  initialValue: _initValues["title"],
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please provide a title";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite,
                        title: value);
                  },
                ),
                TextFormField(
                  initialValue: _initValues["price"],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please provide a price";
                    } else if (double.tryParse(value) == null) {
                      return "Please enter a valid price";
                    } else if (double.parse(value) <= 0) {
                      return "Please enter a positive value for price";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value),
                        title: _editedProduct.title);
                  },
                ),
                TextFormField(
                  initialValue: _initValues["description"],
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please provide a description";
                    } else if (value.length < 10) {
                      return "Please provide a longer description";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        description: value,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        title: _editedProduct.title);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.contain,
                            ),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () => setState(() {}),
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please provide a title";
                          } else if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Please provide a valid URL";
                          } else if (!value.endsWith(".jpg") &&
                              !value.endsWith(".jpeg") &&
                              !value.endsWith(".png") &&
                              !value.endsWith(".bmp")) {
                            return "Please enter a valid image URL";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              description: _editedProduct.description,
                              imageUrl: value,
                              price: _editedProduct.price,
                              title: _editedProduct.title);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
