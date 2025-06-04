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
                _forceMobileView();
                _hideHeaderElements();
                _resizeButtons();
                _ensureContentVisibility();
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

  Future<void> _resizeButtons() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      const checkoutButtons = document.querySelectorAll(
        'button, a.btn, input[type="submit"], .btn-checkout, .checkout-button'
      );
      
      checkoutButtons.forEach(button => {
        button.style.fontSize = '14px !important';
        button.style.padding = '8px 12px !important';
        button.style.height = 'auto !important';
      });
      
      const navIcons = document.querySelectorAll(
        '.nav-icon, .home-icon, .menu-icon, [class*="icon"]'
      );
      
      navIcons.forEach(icon => {
        icon.style.width = '24px !important';
        icon.style.height = '24px !important';
        icon.style.fontSize = '24px !important';
      });
      
      console.log('Buttons and icons resized');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Button resizing script executed successfully');
    } catch (e) {
      debugPrint('Error resizing buttons: $e');
    }
  }

  Future<void> _hideHeaderElements() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      const headerSelectors = [
        '.site-header',
        '.main-header',
        '.top-header',
        '.header-container',
        '.header-logo',
        '.site-name',
        '.site-title',
        '.logo',
        '.language-selector',
        '.currency-selector',
        '.header__lang-select',
        '.header__currency-select'
      ];

      headerSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(element => {
          element.style.display = 'none !important';
          element.style.visibility = 'hidden !important';
          element.style.height = '0px !important';
          element.style.overflow = 'hidden !important';
        });
      });

      document.body.style.paddingTop = '0 !important';
      document.body.style.marginTop = '0 !important';
      
      window.scrollTo(0, 0);
      
      console.log('Header elements hidden');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Header hiding script executed successfully');
    } catch (e) {
      debugPrint('Error hiding header elements: $e');
    }
  }

  Future<void> _setInitialZoom() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      let viewport = document.querySelector('meta[name="viewport"]');
      if (viewport) {
        viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes');
      } else {
        let meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes';
        document.getElementsByTagName('head')[0].appendChild(meta);
      }

      document.body.style.width = '100%';
      document.body.style.maxWidth = '100vw';
      document.body.style.overflowX = 'hidden';
      document.body.style.margin = '0';
      document.body.style.padding = '0';

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
      const desktopSelectors = [
        '.desktop-nav',
        '.header-desktop',
        '.footer-desktop',
        '.nav-desktop',
        '.banner-desktop',
        '.top-bar'
      ];

      desktopSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(element => {
          element.style.display = 'none !important';
          element.style.visibility = 'hidden !important';
        });
      });

      const mobileSelectors = [
        '.mobile-nav',
        '.mobile-menu',
        '.mobile-content'
      ];

      mobileSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(element => {
          element.style.display = 'block !important';
          element.style.visibility = 'visible !important';
        });
      });

      const containers = document.querySelectorAll('.container, .wrapper, .main-content');
      containers.forEach(container => {
        container.style.width = '100%';
        container.style.maxWidth = '100vw';
        container.style.padding = '0 10px';
        container.style.boxSizing = 'border-box';
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

  Future<void> _ensureContentVisibility() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      const mainContent = document.querySelectorAll('main, .main, .content, .main-content, .product-grid, .products, .category-products');
      mainContent.forEach(element => {
        element.style.display = 'block !important';
        element.style.visibility = 'visible !important';
        element.style.opacity = '1 !important';
        element.style.height = 'auto !important';
        element.style.minHeight = '100% !important';
      });

      const productItems = document.querySelectorAll('.product, .product-item, .item, .product-card');
      productItems.forEach(item => {
        item.style.display = 'block !important';
        item.style.visibility = 'visible !important';
        item.style.opacity = '1 !important';
        item.style.height = 'auto !important';
      });

      console.log('Main content and products visibility ensured');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Content visibility script executed successfully');
    } catch (e) {
      debugPrint('Error ensuring content visibility: $e');
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
          
          if (window.CartCounter) {
            CartCounter.postMessage(currentCount.toString());
          }
        }
      }
      
      setTimeout(updateCartCount, 1000);
      
      const observer = new MutationObserver(function(mutations) {
        setTimeout(updateCartCount, 500);
      });
      
      observer.observe(document.body, {
        childList: true,
        subtree: true,
        attributes: true,
        characterData: true
      });
      
      const originalSetItem = localStorage.setItem;
      localStorage.setItem = function(key, value) {
        originalSetItem.apply(this, arguments);
        if (key.toLowerCase().includes('cart')) {
          setTimeout(updateCartCount, 200);
        }
      };
      
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
      const footerSelectors = [
        'footer',
        '.footer',
        '#footer',
        '.site-footer',
        '.footer-container'
      ];
      
      footerSelectors.forEach(selector => {
        try {
          const elements = document.querySelectorAll(selector);
          elements.forEach(element => {
            element.style.display = 'none !important';
            element.style.visibility = 'hidden !important';
            element.style.height = '0px !important';
            element.style.maxHeight = '0px !important';
            element.style.overflow = 'hidden !important';
            element.style.margin = '0px !important';
            element.style.padding = '0px !important';
          });
        } catch (e) {
          console.log('Error with footer selector:', selector, e);
        }
      });

      const footerTexts = ['copyright', '©', 'all rights reserved', 'terms', 'privacy', 'footer'];
      const allElements = document.querySelectorAll('*');
      allElements.forEach(element => {
        try {
          const text = (element.textContent || element.innerText || '').toLowerCase();
          if (footerTexts.some(footerText => text.includes(footerText))) {
            const rect = element.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            if (rect.top > windowHeight * 0.7) {
              element.style.display = 'none !important';
              element.style.visibility = 'hidden !important';
            }
          }
        } catch (e) {}
      });

      document.body.style.paddingBottom = '0px !important';
      document.body.style.marginBottom = '0px !important';
      document.documentElement.style.paddingBottom = '0px !important';
      document.documentElement.style.marginBottom = '0px !important';

      console.log('Footer elements hidden');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Footer hiding script executed successfully');
    } catch (e) {
      debugPrint('Error hiding webview footer: $e');
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
          ],
        ),
      )
          : Stack(
        children: [
          Container(
            color: const Color(0xFFF8F9FA),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                ),
                if (_isLoading)
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                  ),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
          ),
          Positioned(
            child: AnimatedEcommerceHeader(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                size: 24,
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