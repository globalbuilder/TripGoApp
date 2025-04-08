import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatefulWidget {
  static const routeName = '/currency-converter';

  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _convertedAmount = 0.0;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'EGP', 'SAR'];

  // Hard-coded sample rates (relative to USD)
  // In real code, you'd fetch from an API or store them dynamically.
  final Map<String, double> _exchangeRatesToUSD = {
    'USD': 1.0,
    'EUR': 1.07, // 1 USD = ~1.07 EUR (example rate)
    'GBP': 1.24,
    'EGP': 0.032,
    'SAR': 0.27,
  };

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    // Convert to USD first
    final rateFrom = _exchangeRatesToUSD[_fromCurrency] ?? 1.0;
    // e.g., if fromCurrency is EUR -> rateFrom might be 1.07 means 1 EUR = 1.07 USD

    // Convert from the input to USD
    final inUSD = amount / rateFrom;

    // Then convert from USD to target
    final rateTo = _exchangeRatesToUSD[_toCurrency] ?? 1.0;
    final converted = inUSD * rateTo;

    setState(() {
      _convertedAmount = converted;
    });
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
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Convert from one currency to another",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Amount TextField
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 12),

            // From/To Currencies
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromCurrency,
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    items: _currencies.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _fromCurrency = val ?? 'USD');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right_alt_rounded, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toCurrency,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    items: _currencies.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _toCurrency = val ?? 'EUR');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text("Convert"),
            ),
            const SizedBox(height: 16),

            // Result
            Text(
              _convertedAmount == 0.0
                  ? ""
                  : "Converted: ${_convertedAmount.toStringAsFixed(2)} $_toCurrency",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
