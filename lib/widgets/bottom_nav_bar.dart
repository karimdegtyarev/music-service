import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Map<int, IconData> _icons = {
    0: Icons.home_outlined,
    1: Icons.explore_outlined,
    2: Icons.favorite_border,
    3: Icons.manage_search,
  };

  // Список иконок для активного состояния
  final Map<int, IconData> _activeIcons = {
    0: Icons.home,
    1: Icons.explore,
    2: Icons.favorite,
    3: Icons.search,
  };

  final List<String> _iconNames = ["Home", "Explore", "Favorites", "Search"];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = widget.currentIndex == index; // Используйте widget.currentIndex
    return InkWell(
      onTap: () => widget.onTap(index), // Вызовите функцию onTap
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? _activeIcons[index] : _icons[index],
            color: isSelected ? Colors.lightGreenAccent : Colors.white,
          ),
          Text(
            _iconNames[index],
            style: GoogleFonts.permanentMarker(
              color: isSelected ? Colors.lightGreenAccent : Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}


// class BottomNavBar extends StatefulWidget{
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const BottomNavBar({super.key, required this.currentIndex, required this.onTap});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//
//   final Map<int, IconData> _icons = {
//     0: Icons.home_outlined,
//     1: Icons.explore_outlined,
//     2: Icons.favorite_border,
//     3: Icons.manage_search,
//   };
//
//   // Список иконок для активного состояния
//   final Map<int, IconData> _activeIcons = {
//     0: Icons.home,
//     1: Icons.explore,
//     2: Icons.favorite,
//     3: Icons.search,
//   };
//
//   final List<String> _iconNames = ["Home", "Explore", "Favorites", "Search"];
//
//   void _onItemTapped(int index) {
//     _selectedIndex = index;
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return BottomAppBar(
//       color: Colors.black,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(_icons.length, (index) {
//           return _buildNavItem(index);
//         }),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index) {
//     final isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () => _onItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isSelected ? _activeIcons[index] : _icons[index],
//             color: isSelected ? Colors.lightGreenAccent : Colors.white,
//           ),
//           Text(
//             _iconNames[index],
//             style: GoogleFonts.permanentMarker(
//               color: isSelected ? Colors.lightGreenAccent : Colors.white,
//               fontSize: 12,
//             ),
//           ),
//           //const HomePage(),
//         ],
//       ),
//     );
//   }
// }
