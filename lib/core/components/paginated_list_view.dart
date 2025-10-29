import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatefulWidget {
  final List<T> data;
  final bool hasMore;
  final Future<void> Function() fetchMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const PaginatedListView({
    super.key,
    required this.data,
    required this.hasMore,
    required this.fetchMore,
    required this.itemBuilder,
    this.emptyWidget,
    this.padding,
    this.spacing = 12,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  bool _isLoadingMore = false;

  Future<void> _handleLoadMore() async {
    if (_isLoadingMore || !widget.hasMore) return;
    setState(() => _isLoadingMore = true);
    await widget.fetchMore();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return widget.emptyWidget ?? const SizedBox();
    }

    return ListView.separated(
      padding: widget.padding ?? EdgeInsets.zero,
      itemCount: widget.data.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: widget.spacing),
      itemBuilder: (context, index) {
        if (index == widget.data.length) {
          // Show "Load more" button
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Center(
              child: _isLoadingMore 
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: _handleLoadMore,
                      child: const Text('Show more'),
                    ),
            ),
          );
        }
        final item = widget.data[index];
        return widget.itemBuilder(context, item);
      },
    );
  }
}
