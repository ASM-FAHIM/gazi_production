import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gazi_sales_app/sales/constant/dimensions.dart';
import 'package:gazi_sales_app/sales/module/view/history/order_history_accessories.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constant/colors.dart';
import '../../../widget/big_text.dart';
import '../../../widget/small_text.dart';
import '../../controller/cart_controller.dart';


class HistoryDetails extends StatefulWidget {
  String cartId;
  HistoryDetails({Key? key, required this.cartId}) : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  CartController cartController = Get.find<CartController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartController.getCartHeaderDetailsList(widget.cartId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appBarColor,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_outlined,
              size: 25,
            ),
          ),
          title: BigText(text: '${widget.cartId} details', color: AppColor.defWhite, size: 25,),

        ),
        body: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => cartController.isLoading1.value
                  ? Center(child: CircularProgressIndicator(),)
                  : Expanded(
                    child: ListView.builder(
                      itemCount: cartController.listCartHeaderDetails.length,
                      itemBuilder: (context, index) {
                        var cartHeaderDetails = cartController.listCartHeaderDetails[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Card(
                            elevation: 2,
                            color: AppColor.defWhite,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              height: Dimensions.height120,
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(text: '${cartHeaderDetails['xdesc']}', size: 12,),
                                  Row(
                                    children: [
                                      BigText(text: '${cartHeaderDetails['xitem']}', size: 14,),
                                      if('${cartHeaderDetails['yes_no']}' == 'No' && '${cartHeaderDetails["giftStatus"]}' == 'Gift Item')...[
                                        SmallText(text: ' (Gift Item) ', color: Colors.red,)
                                      ]else...[
                                        SmallText(text: ' (Product) ', color: Colors.red,)
                                      ]
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SmallText(text: '${cartHeaderDetails['xqty']} X', size: 14,),
                                      SmallText(text: ' ${cartHeaderDetails['xrate'].toStringAsFixed(2)} = ', size: 14,),
                                      SmallText(text: '${cartHeaderDetails['subTotal'].toStringAsFixed(2)}', size: 14, color: AppColor.defRed,),
                                      const Icon(MdiIcons.currencyBdt, size: 14, color: AppColor.defRed,)
                                    ],
                                  ),
                                  Spacer(),
                                  if('${cartHeaderDetails['yes_no']}' == 'No' && '${cartHeaderDetails["giftStatus"]}' == 'Gift Item')...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'This item is a gift item',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18, color: Colors.grey.withOpacity(0.6)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]else...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.defRed,),
                                          onPressed: (){
                                            showDialog(context: context, builder: (BuildContext context){
                                              return ReusableAlert(
                                                cartController: cartController,cartID: widget.cartId,
                                                itemCode: cartHeaderDetails['xitem'],
                                                qty: cartHeaderDetails['xqty'] as double,
                                                xorg: cartHeaderDetails['xdesc'],
                                                price: '${cartHeaderDetails['xrate']}',
                                                zID: '${cartHeaderDetails['zid']}',
                                              );
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SmallText(text: 'Edit', size: 15,color: Colors.white,),
                                              SizedBox(width: 10,),
                                              Icon(MdiIcons.bookEdit,color: Colors.white, size: 20, )
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.defRed,),
                                          onPressed: (){
                                            Get.to(()=> OrderHistoryAccessoriesScreen(cartId: widget.cartId, productID: cartHeaderDetails['xitem']));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SmallText(text: 'Accessories', size: 15,color: Colors.white,),
                                              SizedBox(width: 10,),
                                              Icon(MdiIcons.listBox,color: Colors.white, size: 20, )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ]

                                ],
                              ),
                            ),
                          ),
                        );
                      })
              ))
            ],
          ),
        ),
      ),
    );
  }
}


class ReusableAlert extends StatelessWidget {
  ReusableAlert({
    Key? key,
    required this.cartController,
    required this.zID,
    required this.cartID,
    required this.qty,
    required this.xorg,
    required this.itemCode,
    required this.price,

  }) : super(key: key);

  final CartController cartController;
  final String zID;
  final String cartID;
  final double qty;
  final String xorg;
  final String itemCode;
  final String price;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update Item',
        style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black54),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              itemCode,
              style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                  color: Colors.black54),
            ),
            Text(
              xorg,
              style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                  color: Colors.black54),
            ),
            Text(
              'Ordered quantity: $qty',
              style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
                width: 100,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'-')),
                    FilteringTextInputFormatter.deny(RegExp(r'\.')),
                    FilteringTextInputFormatter.deny(RegExp(r',')),
                    FilteringTextInputFormatter.deny(RegExp(r'\+')),
                    FilteringTextInputFormatter.deny(RegExp(r'\*')),
                    FilteringTextInputFormatter.deny(RegExp(r'/')),
                    FilteringTextInputFormatter.deny(RegExp(r'=')),
                    FilteringTextInputFormatter.deny(RegExp(r'%')),
                    FilteringTextInputFormatter.deny(RegExp(r' ')),
                  ],
                  textAlign: TextAlign.center,
                  controller: cartController.quantity,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) async{
                    if(cartController.quantity.text.isEmpty){
                      Navigator.pop(context);
                    }else{
                      await cartController.updateItemWiseCartDetails(cartID, itemCode, cartController.quantity.text, price, zID);
                      Navigator.pop(context);
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.green,),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Enter quantity",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'No',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text(
            'Yes',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () async{
            if(cartController.quantity.text.isEmpty){
              Navigator.pop(context);
            }else{
              await cartController.updateItemWiseCartDetails(cartID, itemCode, cartController.quantity.text, price, zID);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
