import 'package:flutter/material.dart';
import 'package:tizaraa/TEST_FOLDER/animation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TaxReturn extends StatefulWidget {
  const TaxReturn({super.key});

  @override
  State<TaxReturn> createState() => _TaxReturnState();
}

class _TaxReturnState extends State<TaxReturn> with TickerProviderStateMixin {
  late final WebViewController _controller;
  int _cartItemCount = 0;
  bool _isLoading = true;
  double _progress = 0;
  bool _isWebViewInitialized = false;
  int _currentIndex = 0;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeWebView();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeWebView() async {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                _progress = progress / 100;
                _isLoading = progress < 100;
              });
            },
            onPageStarted: (String url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              setState(() => _isLoading = false);
              // Inject scripts after page loads
              Future.delayed(const Duration(seconds: 2), () {
                _injectCartMonitoringScript();
                _hideWebViewBottomBar();
                _setInitialZoom();
                _forceMobileView(); // Added to force mobile view
                _hideHeaderElements(); // Added to hide header elements
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() => _isLoading = false);
              debugPrint('WebView error: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) async {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'CartCounter',
          onMessageReceived: (JavaScriptMessage message) {
            try {
              final count = int.parse(message.message);
              setState(() {
                _cartItemCount = count;
              });
              debugPrint('Cart count updated: $_cartItemCount');
            } catch (e) {
              debugPrint('Error parsing cart count: $e');
            }
          },
        )
        ..loadRequest(Uri.parse('https://www.tizaraa.com'));

      setState(() {
        _isWebViewInitialized = true;
      });
    } catch (e) {
      debugPrint('WebView initialization error: $e');
      setState(() {
        _isWebViewInitialized = true;
      });
    }
  }

  Future<void> _hideHeaderElements() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      // First method: Hide by specific selectors
      const headerSelectors = [
        'header', 
        '.header',
        '#header',
        '.site-header',
        '.main-header',
        '.page-header',
        '.top-header',
        '.header-container',
        '.header-wrapper',
        '.header-content',
        '.header-logo',
        '.header-title',
        '.site-name',
        '.site-title',
        '.logo',
        '.branding',
        '.language-selector',
        '.lang-switcher',
        '.currency-selector',
        '.header-actions',
        '.header-top',
        '.header-bottom',
        '.header-middle',
        '.header-nav',
        '.header-menu',
        '.header-tools',
        '.header-search',
        '.search-box',
        '.search-container',
        '.search-wrapper',
        '.search-bar',
        '.header-main', // Specific to your site
        '.header-primary', // Specific to your site
        '.header-secondary', // Specific to your site
        '.header-row', // Specific to your site
        '.header-col', // Specific to your site
        '.header-section', // Specific to your site
        '.header-block', // Specific to your site
        '.header-element', // Specific to your site
        '.header-component', // Specific to your site
        '.header-widget', // Specific to your site
        '.header-module', // Specific to your site
        '.header-area', // Specific to your site
        '.header-zone', // Specific to your site
        '.header-space', // Specific to your site
        '.header-spacer', // Specific to your site
        '.header-gap', // Specific to your site
        '.header-padding', // Specific to your site
        '.header-margin', // Specific to your site
        '.header-border', // Specific to your site
        '.header-divider', // Specific to your site
        '.header-separator', // Specific to your site
        '.header-line', // Specific to your site
        '.header-rule', // Specific to your site
        '.header-break', // Specific to your site
        '.header-hr', // Specific to your site
        '.header-br', // Specific to your site
        // Add more specific selectors from your site
        '#tizaraa-header',
        '.tizaraa-header',
        '.main-logo',
        '.site-logo',
        '.header-logo',
        '.header-brand',
        '.header-identity',
        '.header-name',
        '.header-text',
        '.header-heading',
        '.header-h1',
        '.header-h2',
        '.header-h3',
        '.header-h4',
        '.header-h5',
        '.header-h6',
        '.header-p',
        '.header-span',
        '.header-div',
        '.header-section',
        '.header-article',
        '.header-aside',
        '.header-nav',
        '.header-ul',
        '.header-ol',
        '.header-li',
        '.header-a',
        '.header-button',
        '.header-input',
        '.header-select',
        '.header-form',
        '.header-label',
        '.header-field',
        '.header-control',
        '.header-group',
        '.header-row',
        '.header-col',
        '.header-cell',
        '.header-item',
        '.header-block',
        '.header-box',
        '.header-card',
        '.header-panel',
        '.header-tab',
        '.header-accordion',
        '.header-slider',
        '.header-carousel',
        '.header-gallery',
        '.header-image',
        '.header-video',
        '.header-media',
        '.header-icon',
        '.header-symbol',
        '.header-badge',
        '.header-notification',
        '.header-alert',
        '.header-message',
        '.header-popup',
        '.header-modal',
        '.header-dialog',
        '.header-overlay',
        '.header-backdrop',
        '.header-cover',
        '.header-mask',
        '.header-filter',
        '.header-effect',
        '.header-animation',
        '.header-transition',
        '.header-transform',
        '.header-perspective',
        '.header-3d',
        '.header-parallax',
        '.header-scroll',
        '.header-fixed',
        '.header-sticky',
        '.header-static',
        '.header-relative',
        '.header-absolute',
        '.header-fixed-top',
        '.header-fixed-bottom',
        '.header-sticky-top',
        '.header-sticky-bottom',
        '.header-pinned',
        '.header-floating',
        '.header-docked',
        '.header-anchored',
        '.header-attached',
        '.header-detached',
        '.header-positioned',
        '.header-layered',
        '.header-stacked',
        '.header-z-index',
        '.header-elevation',
        '.header-shadow',
        '.header-border',
        '.header-outline',
        '.header-frame',
        '.header-container',
        '.header-wrapper',
        '.header-inner',
        '.header-content',
        '.header-body',
        '.header-main',
        '.header-section',
        '.header-article',
        '.header-aside',
        '.header-footer',
        '.header-sidebar',
        '.header-column',
        '.header-row',
        '.header-grid',
        '.header-flex',
        '.header-layout',
        '.header-structure',
        '.header-system',
        '.header-theme',
        '.header-skin',
        '.header-style',
        '.header-design',
        '.header-template',
        '.header-pattern',
        '.header-scheme',
        '.header-palette',
        '.header-color',
        '.header-bg',
        '.header-background',
        '.header-image',
        '.header-video',
        '.header-media',
        '.header-overlay',
        '.header-mask',
        '.header-filter',
        '.header-effect',
        '.header-blur',
        '.header-opacity',
        '.header-transparency',
        '.header-gradient',
        '.header-shade',
        '.header-tint',
        '.header-tone',
        '.header-hue',
        '.header-saturation',
        '.header-lightness',
        '.header-brightness',
        '.header-contrast',
        '.header-invert',
        '.header-sepia',
        '.header-grayscale',
        '.header-blend',
        '.header-mode',
        '.header-composite',
        '.header-mix',
        '.header-overlay',
        '.header-multiply',
        '.header-screen',
        '.header-overlay',
        '.header-darken',
        '.header-lighten',
        '.header-color-dodge',
        '.header-color-burn',
        '.header-hard-light',
        '.header-soft-light',
        '.header-difference',
        '.header-exclusion',
        '.header-hue',
        '.header-saturation',
        '.header-color',
        '.header-luminosity'
      ];

      // Second method: Hide by text content
      const textElements = document.querySelectorAll('*');
      textElements.forEach(element => {
        const text = element.textContent || element.innerText || '';
        if (text.includes('Tizaraa') || 
            text.includes('Search by Name') || 
            text.includes('PROTECTING WHAT MATTERS MOST')) {
          element.style.display = 'none !important';
          element.style.visibility = 'hidden !important';
          element.style.height = '0 !important';
          element.style.margin = '0 !important';
          element.style.padding = '0 !important';
        }
      });

      // Third method: Hide by position (top of page)
      const allElements = document.querySelectorAll('*');
      allElements.forEach(element => {
        const rect = element.getBoundingClientRect();
        if (rect.top < 200) { // If element is near top of page
          const style = window.getComputedStyle(element);
          if (style.position === 'fixed' || style.position === 'sticky') {
            element.style.display = 'none !important';
          }
        }
      });

      // Fourth method: Remove empty space at top
      document.body.style.paddingTop = '0 !important';
      document.body.style.marginTop = '0 !important';
      
      // Fifth method: Force scroll to top to prevent any header from showing
      window.scrollTo(0, 0);
      
      console.log('Header elements hidden');
    })();
  ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Header hiding script executed successfully');

      // Run it again after a delay to ensure it sticks
      Future.delayed(const Duration(seconds: 3), () async {
        await _controller.runJavaScript(script);
        debugPrint('Header hiding script executed again');
      });
    } catch (e) {
      debugPrint('Error hiding header elements: $e');
    }
  }

  Future<void> _setInitialZoom() async {
    if (!_isWebViewInitialized) return;

    const script = '''
      (function() {
        // Force mobile viewport settings
        let viewport = document.querySelector('meta[name="viewport"]');
        if (viewport) {
          viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
        } else {
          let meta = document.createElement('meta');
          meta.name = 'viewport';
          meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
          document.getElementsByTagName('head')[0].appendChild(meta);
        }

        // Set body to fit mobile screen
        document.body.style.width = '100%';
        document.body.style.maxWidth = '100vw';
        document.body.style.overflowX = 'hidden';
        document.body.style.margin = '0';
        document.body.style.padding = '0';

        // Disable desktop-specific styles
        const desktopStyles = document.querySelectorAll('style, link[rel="stylesheet"]');
        desktopStyles.forEach(style => {
          const cssText = style.textContent || style.innerHTML || '';
          if (cssText.includes('min-width') || cssText.includes('@media screen and (min-width')) {
            style.disabled = true;
          }
        });

        console.log('Mobile zoom and layout settings applied');
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Mobile zoom script executed successfully');
    } catch (e) {
      debugPrint('Error setting mobile zoom: $e');
    }
  }

  Future<void> _forceMobileView() async {
    if (!_isWebViewInitialized) return;

    const script = '''
      (function() {
        // Hide desktop-specific elements and potentially unwanted header elements
        const desktopSelectors = [
          '.desktop-nav',
          '.header-desktop',
          '.sidebar',
          '.footer-desktop',
          '.nav-desktop',
          '.banner-desktop',
          '.top-bar',
          '.header-bar',
          '[class*="desktop"]',
          '[class*="header"]',
          '[class*="footer"]',
          '[class*="sidebar"]',
          // Added selectors to hide site name, language, and logo
          '.site-name',
          '.site-logo',
          '.header-logo',
          '.language-selector',
          '.currency-selector',
          '#header-name',
          '#header-logo',
          '.header__logo',
          '.header__name',
          '.header__lang-select',
          '.header__currency-select',
          '.top-header', // Often contains branding/language
          '.header-main', // Often contains main header elements
          'h1.site-title', // Common for site names
          '.header-actions .language-switcher', // Example for language selector
          '.header-actions .currency-switcher' // Example for currency selector
        ];

        desktopSelectors.forEach(selector => {
          const elements = document.querySelectorAll(selector);
          elements.forEach(element => {
            element.style.display = 'none !important';
            element.style.visibility = 'hidden !important';
            element.style.height = '0px !important';
            element.style.overflow = 'hidden !important';
          });
        });

        // Force mobile-specific classes to be visible
        const mobileSelectors = [
          '.mobile-nav',
          '.mobile-menu',
          '.mobile-content',
          '[class*="mobile"]'
        ];

        mobileSelectors.forEach(selector => {
          const elements = document.querySelectorAll(selector);
          elements.forEach(element => {
            element.style.display = 'block !important';
            element.style.visibility = 'visible !important';
          });
        });

        // Adjust container widths for mobile
        const containers = document.querySelectorAll('.container, .wrapper, .main-content');
        containers.forEach(container => {
          container.style.width = '100%';
          container.style.maxWidth = '100vw';
          container.style.padding = '0 10px';
          container.style.boxSizing = 'border-box';
        });

        // Remove fixed positioning that might interfere
        const fixedElements = document.querySelectorAll('[style*="position: fixed"]');
        fixedElements.forEach(element => {
          const style = window.getComputedStyle(element);
          if (parseInt(style.top) < 100 && parseInt(style.bottom) < 100) {
            element.style.position = 'relative';
            element.style.top = 'auto';
            element.style.bottom = 'auto';
          }
        });

        console.log('Mobile view optimizations applied');
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Mobile view script executed successfully');
    } catch (e) {
      debugPrint('Error forcing mobile view: $e');
    }
  }

  Future<void> _injectCartMonitoringScript() async {
    if (!_isWebViewInitialized) return;

    const script = '''
      (function() {
        console.log('Cart monitoring script started');
        
        let lastCartCount = 0;
        
        function getCartCount() {
          let count = 0;
          
          // Method 1: Check for cart badge/counter elements
          const cartBadgeSelectors = [
            '.cart-count',
            '.cart-counter', 
            '.badge',
            '.cart-badge',
            '.header-cart-count',
            '.minicart-count',
            '.cart-qty',
            '.cart-quantity',
            '[data-cart-count]',
            '.shopping-cart-count',
            '.cart-item-count',
            '.navbar-cart-count'
          ];
          
          for (let selector of cartBadgeSelectors) {
            const elements = document.querySelectorAll(selector);
            for (let element of elements) {
              const text = element.textContent || element.innerText || element.getAttribute('data-count') || '';
              const num = parseInt(text.replace(/[^0-9]/g, ''));
              if (!isNaN(num) && num > count) {
                count = num;
              }
            }
          }
          
          // Method 2: Check localStorage for cart data
          try {
            const cartData = localStorage.getItem('cart') || localStorage.getItem('shopping_cart') || localStorage.getItem('cartItems');
            if (cartData) {
              const parsed = JSON.parse(cartData);
              if (Array.isArray(parsed)) {
                count = Math.max(count, parsed.length);
              } else if (parsed.items && Array.isArray(parsed.items)) {
                count = Math.max(count, parsed.items.length);
              } else if (typeof parsed === 'object' && parsed.count) {
                count = Math.max(count, parseInt(parsed.count));
              }
            }
          } catch (e) {
            console.log('Error reading cart from localStorage:', e);
          }
          
          // Method 3: Check global cart variables
          try {
            if (window.cart && Array.isArray(window.cart)) {
              count = Math.max(count, window.cart.length);
            }
            if (window.cartItems && Array.isArray(window.cartItems)) {
              count = Math.max(count, window.cartItems.length);
            }
          } catch (e) {
            console.log('Error checking global cart variables:', e);
          }
          
          return count;
        }
        
        function updateCartCount() {
          const currentCount = getCartCount();
          
          if (currentCount !== lastCartCount) {
            lastCartCount = currentCount;
            console.log('Cart count changed to:', currentCount);
            
            // Send to Flutter app
            if (window.CartCounter) {
              CartCounter.postMessage(currentCount.toString());
            }
          }
        }
        
        // Initial check
        setTimeout(updateCartCount, 1000);
        
        // Monitor DOM changes
        const observer = new MutationObserver(function(mutations) {
          setTimeout(updateCartCount, 500);
        });
        
        observer.observe(document.body, {
          childList: true,
          subtree: true,
          attributes: true,
          characterData: true
        });
        
        // Monitor localStorage changes
        const originalSetItem = localStorage.setItem;
        localStorage.setItem = function(key, value) {
          originalSetItem.apply(this, arguments);
          if (key.toLowerCase().includes('cart')) {
            setTimeout(updateCartCount, 200);
          }
        };
        
        // Monitor clicks on add to cart buttons
        document.addEventListener('click', function(e) {
          const target = e.target;
          const button = target.closest('button, a, .btn');
          if (button) {
            const text = button.textContent || button.innerText || '';
            if (text.toLowerCase().includes('add') && 
                (text.toLowerCase().includes('cart') || text.toLowerCase().includes('bag'))) {
              setTimeout(updateCartCount, 1000);
            }
          }
        });
        
        // Periodic check every 3 seconds
        setInterval(updateCartCount, 3000);
        
        console.log('Cart monitoring initialized');
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Cart monitoring script injected successfully');
    } catch (e) {
      debugPrint('Error injecting cart monitoring script: $e');
    }
  }

  Future<void> _hideWebViewBottomBar() async {
    if (!_isWebViewInitialized) return;

    const script = '''
      (function() {
        // Hide bottom navigation elements
        const bottomNavSelectors = [
          '.bottom-nav',
          '.bottom-navigation',
          '.navbar-bottom',
          '.footer-nav',
          '.mobile-nav',
          '.tab-bar',
          '.bottom-bar',
          '.mobile-bottom-nav',
          '[role="tablist"]',
          '.navbar-fixed-bottom',
          '.bottom-menu',
          '.footer',
          '.site-footer',
          '.bottom-container',
          '.mobile-footer'
        ];
        
        bottomNavSelectors.forEach(selector => {
          const elements = document.querySelectorAll(selector);
          elements.forEach(element => {
            element.style.display = 'none !important';
            element.style.visibility = 'hidden !important';
            element.style.height = '0px !important';
            element.style.overflow = 'hidden !important';
          });
        });
        
        // Remove bottom padding since we're using floating buttons
        document.body.style.paddingBottom = '20px';
        
        // Also check for fixed positioned elements at bottom
        const allElements = document.querySelectorAll('*');
        allElements.forEach(element => {
          const style = window.getComputedStyle(element);
          if (style.position === 'fixed' && 
              (style.bottom === '0px' || parseInt(style.bottom) <= 80)) {
            if (element.offsetHeight < 120) {
              element.style.display = 'none !important';
            }
          }
        });
        
        console.log('Bottom navigation hidden');
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Bottom bar hiding script executed successfully');
    } catch (e) {
      debugPrint('Error hiding webview bottom bar: $e');
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    if (_isMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
      _isMenuOpen = false;
    });
    _animationController.reverse();

    if (!_isWebViewInitialized) return;

    // Navigate to different sections
    String url = 'https://www.tizaraa.com';
    switch (index) {
      case 0: // Home
        url = 'https://www.tizaraa.com';
        break;
      case 1: // Categories
        url = 'https://www.tizaraa.com/mobile-category-nav';
        break;
      case 2: // Cart
        url = 'https://www.tizaraa.com/cart';
        break;
      case 3: // Account
        url = 'https://www.tizaraa.com/login';
        break;
    }

    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isWebViewInitialized
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
            ),
            SizedBox(height: 16),
            Text('Loading Tizaraa...'),
          ],
        ),
      )
          : Stack(
        children: [
          // Full screen WebView with background
          Container(
            color: const Color(0xFFF8F9FA), // Slightly warmer background
            child: Column(
              children: [
                // Enhanced App Bar
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                ),

                // Progress Indicator
                if (_isLoading)
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                  ),

                // Expanded WebView
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
          ),

          Positioned(
            child: AnimatedEcommerceHeader(),
              // child: Container(
              //   height: 112,
              //   width: MediaQuery.of(context).size.width,
              //   color: Colors.red[400],
              //   child: Center(child: Padding(
              //     padding: const EdgeInsets.only(top: 30),
              //     child: Text("Tizaraa",style: TextStyle(color: Colors.white,fontSize: 25),),
              //   )),
              // ),
          ),
          // Floating Action Buttons for Navigation
          Positioned(
            bottom: 0, // Changed to 0 to make it full width at the bottom
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Cart Count Badge
                if (_cartItemCount > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '$_cartItemCount items in cart',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Bottom Navigation Bar with Floating Buttons
                Container(
                  // Removed horizontal margin for full width
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Removed borderRadius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavBarItem(Icons.home_rounded, 0, 'Home'),
                      _buildNavBarItem(Icons.dashboard_rounded, 1, 'Categories'),
                      _buildNavBarItem(Icons.shopping_cart_rounded, 2, 'Cart', showBadge: true),
                      _buildNavBarItem(Icons.menu, 3, 'Menu'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index, String label, {bool showBadge = false}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[600],
                size: 28,
              ),
              if (showBadge && _cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}