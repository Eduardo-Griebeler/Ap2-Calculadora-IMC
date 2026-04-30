import 'package:flutter/material.dart';

void main() => runApp(const BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key}); // Adicionada a KEY solicitada

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'sans-serif',
      ),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key}); // Adicionada a KEY solicitada

  @override
  State<BMICalculator> createState() => _BMICalculatorState(); // Corrigido erro de Private API
}

class _BMICalculatorState extends State<BMICalculator> {
  bool isMale = true;
  final TextEditingController _weightController = TextEditingController(text: "80");
  final TextEditingController _heightController = TextEditingController(text: "175");
  
  double? _bmiResult;
  String _category = "";
  String _errorMsg = "";

  void _calculateBMI() {
    setState(() {
      _errorMsg = "";
      try {
        double weight = double.parse(_weightController.text);
        double heightCm = double.parse(_heightController.text);

        if (heightCm <= 0 || weight <= 0) {
          _errorMsg = "Please enter values greater than zero.";
          _bmiResult = null;
          return;
        }

        double heightM = heightCm / 100;
        _bmiResult = weight / (heightM * heightM);

        if (_bmiResult! < 18.5) {
          _category = "Underweight";
        } else if (_bmiResult! < 25) {
          _category = "Normal";
        } else if (_bmiResult! < 30) {
          _category = "Overweight";
        } else {
          _category = "Obesity";
        }
      } catch (e) {
        _errorMsg = "Invalid input. Use numbers only.";
        _bmiResult = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Your body", style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => _showInfo(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("BMI Calculator", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGenderOption("Male", "👨🏻", isMale, () => setState(() => isMale = true)),
                _buildGenderOption("Female", "👩🏻", !isMale, () => setState(() => isMale = false)),
              ],
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(child: _buildInputField("Your weight (kg)", _weightController)),
                const SizedBox(width: 40),
                Expanded(child: _buildInputField("Your height (cm)", _heightController)),
              ],
            ),
            
            if (_errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(_errorMsg, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),

            const SizedBox(height: 50),

            if (_bmiResult != null) ...[
              Center(
                child: Column(
                  children: [
                    const Text("Your BMI", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    Text(_bmiResult!.toStringAsFixed(1), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    Text(_category, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => setState(() => _bmiResult = null),
                      child: const Text("Calculate BMI again", style: TextStyle(color: Color(0xFF5EBCE5))),
                    ),
                  ],
                ),
              ),
            ] else
              SizedBox( // Trocado Container por SizedBox conforme o aviso azul
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EBCE5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Calculate your BMI", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, String emoji, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: isActive ? const Color(0xFFE1F5FE) : Colors.grey[100],
            child: Opacity( // FORMA CORRETA de aplicar opacidade (resolve o erro vermelho)
              opacity: isActive ? 1.0 : 0.4,
              child: Text(emoji, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: isActive ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
          ),
        ),
      ],
    );
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, color: Colors.black, margin: const EdgeInsets.only(bottom: 20)),
            const Text("BMI categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            _infoRow("Less than 18.5", "you're underweight."),
            _infoRow("18.5 to 24.9", "you're normal."),
            _infoRow("25 to 29.9", "you're overweight."),
            _infoRow("30 or more", "obesity."),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 22, color: Colors.grey, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}
