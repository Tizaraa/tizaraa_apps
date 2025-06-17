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

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void dispose() {
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
              Future.delayed(const Duration(seconds: 2), () {
                _injectCartMonitoringScript();
                _hideWebViewBottomBar();
                _setInitialZoom();
                _forceMobileView();
                _hideHeaderElements();
                _resizeButtons();
                _ensureContentVisibility();
                _highlightBrandDeliveryInfo(); // New method to highlight brand/delivery
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

  // New method to highlight and ensure brand/delivery info is visible
  Future<void> _highlightBrandDeliveryInfo() async {
    if (!_isWebViewInitialized) return;

    const script = '''
    (function() {
      console.log('Highlighting brand and delivery information...');
      
      // Target the specific brand/delivery container and elements
      const brandDeliveryContainer = document.querySelector('.sc-744a8572-0 eZlinV');
      const brandDeliveryElements = document.querySelectorAll('.sc-744a8572-0 eZlinV');
      
      if (brandDeliveryContainer) {
        // Make sure the container is visible and styled nicely
        brandDeliveryContainer.style.setProperty('display', 'block', 'important');
        brandDeliveryContainer.style.setProperty('visibility', 'visible', 'important');
        brandDeliveryContainer.style.setProperty('opacity', '1', 'important');
        brandDeliveryContainer.style.setProperty('background-color', '#f8f9fa', 'important');
        brandDeliveryContainer.style.setProperty('padding', '12px', 'important');
        brandDeliveryContainer.style.setProperty('margin', '8px 0', 'important');
        brandDeliveryContainer.style.setProperty('border-radius', '8px', 'important');
        brandDeliveryContainer.style.setProperty('border', '1px solid #e9ecef', 'important');
        brandDeliveryContainer.style.setProperty('position', 'relative', 'important');
        brandDeliveryContainer.style.setProperty('z-index', '999', 'important');
        
        console.log('Brand/Delivery container styled successfully');
      }
      
      // Style individual brand and delivery elements
      brandDeliveryElements.forEach((element, index) => {
        element.style.setProperty('display', 'block', 'important');
        element.style.setProperty('visibility', 'visible', 'important');
        element.style.setProperty('opacity', '1', 'important');
        element.style.setProperty('font-size', '14px', 'important');
        element.style.setProperty('color', '#6c757d', 'important');
        element.style.setProperty('margin', '4px 0', 'important');
        element.style.setProperty('font-weight', '500', 'important');
        element.style.setProperty('line-height', '1.4', 'important');
        
        // Add icons for better visual appeal
        const text = element.textContent.trim();
        if (text.includes('Brand:')) {
          element.style.setProperty('position', 'relative', 'important');
          element.innerHTML = '🏷️ ' + text;
        } else if (text.includes('Delivery:')) {
          element.style.setProperty('position', 'relative', 'important');
          element.innerHTML = '🚚 ' + text;
        }
        
        console.log('Brand/Delivery element ' + index + ' styled: ' + text);
      });
      
      // Ensure the parent elements don't hide these
      const allParents = [];
      if (brandDeliveryContainer) {
        let parent = brandDeliveryContainer.parentElement;
        while (parent && parent !== document.body) {
          allParents.push(parent);
          parent = parent.parentElement;
        }
      }
      
      allParents.forEach(parent => {
        parent.style.setProperty('display', 'block', 'important');
        parent.style.setProperty('visibility', 'visible', 'important');
        parent.style.setProperty('opacity', '1', 'important');
      });
      
      console.log('Brand and delivery information highlighting completed');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Brand/Delivery highlighting script executed successfully');
    } catch (e) {
      debugPrint('Error highlighting brand/delivery info: $e');
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
        '.logo',
        '.language-selector',
        '.currency-selector',
        '.header__lang-select',
        '.header__currency-select'
      ];

      headerSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(element => {
          // Skip if it contains brand/delivery info
          if (element.querySelector('.sc-744a8572-0 eZlinV') || 
              element.querySelector('.sc-744a8572-0 eZlinV')) {
            return;
          }
          
          element.style.display = 'none !important';
          element.style.visibility = 'hidden !important';
          element.style.height = '0px !important';
          element.style.overflow = 'hidden !important';
        });
      });

      document.body.style.paddingTop = '0 !important';
      document.body.style.marginTop = '0 !important';
      
      window.scrollTo(0, 0);
      
      console.log('Header elements hidden (preserving brand/delivery)');
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
          // Skip if contains brand/delivery info
          if (element.querySelector('.sc-744a8572-0 eZlinV') || 
              element.querySelector('.sc-744a8572-0 eZlinV')) {
            return;
          }
          
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

      console.log('Mobile view optimizations applied (preserving brand/delivery)');
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

      // Ensure brand/delivery elements are always visible
      const brandDeliveryElements = document.querySelectorAll('.sc-744a8572-0 eZlinV, .sc-744a8572-0 eZlinV');
      brandDeliveryElements.forEach(element => {
        element.style.display = 'block !important';
        element.style.visibility = 'visible !important';
        element.style.opacity = '1 !important';
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
          '.badge',
          '.cart-badge',
          '.header-cart-count',
          '.minicart-count',
          '.cart-qty',
          '.cart-quantity',
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
      console.log('Starting to hide website footer sections...');
      
      const footerSelectors = [
        'footer',
        '.footer',
        '#footer'
      ];
      
      footerSelectors.forEach(selector => {
        try {
          const elements = document.querySelectorAll(selector);
          
          elements.forEach(element => {
            // IMPORTANT: Skip elements that contain brand or delivery divs
            if (element.querySelector('.sc-744a8572-0 eZlinV') || 
                element.querySelector('.sc-744a8572-0 eZlinV')) {
              console.log('Preserving footer element with brand/delivery info');
              return;
            }
            
            const rect = element.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            const elementText = (element.textContent || '').toLowerCase();
            
            const isLikelyFooter = (
              rect.top > windowHeight * 0.5 ||
              elementText.includes('copyright') ||
              elementText.includes('©') ||
              elementText.includes('all rights reserved') ||
              elementText.includes('terms of service') ||
              elementText.includes('privacy policy') ||
              elementText.includes('contact us') ||
              elementText.includes('about us') ||
              selector.toLowerCase().includes('footer')
            );
            
            const isEssentialCart = (
              elementText.includes('add to cart') ||
              elementText.includes('checkout') ||
              elementText.includes('place order') ||
              elementText.includes('proceed to checkout') ||
              elementText.includes('total:') ||
              elementText.includes('subtotal:') ||
              elementText.includes('quantity') ||
              elementText.includes('remove from cart') ||
              elementText.includes('brand:') ||
              elementText.includes('delivery:') ||
              element.querySelector('button[type="submit"]') ||
              element.querySelector('.btn-checkout') ||
              element.querySelector('.checkout-btn') ||
              element.querySelector('.add-to-cart') ||
              element.closest('.cart-summary') ||
              element.closest('.checkout-summary')
            );
            
            if (isLikelyFooter && !isEssentialCart) {
              console.log('Hiding footer element:', selector);
              element.style.setProperty('display', 'none', 'important');
              element.style.setProperty('visibility', 'hidden', 'important');
              element.style.setProperty('height', '0px', 'important');
              element.style.setProperty('max-height', '0px', 'important');
              element.style.setProperty('overflow', 'hidden', 'important');
              element.style.setProperty('margin', '0px', 'important');
              element.style.setProperty('padding', '0px', 'important');
              element.style.setProperty('opacity', '0', 'important');
            }
          });
        } catch (e) {
          console.log('Error processing footer selector:', selector, e);
        }
      });
      
      // Handle other text elements but preserve brand/delivery
      const allTextElements = document.querySelectorAll('*');
      allTextElements.forEach(element => {
        try {
          // CRITICAL: Skip brand/delivery elements
          if (element.classList.contains('sc-744a8572-0') || 
              element.classList.contains('sc-a04e3fd4-0') ||
              element.classList.contains('eZlinV') ||
              element.classList.contains('ezmVRN')) {
            return;
          }
          
          const text = (element.textContent || element.innerText || '').trim().toLowerCase();
          
          if (text.length > 500) return;
          
          const cartTerms = [
            'add to cart', 'checkout', 'place order', 'total:', 'subtotal:', 
            'quantity', 'price:', 'remove', 'brand:', 'delivery:'
          ];
          if (cartTerms.some(term => text.includes(term))) return;
          
          const footerIndicators = [
            'copyright', '©', 'all rights reserved',
            'terms of service', 'terms of use', 'terms & conditions',
            'privacy policy', 'cookie policy',
            'contact us', 'about us', 'help center',
            'follow us', 'social media',
            'newsletter', 'subscribe',
            'site map', 'sitemap'
          ];
          
          const hasFooterContent = footerIndicators.some(indicator => text.includes(indicator));
          
          if (hasFooterContent) {
            const rect = element.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            
            if (rect.top > windowHeight * 0.6) {
              console.log('Hiding footer content element:', text.substring(0, 50));
              element.style.setProperty('display', 'none', 'important');
              element.style.setProperty('visibility', 'hidden', 'important');
              element.style.setProperty('opacity', '0', 'important');
            }
          }
        } catch (e) {}
      });
      
      document.body.style.setProperty('padding-bottom', '0px', 'important');
      document.body.style.setProperty('margin-bottom', '0px', 'important');
      
      const htmlElement = document.documentElement;
      htmlElement.style.setProperty('padding-bottom', '0px', 'important');
      htmlElement.style.setProperty('margin-bottom', '0px', 'important');
      
      const stickyElements = document.querySelectorAll('[style*="position: fixed"], [style*="position: sticky"]');
      stickyElements.forEach(element => {
        // CRITICAL: Skip brand/delivery elements
        if (element.classList.contains('sc-744a8572-0') || 
            element.classList.contains('sc-a04e3fd4-0') ||
            element.classList.contains('eZlinV') ||
            element.classList.contains('ezmVRN')) {
          return;
        }
        
        const style = window.getComputedStyle(element);
        const bottom = style.bottom;
        
        if (bottom === '0px' || parseInt(bottom) >= 0) {
          const text = (element.textContent || '').toLowerCase();
          const isFooterLike = text.includes('copyright') || text.includes('©') || text.includes('terms') || text.includes('privacy');
          const isCartFunctional = text.includes('checkout') || text.includes('add to cart') || text.includes('total') || 
                                  text.includes('brand:') || text.includes('delivery:');
          
          if (isFooterLike && !isCartFunctional) {
            console.log('Hiding sticky footer element');
            element.style.setProperty('display', 'none', 'important');
            element.style.setProperty('visibility', 'hidden', 'important');
          }
        }
      });
      
      document.body.offsetHeight;
      
      console.log('Website footer hiding completed (brand/delivery preserved)');
    })();
    ''';

    try {
      await _controller.runJavaScript(script);
      debugPrint('Website footer hiding script executed successfully');
    } catch (e) {
      debugPrint('Error hiding website footer: $e');
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

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