import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sign In Controllers
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  
  // Sign Up Controllers
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  
  // Form Keys
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  
  // State
  bool _isSignInPasswordVisible = false;
  bool _isSignUpPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  Future<void> _handleSignIn() async {
  setState(() {
    _errorMessage = null;
  });

  if (!_signInFormKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    await AuthService.login(
      email: _signInEmailController.text.trim(),
      password: _signInPasswordController.text,
    );

    if (mounted) {
      // ✅ GO TO HOME AFTER LOGIN
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

 Future<void> _handleSignUp() async {
  setState(() {
    _errorMessage = null;
  });

  if (!_signUpFormKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    await AuthService.register(
      name: _signUpNameController.text.trim(),
      email: _signUpEmailController.text.trim(),
      password: _signUpPasswordController.text,
    );

    if (mounted) {
      // ✅ GO TO LOGIN AFTER REGISTER
      Navigator.pushReplacementNamed(context, '/login');
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1DB88E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cambodia Moto',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Easy ride. Easy rent',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Tab Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: const Color(0xFF1DB88E),
                    unselectedLabelColor: const Color(0xFF6B7280),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null && _errorMessage!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Tab Views - INCREASED HEIGHT HERE
                SizedBox(
                  height: 450, // Increased from 380 to 450
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSignInForm(),
                      _buildSignUpForm(),
                    ],
                  ),
                ),
                
                const SizedBox(height:0),
                const Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFFD1D5DB)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: SingleChildScrollView( // Added ScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildTextField(_signInEmailController, 'Enter your email', Icons.email_outlined, validator: _validateEmail),
            const SizedBox(height: 20),
            const Text('Password', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildTextField(
              _signInPasswordController, 
              'Enter your password', 
              Icons.lock_outline, 
              isPassword: true, 
              isVisible: _isSignInPasswordVisible,
              onToggle: () => setState(() => _isSignInPasswordVisible = !_isSignInPasswordVisible),
              validator: _validatePassword,
            ),
            const SizedBox(height: 28),
            _buildSubmitButton('Sign In', _handleSignIn),
            const SizedBox(height: 20),
            const Center(child: Text('Welcome', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)))),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: SingleChildScrollView( // Added ScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Full Name', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildTextField(_signUpNameController, 'Enter your full name', Icons.person_outline, validator: _validateName),
            const SizedBox(height: 16),
            const Text('Email', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildTextField(_signUpEmailController, 'Enter your email', Icons.email_outlined, validator: _validateEmail),
            const SizedBox(height: 16),
            const Text('Password', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8), // FIXED: Changed from 100 to 8
            _buildTextField(
              _signUpPasswordController, 
              'Create a password', 
              Icons.lock_outline, 
              isPassword: true, 
              isVisible: _isSignUpPasswordVisible,
              onToggle: () => setState(() => _isSignUpPasswordVisible = !_isSignUpPasswordVisible),
              validator: _validatePassword,
            ),
            const SizedBox(height: 24),
            _buildSubmitButton('Create Account', _handleSignUp),
            const SizedBox(height: 16),
            const Center(child: Text('Welcome', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)))),
          ],
        ),
      ),
    );
  }

  // Helper widget to reduce code duplication
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, bool isVisible = false, VoidCallback? onToggle, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 22),
          onPressed: onToggle,
        ) : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1DB88E), width: 2)),
      ),
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DB88E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }
}