import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    // Responsive sizing
    final borderRadius = isMobile ? 12.0 : 16.0;
    final horizontalPadding = isMobile ? 16.0 : 20.0;
    final verticalPadding = isMobile ? 16.0 : 18.0;
    final fontSize = isMobile ? 16.0 : 18.0;
    final iconSize = isMobile ? 20.0 : 24.0;
    
    return Container(
      constraints: BoxConstraints(
        minHeight: isMobile ? 48 : 56,
        maxHeight: isMobile ? 56 : 64,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: isMobile ? 8 : 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: isMobile ? 4 : 6,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onSearch,
        style: TextStyle(
          fontSize: fontSize,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: 'Search hotels by name...',
          hintStyle: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: horizontalPadding - 4,
              right: isMobile ? 8 : 12,
            ),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: iconSize,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: isMobile ? 48 : 56,
            minHeight: isMobile ? 48 : 56,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    right: horizontalPadding - 4,
                    left: isMobile ? 8 : 12,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: iconSize,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearch('');
                      setState(() {});
                    },
                    constraints: BoxConstraints(
                      minWidth: isMobile ? 40 : 48,
                      minHeight: isMobile ? 40 : 48,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          isDense: false,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          widget.onSearch(value);
          _focusNode.unfocus();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}