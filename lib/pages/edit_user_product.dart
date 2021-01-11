import 'package:dukaan/providers/product.dart';
import 'package:dukaan/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserProduct extends StatefulWidget {
  static const routeName = '/edit-user-product';
  @override
  _EditUserProductState createState() => _EditUserProductState();
}

class _EditUserProductState extends State<EditUserProduct> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descripitonFocusNoe = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  var _editedProduct = Product(
    id: null,
    description: "",
    imgUrl: "",
    price: 0.0,
    title: "",
  );

  var initialVal = {
    "title": "",
    "description": "",
    "price": "",
    "imgUrl": "",
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(imageUrlFieldFocusChanged);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initialVal['price'] = _editedProduct.price.toString();
        initialVal["title"] = _editedProduct.title;
        initialVal["description"] = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imgUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void imageUrlFieldFocusChanged() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id == null) {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An Error occured"),
                  content: Text("Something went wrong"),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Okay'))
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initialVal["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please give a value";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          imgUrl: _editedProduct.imgUrl,
                          title: val,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initialVal["price"],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descripitonFocusNoe);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please give a value";
                        } else if (double.tryParse(val) == null ||
                            double.parse(val) <= 0) {
                          return "Enter a correct price";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          price: double.parse(val),
                          id: _editedProduct.id,
                          imgUrl: _editedProduct.imgUrl,
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initialVal["description"],
                      decoration: InputDecoration(labelText: "Desciption"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descripitonFocusNoe,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please give a value";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          description: val,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          imgUrl: _editedProduct.imgUrl,
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image Url"),
                            textInputAction: TextInputAction.done,
                            maxLines: 3,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please give a value";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = Product(
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                id: _editedProduct.id,
                                imgUrl: val,
                                title: _editedProduct.title,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(child: Text("No Image"))
                              : FittedBox(
                                  fit: BoxFit.contain,
                                  child:
                                      Image.network(_imageUrlController.text)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(imageUrlFieldFocusChanged);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descripitonFocusNoe.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
