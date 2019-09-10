import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String bitcoinValueInUSD = '?';
  bool isWaiting=false;
  Map<String, String> coinValues = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column populateCryptoCards()
  {
    List<CryptoCard> cryptoCards=[];
    for(String crypto in cryptoList)
    {
      cryptoCards.add(
        
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting?'?':coinValues[crypto],
        ),
      );
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoCards,
    );
  }

  getData() async {
    try {
      isWaiting=true;
      var data = await CoinData().getCoinData(selectedCurrency);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
        isWaiting=false;
      setState(() {
        coinValues=data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BitCoin Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          
          populateCryptoCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? androidDropDown():iOSPicker() ,
          ),
        ],
      ),
    );
  }


  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> list = [];

    for (String currency in currenciesList) {
      list.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton(
      items: list,
      onChanged: (String value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
      value:selectedCurrency,
    );
  }


  /// ios picker
  CupertinoPicker iOSPicker() {
    List<Text> text = [];
    for (String currency in currenciesList) {
      text.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList [selectedIndex];
      //  print(selectedCurrency);
        getData();
      },
      children: text,

    );
  }
}

