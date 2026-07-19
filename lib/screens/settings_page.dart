import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehaty/core/appcolors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary.withOpacity(0.15), AppColors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الإعدادات',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تحكم في إعدادات التطبيق',
                          style: TextStyle(color: AppColors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _buildTile(
                    Icons.account_circle,
                    'إعدادات الحساب',
                    () {},
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 4),
                  _buildTile(
                    Icons.lock,
                    'كلمة السر',
                    () {},
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 4),
                  _buildTile(
                    Icons.notifications,
                    'إعدادات الشعارات',
                    () {},
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 4),
                  _buildTile(
                    Icons.privacy_tip,
                    'الخصوصية',
                    () {},
                    color: Colors.green,
                  ),
                  const SizedBox(height: 4),
                  _buildTile(
                    Icons.help,
                    'المساعدة والدعم',
                    () {},
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 4),
                  _buildTile(
                    Icons.share,
                    'دعوة صديق',
                    () {},
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  _buildTile(
                    Icons.logout,
                    'تسجيل الخروج',
                    () => _logout(context),
                    color: Colors.red,
                    isLogout: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    bool isLogout = false,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.white2, width: isLogout ? 1.5 : 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : (color ?? AppColors.primary),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
            color: isLogout ? Colors.red : AppColors.black,
            fontSize: 16,
          ),
        ),
        trailing: isLogout
            ? const Icon(Icons.logout, color: Colors.red, size: 22)
            : Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
        onTap: onTap,
      ),
    );
  }
}
