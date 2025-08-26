import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/search_history_service.dart';

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
  bool _showSuggestions = false;
  List<String> _searchHistory = [];
  
  // Popular search suggestions
  final List<String> _popularSearches = [
    'Mumbai',
    'Delhi', 
    'Goa',
    'Jaipur',
    'Kerala',
    'Agra',
    'WiFi',
    'Pool',
    'Parking',
    'AC',
    'Couple friendly',
    'Pet friendly',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    // Responsive sizing
    final borderRadius = isMobile ? 12.0 : 16.0;
    final horizontalPadding = isMobile ? 16.0 : 20.0;
    final verticalPadding = isMobile ? 16.0 : 18.0;
    final fontSize = isMobile ? 16.0 : 18.0;
    final iconSize = isMobile ? 20.0 : 24.0;
    
    return Column(
      children: [
        Container(
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
            onChanged: (value) {
              widget.onSearch(value);
              setState(() {
                _showSuggestions = value.isEmpty && _focusNode.hasFocus;
              });
            },
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: 'Search by location, hotel name, amenities...',
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
                          setState(() {
                            _showSuggestions = false;
                          });
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
            onSubmitted: (value) async {
              if (value.trim().isNotEmpty) {
                await SearchHistoryService.addSearchTerm(value.trim());
                await _loadSearchHistory();
              }
              widget.onSearch(value);
              _focusNode.unfocus();
              setState(() {
                _showSuggestions = false;
              });
            },
          ),
        ),
        if (_showSuggestions) _buildSuggestions(isMobile, fontSize),
      ],
    );
  }

  Widget _buildSuggestions(bool isMobile, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12.0 : 16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: isMobile ? 8 : 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History Section
          if (_searchHistory.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 12.0 : 16.0,
                isMobile ? 12.0 : 16.0,
                isMobile ? 12.0 : 16.0,
                isMobile ? 8.0 : 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent searches',
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await SearchHistoryService.clearSearchHistory();
                      await _loadSearchHistory();
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: fontSize - 3,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ..._searchHistory.take(5).map((search) => 
              ListTile(
                dense: true,
                leading: Icon(
                  Icons.history,
                  size: isMobile ? 18 : 20,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  search,
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    await SearchHistoryService.removeSearchTerm(search);
                    await _loadSearchHistory();
                  },
                  child: Icon(
                    Icons.close,
                    size: isMobile ? 16 : 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () async {
                  _controller.text = search;
                  await SearchHistoryService.addSearchTerm(search);
                  widget.onSearch(search);
                  setState(() {
                    _showSuggestions = false;
                  });
                  _focusNode.unfocus();
                },
              ),
            ).toList(),
            const Divider(height: 1),
          ],
          
          // Popular Searches Section
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 12.0 : 16.0,
              isMobile ? 12.0 : 16.0,
              isMobile ? 12.0 : 16.0,
              isMobile ? 8.0 : 12.0,
            ),
            child: Text(
              'Popular searches',
              style: TextStyle(
                fontSize: fontSize - 2,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Wrap(
            children: _popularSearches.map((search) {
              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 4, bottom: 8),
                child: GestureDetector(
                  onTap: () async {
                    _controller.text = search;
                    await SearchHistoryService.addSearchTerm(search);
                    widget.onSearch(search);
                    setState(() {
                      _showSuggestions = false;
                    });
                    _focusNode.unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      search,
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  
  Future<void> _loadSearchHistory() async {
    final history = await SearchHistoryService.getSearchHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _controller.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _controller.text.isEmpty && _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}