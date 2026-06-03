import 'package:flutter/material.dart';
import 'package:my_flutter_template/l10n/app_localizations.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _searchResults = [];

  // Shablon uchun mock (taqlidiy) ma'lumotlar ro'yxati
  final List<String> _dummyDatabase = [
    "Flutter mobil dasturlash",
    "GoRouter darslari",
    "Bloc state management",
    "Hive NoSQL ma'lumotlar bazasi",
    "UI/UX dizayn asoslari",
    "Node.js backend darsligi",
    "Dart dasturlash tili",
  ];

  // Oxirgi qidiruvlar tarixi (History)
  final List<String> _searchHistory = [
    "Flutter",
    "Bloc",
    "Hive bazasi",
  ];

  // Ommabop qidiruvlar (Popular tags)
  final List<String> _popularTags = [
    "Dart", "GoRouter", "Clean Architecture", "Firebase", "REST API"
  ];

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    // Bazadan qidirish algoritmi (Kichik harflarga o'g'irib solishtiradi)
    final results = _dummyDatabase.where((item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // 1. Qidiruv input maydoni (TextField)
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Qidiruv...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged("");
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // 2. Dinamik kontent almashinuvi
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(theme)
                  : _buildDefaultSuggestions(theme),
            ),
          ],
        ),
      ),
    );
  }

  // Qidiruv natijalari ro'yxati yoki Empty State
  Widget _buildSearchResults(ThemeData theme) {
    if (_searchResults.isEmpty) {
      // Chiroyli Empty State (Hech narsa topilmaganda)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              "Hech narsa topilmadi",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Iltimos, kalit so'zni to'g'ri yozganingizni tekshiring.",
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    // Natijalar chiqqan holat
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.description_rounded),
          title: Text(_searchResults[index]),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () {
            // Natija bosilganda bajariladigan amal
          },
        );
      },
    );
  }

  // Qidiruv boshlanmasidan oldingi tavsiyalar (Tarix va Taglar)
  Widget _buildDefaultSuggestions(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ommabop qidiruvlar (Chips)
          Text(
            "Ommabop so'rovlar",
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularTags.map((tag) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = tag;
                  _onSearchChanged(tag);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Oxirgi qidiruvlar tarixi (History)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Oxirgi qidiruvlar",
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _searchHistory.clear());
                },
                child: const Text("Tozalash", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          _searchHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Qidiruv tarixi bo'sh",
                    style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded, size: 20),
                      title: Text(_searchHistory[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          setState(() => _searchHistory.removeAt(index));
                        },
                      ),
                      onTap: () {
                        _searchController.text = _searchHistory[index];
                        _onSearchChanged(_searchHistory[index]);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}