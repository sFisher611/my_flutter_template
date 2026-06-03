import 'package:flutter/material.dart';
import 'package:my_flutter_template/core/widgets/shimmer_widget.dart';
import 'package:my_flutter_template/l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Serverdan ma'lumot kelishini simulyatsiya qilamiz (2 sekund)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: _isLoading ? _buildLoadingSkeleton() : RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _isLoading = false);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Promo Banner (Carousel o'rniga universal chiroyli karta)
              _buildPromoBanner(theme),
              const SizedBox(height: 24),

              // 2. Kategoriyalar sarlavhasi
              _buildSectionHeader(theme, "Kategoriyalar", () {}),
              const SizedBox(height: 12),

              // 3. Gorizontal Kategoriyalar Ro'yxati
              _buildCategoryList(theme),
              const SizedBox(height: 24),

              // 4. Asosiy Grid Sarlavhasi
              _buildSectionHeader(theme, "Yangi e'lonlar", () {}),
              const SizedBox(height: 12),

              // 5. Grid Ma'lumotlar qismi
              _buildMainGrid(theme),
            ],
          ),
        ),
      ),
    );
  }

  // Banner vidjeti
  Widget _buildPromoBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Xush kelibsiz! ✨",
            style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Bu sizning universal shabloningiz. Istalgan loyihaga moslab kengaytirishingiz mumkin.",
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  // Sarlavhalar generatori
  Widget _buildSectionHeader(ThemeData theme, String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: Text("Barchasi", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // Kategoriyalar
  Widget _buildCategoryList(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                "Kategoriya ${index + 1}",
                style: TextStyle(
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Asosiy Grid Kontenti
  Widget _buildMainGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.image, color: theme.colorScheme.primary.withOpacity(0.4), size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Element nomi ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("150,000 UZS", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Yuklanish maydoni (Skeleton Loader)
  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerWidget(width: double.infinity, height: 140, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerWidget(width: 120, height: 20),
              ShimmerWidget(width: 60, height: 20),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 10),
                child: ShimmerWidget(width: 100, height: 40, borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerWidget(width: 140, height: 20),
              ShimmerWidget(width: 60, height: 20),
            ],
          ),
          const SizedBox(height: 12),
          GridPictureSkeleton(),
        ],
      ),
    );
  }
}

// Grid uchun alohida shimmer ko'rinishi
class GridPictureSkeleton extends StatelessWidget {
  const GridPictureSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const ShimmerWidget(width: double.infinity, height: double.infinity, borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}