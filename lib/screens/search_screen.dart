import 'package:flutter/material.dart';
import 'package:newsly/models/article_model.dart';
import 'package:newsly/services/news_service.dart';
import 'package:newsly/theme/app_theme.dart';
import 'package:newsly/widgets/news_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsService _newsService = NewsService();
  late Future<List<Article>> _searchResults;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = Future.value([]);
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _newsService.searchNews(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for news...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _isSearching = false;
                        _searchResults = Future.value([]);
                      });
                    },
                  )
                : null,
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _isSearching = false;
                _searchResults = Future.value([]);
              });
            }
          },
          onSubmitted: _search,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: AppTheme.responsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearching) const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (!_isSearching) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for news articles',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Type in the search bar above to find news',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

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
                            'Failed to load search results',
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
                            onPressed: () => _search(_searchController.text),
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
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => Future.sync(() => _search(_searchController.text)),
                    child: NewsList(articles: snapshot.data!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
