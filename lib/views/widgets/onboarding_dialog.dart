import 'package:flutter/material.dart';

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Tour steps defined in English and linked to .webp assets
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Create a Template',
      'description': 'Go to the Workouts page to see all your templates. Tap "New Template" to create a new one.',
      'imagePath': 'assets/tour/tour_newtemplate.webp',
    },
    {
      'title': 'Start a Session',
      'description': 'Navigate to the Calendar page and tap "New Session". Choose your template and start your workout.',
      'imagePath': 'assets/tour/tour_session1.webp',
    },
    {
      'title': 'Track Your Progress',
      'description': 'When logging a session, your past weights are displayed. Colored arrows show your trend: green (progress), orange (regress), or blue (stall).',
      'imagePath': 'assets/tour/tour_session2.webp',
    },
    {
      'title': 'Options Menu',
      'description': 'Open the side menu to access additional app features.',
      'imagePath': 'assets/tour/tour_options.webp',
    },
    {
      'title': 'Statistics',
      'description': 'Analyze your workout data and track your improvements over time.',
      'imagePath': 'assets/tour/tour_statistics.webp',
    },
    {
      'title': 'Settings',
      'description': 'Customize the app preferences in the Settings page.',
      'imagePath': 'assets/tour/tour_settings.webp',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context); // Closes the dialog
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate screed dimension and adapt overall size
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: const EdgeInsets.all(16.0), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: screenSize.height * 0.85, // 85% of screen height
        width: screenSize.width * 0.95,   // 95% of screen height
        child: Column(
          children: [
            // --- MEDIA AREA (WebP) ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                page['imagePath'],
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            page['title'],
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page['description'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- CONTROLS AREA ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SKIP / BACK Button
                  TextButton(
                    onPressed: _currentPage == 0 ? () => Navigator.pop(context) : _previousPage,
                    child: Text(_currentPage == 0 ? 'SKIP' : 'BACK'),
                  ),

                  // Dots indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // NEXT / START Button
                  TextButton(
                    onPressed: _nextPage,
                    child: Text(_currentPage == _pages.length - 1 ? 'START!' : 'NEXT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}