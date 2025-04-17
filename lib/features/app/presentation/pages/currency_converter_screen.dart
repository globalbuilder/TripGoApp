import 'package:flutter/material.dart';
import '../../../../core/utils/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  static const routeName = '/currency-converter';
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'SAR';
  double _convertedAmount = 0.0;
  bool _loading = true;
  Map<String, double> _rates = {};
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'EGP', 'SAR'];

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    try {
      final rates = await CurrencyService().fetchExchangeRates();
      setState(() {
        _rates = rates.map((k, v) => MapEntry(k, v.toDouble()));
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching rates: $e')),
      );
    }
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (_rates.isEmpty) return;
    final from = _rates[_fromCurrency] ?? 1.0;
    final to = _rates[_toCurrency] ?? 1.0;
    setState(() => _convertedAmount = amount / from * to);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text('Convert between currencies', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _fromCurrency,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'From'),
                          items: _currencies
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _fromCurrency = v!),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.swap_horiz),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _toCurrency,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'To'),
                          items: _currencies
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _toCurrency = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _convert, child: const Text('Convert')),
                  const SizedBox(height: 16),
                  if (_convertedAmount > 0)
                    Text(
                      '$_convertedAmount $_toCurrency',
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                ],
              ),
      ),
    );
  }
}
