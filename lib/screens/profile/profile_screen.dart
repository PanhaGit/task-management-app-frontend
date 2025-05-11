import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Tho Panha";
  String userId = "ID: 524687975";
  String location = "Phnom Penh, Cambodia";
  List<String> skills = ["Web", "Mobile", "UI/UX"];
  int followers = 1300;
  int views = 453000;
  int reviews = 453000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4A6CF7),
                    Color(0xFF3A5BEE),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                        onPressed: () => _showEditProfileDialog(context),
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
                  // Profile Picture
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/photopanha.jpg'),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, size: 20, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Name and ID
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userId,
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  // Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        location,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Skills Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      labelStyle: TextStyle(color: Colors.white),
                    )).toList(),
                  ),
                ],
              ),
            ),
            // Stats Section
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Followers", followers),
                  _buildStatItem("Views", views),
                  _buildStatItem("Reviews", reviews),
                ],
              ),
            ),
            // Options List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildOption(
                    icon: Icons.lock_outline,
                    text: "Password",
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildOption(
                    icon: Icons.email_outlined,
                    text: "Email Address",
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildOption(
                    icon: Icons.fingerprint,
                    text: "Fingerprint",
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildOption(
                    icon: Icons.support_agent,
                    text: "Support",
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildOption(
                    icon: Icons.logout,
                    text: "Sign Out",
                    color: Colors.red,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    String formattedValue = value >= 1000 
      ? "${(value / 1000).toStringAsFixed(1)}k" 
      : value.toString();
      
    return Column(
      children: [
        Text(
          formattedValue,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A6CF7),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    Color color = Colors.blueAccent,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController locationController = TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = nameController.text;
                location = locationController.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign Out"),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your logout logic here
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("This feature is coming soon!")),
    );
  }
}