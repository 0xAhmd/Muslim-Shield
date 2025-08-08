import '../../data/zakat.dart';
import '../../data/zakat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class EnhancedZakatCalculatorPage extends StatefulWidget {
  const EnhancedZakatCalculatorPage({super.key});

  @override
  State<EnhancedZakatCalculatorPage> createState() =>
      _EnhancedZakatCalculatorPageState();
}

class _EnhancedZakatCalculatorPageState
    extends State<EnhancedZakatCalculatorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controllers for input fields
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _savingsController = TextEditingController();
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _silverController = TextEditingController();
  final TextEditingController _investmentsController = TextEditingController();
  final TextEditingController _debtsController = TextEditingController();

  ZakatResult? _result;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cashController.dispose();
    _savingsController.dispose();
    _goldController.dispose();
    _silverController.dispose();
    _investmentsController.dispose();
    _debtsController.dispose();
    super.dispose();
  }

  void _calculateZakat() {
    if (!_formKey.currentState!.validate()) return;

    final double cash = double.tryParse(_cashController.text) ?? 0.0;
    final double savings = double.tryParse(_savingsController.text) ?? 0.0;
    final double gold = double.tryParse(_goldController.text) ?? 0.0;
    final double silver = double.tryParse(_silverController.text) ?? 0.0;
    final double investments =
        double.tryParse(_investmentsController.text) ?? 0.0;
    final double debts = double.tryParse(_debtsController.text) ?? 0.0;

    final result = ZakatService.calculateZakat(
      cash: cash,
      savings: savings,
      goldGrams: gold,
      silverGrams: silver,
      investments: investments,
      debts: debts,
    );

    setState(() {
      _result = result;
      _hasCalculated = true;
    });

    // Switch to results tab
    _tabController.animateTo(2);
  }

  void _clearAll() {
    _cashController.clear();
    _savingsController.clear();
    _goldController.clear();
    _silverController.clear();
    _investmentsController.clear();
    _debtsController.clear();

    setState(() {
      _result = null;
      _hasCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Zakat Calculator',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          labelStyle: const TextStyle(fontSize: 16),
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: textColor,
          tabs: const [
            Tab(text: 'Calculator'),
            Tab(text: 'Info'),
            Tab(text: 'Results'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCalculatorTab(), _buildInfoTab(), _buildResultsTab()],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assets Section
            _buildSectionCard(
              title: 'Assets',
              icon: Icons.trending_up,
              children: [
                _buildInputField(
                  controller: _cashController,
                  label: 'Cash on Hand',
                  hint: 'Enter amount in USD',
                  icon: Icons.money,
                ),

                _buildInputField(
                  controller: _savingsController,
                  label: 'Bank Savings',
                  hint: 'Enter amount in USD',
                  icon: Icons.account_balance,
                ),

                _buildInputField(
                  controller: _goldController,
                  label: 'Gold (grams)',
                  hint: 'Enter weight in grams',
                  icon: Icons.diamond,
                ),

                _buildInputField(
                  controller: _silverController,
                  label: 'Silver (grams)',
                  hint: 'Enter weight in grams',
                  icon: Icons.circle,
                ),

                _buildInputField(
                  controller: _investmentsController,
                  label: 'Investments & Stocks',
                  hint: 'Enter amount in USD',
                  icon: Icons.bar_chart,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Debts Section
            _buildSectionCard(
              title: 'Debts & Liabilities',
              icon: Icons.remove_circle_outline,
              children: [
                _buildInputField(
                  controller: _debtsController,
                  label: 'Total Debts',
                  hint: 'Enter amount in USD',
                  icon: Icons.remove_circle_outline,
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateZakat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Calculate Zakat',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: _clearAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: grey,
                    padding: EdgeInsets.all(16.r),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Icon(Icons.clear, color: textColor, size: 20.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final nisabInfo = ZakatService.getNisabInfo();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Zakat Card
          _buildInfoCard(
            title: 'About Zakat',
            icon: Icons.info,
            content:
                'Zakat is one of the Five Pillars of Islam and is a mandatory charitable contribution. It purifies wealth and helps those in need.',
          ),

          SizedBox(height: 16.h),

          // Nisab Information
          _buildInfoCard(
            title: 'Nisab Threshold',
            icon: Icons.scale,
            content: 'The minimum amount of wealth required to pay Zakat.',
            children: [
              _buildInfoRow(
                'Gold Nisab',
                '${nisabInfo.goldNisabGrams}g ≈ \$${nisabInfo.goldNisabValue.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                'Silver Nisab',
                '${nisabInfo.silverNisabGrams}g ≈ \$${nisabInfo.silverNisabValue.toStringAsFixed(2)}',
              ),
              _buildInfoRow('Zakat Rate', '2.5% of qualifying wealth'),
            ],
          ),

          SizedBox(height: 16.h),

          // Calculation Method
          _buildInfoCard(
            title: 'How We Calculate',
            icon: Icons.calculate,
            content:
                'We use the lower nisab threshold and current market prices.',
            children: [
              _buildInfoRow(
                'Gold Price',
                '\$${nisabInfo.goldPricePerGram}/gram',
              ),
              _buildInfoRow(
                'Silver Price',
                '\$${nisabInfo.silverPricePerGram}/gram',
              ),
              _buildInfoRow('Formula', 'Net Wealth × 2.5%'),
            ],
          ),

          SizedBox(height: 16.h),

          // Important Notes
          _buildInfoCard(
            title: 'Important Notes',
            icon: Icons.warning,
            content: '',
            children: [
              _buildBulletPoint(
                'Zakat is due after wealth is held for one lunar year',
              ),
              _buildBulletPoint('Consult a scholar for complex situations'),
              _buildBulletPoint('This calculator provides estimates only'),
              _buildBulletPoint('Prices used are approximate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    if (!_hasCalculated || _result == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate_outlined,
              size: 64.sp,
              color: textColor.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No calculations yet',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: textColor.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Use the calculator tab to get started',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          // Main Result Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _result!.isZakatDue
                    ? [primary.withOpacity(0.1), primary.withOpacity(0.05)]
                    : [orange.withOpacity(0.1), orange.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _result!.isZakatDue
                    ? primary.withOpacity(0.3)
                    : orange.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _result!.isZakatDue ? Icons.check_circle : Icons.info,
                  color: _result!.isZakatDue ? primary : orange,
                  size: 48.sp,
                ),
                SizedBox(height: 12.h),
                Text(
                  _result!.isZakatDue ? 'Zakat Due' : 'No Zakat Due',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                if (_result!.isZakatDue) ...[
                  Text(
                    '\$${_result!.zakatAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Amount to be paid as Zakat',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Your wealth is below nisab',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Breakdown Card
          _buildBreakdownCard(),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    if (_result == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculation Breakdown',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),

          _buildBreakdownRow('Total Assets', _result!.totalAssets),
          _buildBreakdownRow('Gold Value', _result!.goldValue),
          _buildBreakdownRow('Silver Value', _result!.silverValue),
          _buildBreakdownRow(
            'Total Debts',
            _result!.totalDebts,
            isNegative: true,
          ),

          Divider(color: textColor.withOpacity(0.3), thickness: 1),

          _buildBreakdownRow('Net Wealth', _result!.netWealth, isBold: true),
          _buildBreakdownRow('Nisab Threshold', _result!.nisabThreshold),

          if (_result!.isZakatDue) ...[
            Divider(color: textColor.withOpacity(0.3), thickness: 1),
            _buildBreakdownRow(
              'Zakat (2.5%)',
              _result!.zakatAmount,
              isBold: true,
              color: primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isNegative = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          Text(
            '${isNegative ? '-' : ''}\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: color ?? (isNegative ? orange : Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(color: textColor, fontSize: 14.sp),
          hintStyle: GoogleFonts.poppins(
            color: textColor.withOpacity(0.7),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(icon, color: primary, size: 20.sp),
          filled: true,
          fillColor: scaffoldBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final parsed = double.tryParse(value);
            if (parsed == null || parsed < 0) {
              return 'Please enter a valid positive number';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
    List<Widget>? children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              content,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
            ),
          ],
          if (children != null) ...[SizedBox(height: 12.h), ...children],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
