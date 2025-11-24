import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;   // Import class to interact with system services
import 'package:markdown_widget/markdown_widget.dart';    // needed for Third Party Licenses display
import 'package:robur_fit_x/main.dart';

class LicensesPage extends StatelessWidget {              // define a class without a state
  const LicensesPage({super.key});                        // constructor
  final String myLicenseText = '''
# 📜 License $appName

**Copyright (c) 2025, Stefano Bozzi**

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
''';

  // Function to upload all third-party licenses .md file
  // Function returns a Future<String>, meaning it promises to deliver a String 
  // at some point later (asynchronously). The 'async' keyword allows the use of 'await'.
  Future<String> _loadLicenses() async {
    try {
      final thirdPartyLicenses = await rootBundle.loadString('THIRD_PARTY_LICENSES.md');
      
      return myLicenseText + thirdPartyLicenses;
    } catch (e) {
      return 'Error During file upload: THIRD_PARTY_LICENSES.md file not found. Make shure is defined in pubspec.yaml. Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Licenses and Information'),
      ),
      // FutureBuilder load the page in asyncronous mode
      body: FutureBuilder<String>(
        future: _loadLicenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          // when redy renders the MD file
          return MarkdownWidget(
            data: snapshot.data ?? 'Data are not available',
            // optional, text not touching screen side
            padding: const EdgeInsets.all(16.0), 
          );
        },
      ),
    );
  }
}