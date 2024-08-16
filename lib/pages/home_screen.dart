// ignore_for_file: prefer_final_fields

import 'package:coins_app/services/connection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Connection _connection;
  List<Map<String, dynamic>> _datalist = [];
  List<Map<String, dynamic>> _filteredDatalist = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  final NumberFormat _currencyFormat =
      NumberFormat.currency(symbol: '₹', decimalDigits: 2);


  @override
  void initState() {
    super.initState();
    _connection = Connection("ws://prereg.ex.api.ampiy.com/prices");
    _connection.stream.listen((datalist) {
      setState(() {
        _datalist = datalist;
        _filteredDatalist = datalist;
        isLoading = false;
      });
    }, onError: (error) {
      isLoading = false;
    });

    _searchController.addListener(() {
      _filterData();
    });
  }

  void _filterData() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDatalist = _datalist
          .where((item) => item['s'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _connection.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _getPriceChangeColor(String percentChange) {
    double percent = double.tryParse(percentChange) ?? 0.0;
    return percent >= 0 ? Colors.greenAccent : Colors.redAccent;
  }

  Icon _getPriceChangeIcon(String percentChange) {
    double percent = double.tryParse(percentChange) ?? 0.0;
    return percent >= 0
        ? const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 16)
        : const Icon(Icons.arrow_downward, color: Colors.redAccent, size: 16);
  }

  String _formatPercentChange(String percentChange) {
    double percent = double.tryParse(percentChange) ?? 0.0;
    return percent.toStringAsFixed(2);
  }

  String _formatPrice(String price) {
    double priceValue = double.tryParse(price) ?? 0.0;
    return _currencyFormat.format(priceValue);
  }

  void _onTabTapped(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          "CoinWave",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 35),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search coins...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredDatalist.length,
                    itemBuilder: (context, index) {
                      final item = _filteredDatalist[index];
                      final symbol = item['s'] ?? 'N/A';
                      final symbolInitials = symbol.length >= 3
                          ? symbol.substring(0, 3)
                          : symbol.padRight(3, ' ');
                      final formattedPercentChange =
                          _formatPercentChange(item['p'] ?? '0.0');
                      final formattedPrice = _formatPrice(item['c'] ?? '0.0');
                      return Card(
                        color: Colors.grey[900],
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                symbol.replaceAll("INR", ""),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      _getPriceChangeIcon(item['p'] ?? '0.0'),
                                      const SizedBox(width: 4),
                                      Text(
                                        "$formattedPercentChange%",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _getPriceChangeColor(
                                              item['p'] ?? '0.0'),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedPrice,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              symbolInitials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action when button is pressed
        },
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28), // Makes it a perfect circle
        ),
        child: const Icon(Icons.swap_horiz, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                _onTabTapped(0);
              },
            ),
            IconButton(
              icon: const Icon(Icons.currency_exchange_rounded, color: Colors.white),
              onPressed: () {
                _onTabTapped(1);
              },
            ),
            const SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: const Icon(Icons.wallet, color: Colors.white),
              onPressed: () {
                _onTabTapped(2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                _onTabTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
