import 'package:flutter/material.dart';
import '../../local/db.dart';
import '../request/request_detail_card.dart';

class CollectionPagerPage extends StatefulWidget {
  final List<String> ids;
  final int initialIndex;
  const CollectionPagerPage({
    super.key,
    required this.ids,
    this.initialIndex = 0,
  });

  @override
  State<CollectionPagerPage> createState() => _CollectionPagerPageState();
}

class _CollectionPagerPageState extends State<CollectionPagerPage>
    with AutomaticKeepAliveClientMixin {
  late final PageController _controller;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        itemCount: widget.ids.length,
        itemBuilder: (_, i) => RequestDetailCard(requestId: widget.ids[i]),
      ),
    );
  }
}
