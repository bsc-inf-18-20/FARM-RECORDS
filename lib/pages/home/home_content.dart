import 'package:farmrecord/pages/records/crop.dart';
import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:farmrecord/pages/records/financial_records';
import 'package:farmrecord/pages/labour%20records/labour_records.dart';
import 'package:farmrecord/pages/records/layers%20_records.dart';
import 'package:farmrecord/pages/records/milk_records.dart';
import 'package:farmrecord/pages/records/operation_records.dart';
import 'package:farmrecord/pages/yield_reocrods/yield_records.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Records'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  _buildRoundedBox(context, 'Field Operations Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FieldOperationsPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Crop Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CropPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Labour Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LabourPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Layers Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LayersPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Milk Production Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MilkProductionPage()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Yield Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YieldRecords()),
                    );
                  }),
                  const SizedBox(height: 15),
                  _buildRoundedBox(context, 'Financial Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FinancialPage()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedBox(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 55,
        decoration: BoxDecoration(
          color: AppTheme().buttonColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(66, 255, 255, 255),
              offset: Offset(2, 2),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme().buttonTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
