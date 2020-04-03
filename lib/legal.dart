import 'package:flutter/material.dart';

class LegalPage extends StatefulWidget {
  LegalPage({Key key}) : super(key: key);

  @override
  _LegalPageState createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {

  /*
  final String legalText = """1. OUR SERVICES. OUR SERVICES ENABLE YOU TO SEARCH FOR ALCOHOL
  BEVERAGES AND OTHER PRODUCTS AND PLACE AND SCHEDULE ORDERS
  WITH INDEPENDENT, LICENSED ALCOHOL BEVERAGE RETAILERS, AND OTHER
  LICENSEES WITH RETAIL PRIVILEGES, ("LICENSED RETAILERS") FOR THE PUR-
  CHASE AND SALE OF SUCH BEVERAGES AND PRODUCTS, AMONG OTHER
  THINGS. ALL ORDERS PLACED THROUGH THE APP OR THE WEBSITE ARE
  ACCEPTED, REVIEWED, AND ULTIMATELY FULFILLED BY LICENSED RETAILERS.
  ALL SALES ARE SOLELY TRANSACTED BETWEEN YOU AND LICENSED RETAIL-
  ERS. EACH PRODUCT LISTED ON DRIZLY IS NOT AN OFFER TO PURCHASE
  SUCH PRODUCT BUT AN INVITATION TO MAKE AN OFFER BY PLACING AN
  ORDER. YOU ACKNOWLEDGE AND AGREE THAT DRIZLY DOES NOT SELL,
  OFFER TO SELL, INVITE TO SELL, OR SOLICIT ANY OFFERS. IN ALL INSTANCES,
  ALL SALES ARE ADVERTISED, ACCEPTED, MADE AND DELIVERED BY LICENSED
  RETAILERS WHO RECEIVE ALL ORDERS AND OFFERS. IN ALL INSTANCES, ANY
  SOLICITATION, INVITATION, OFFER, ADVERTISEMENT OR COMMUNICATION IS
  VOID WHERE PROHIBITED BY LAW. DRIZLY DOES NOT SELL OR DELIVER AL-
  COHOL BEVERAGES. NO PART OF THE SERVICES IS INTENDED TO FACILITATE
  ANY IMPROPER FURNISHING OF INDUCEMENTS BY ANY MANUFACTURER,
  IMPORTER, SUPPLIER, WHOLESALER OR DISTRIBUTOR OF ALCOHOL BEVER-
  AGES TO ANY LICENSED RETAILER OR ANY IMPROPER EXCLUSIONARY PRAC-
  TICES BY ANY ALCOHOL BEVERAGE LICENSEE.""";
  */
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(18),
                child: new Text(
                  "LEGAL",
                  style: new TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "Verdana",

                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: new Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " +
                    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. " +
                    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. " +
                    "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",

                    style: new TextStyle(
                      fontSize: 18, color: Colors.white, fontFamily: "Verdana",
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}