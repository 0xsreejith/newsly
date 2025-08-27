import 'package:flutter/material.dart';
import 'package:newsly/models/article_model.dart';
import 'package:newsly/screens/search_screen.dart';
import 'package:newsly/services/news_service.dart';
import 'package:newsly/theme/app_theme.dart';
import 'package:newsly/widgets/news_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NewsService _newsService;
  late Future<List<Article>> _topHeadlines;

  @override
  void initState() {
    super.initState();
    _newsService = NewsService();
    _tabController = TabController(
      length: NewsService.categories.length,
      vsync: this,
    );
    _loadNews();
  }

  void _loadNews() {
    _topHeadlines = _newsService.getTopHeadlines(
      category: NewsService.categories[0],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Newsly', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text('Categories', 
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: NewsService.categories.length,
              itemBuilder: (context, index) {
                final category = NewsService.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      '${category[0].toUpperCase()}${category.substring(1)}',
                      style: TextStyle(
                        color: _tabController.index == index 
                            ? Colors.white 
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    selected: _tabController.index == index,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onSelected: (selected) {
                      setState(() {
                        _tabController.animateTo(index);
                        _topHeadlines = _newsService.getTopHeadlines(
                          category: category,
                        );
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: AppTheme.responsivePadding(context),
              child: FutureBuilder<List<Article>>(
                future: _topHeadlines,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load news',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _topHeadlines = _newsService.getTopHeadlines(
                                  category: NewsService.categories[_tabController.index],
                                );
                              });
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No articles found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _topHeadlines = _newsService.getTopHeadlines(
                          category: NewsService.categories[_tabController.index],
                        );
                      });
                    },
                    child: NewsList(articles: snapshot.data!),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
