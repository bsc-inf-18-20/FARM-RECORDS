import 'package:farmrecord/pages/crop%20management/field%20operation%20records/field_operation_records.dart';
import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:farmrecord/pages/crop%20management/labour%20records/labour_records.dart';
import 'package:farmrecord/pages/crop%20management/yield_reocrods/yield_records.dart';
import 'package:flutter/material.dart';

import 'crop records/crop_records.dart';

class CropManagement extends StatelessWidget {
  const CropManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.appBarColor,
        title: Text(
          'Crop Management',
          style: appTheme.textStyle.copyWith(
            color: appTheme.buttonTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/farming.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    _buildRoundedBox(context, 'Crop Records', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CropRecordsPage()),
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
                    _buildRoundedBox(context, 'Yield Records', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const YieldRecords()),
                      );
                    }),
                    const SizedBox(height: 15),
                    _buildRoundedBox(context, 'Field operation Records', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FieldOperationRecords()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedBox(
      BuildContext context, String title, VoidCallback onTap) {
    final appTheme = AppTheme();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 55,
        decoration: BoxDecoration(
          color: appTheme.buttonColor.withOpacity(0.9),
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
            style: appTheme.textStyle.copyWith(
              color: appTheme.buttonTextColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
