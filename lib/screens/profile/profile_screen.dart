import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4A6CF7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/photopanha.jpg'), // Replace with your image
                ),
                SizedBox(height: 10),
                Text(
                  "Tho Panha",
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "ID: 524687975",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ), 
          ),
          SizedBox(height: 20),
          _buildOption(icon: Icons.lock_outline, text: "Password"),
          _buildOption(icon: Icons.email_outlined, text: "Email Address"),
          _buildOption(icon: Icons.fingerprint, text: "Fingerprint"),
          _buildOption(icon: Icons.support_agent, text: "Support"),
          _buildOption(icon: Icons.logout, text: "Sign Out"),
        ],
      ),
    );
  }

  Widget _buildOption({required IconData icon, required String text}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
