import 'package:flutter/material.dart';

import '../../../responsive_scaffold.dart';
import '../responsive_list.dart';

class MobileView extends StatelessWidget {
  MobileView({
    Key? key,
    required this.slivers,
    required this.detailBuilder,
    required List<Widget> children,
    required this.detailScaffoldKey,
    required this.useRootNavigator,
    required this.navigator,
    required this.nullItems,
    required this.emptyItems,
  })  : childDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          addSemanticIndexes: false,
        ),
        super(key: key);

  MobileView.builder({
    Key? key,
    required this.slivers,
    required this.detailBuilder,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required this.detailScaffoldKey,
    required this.useRootNavigator,
    required this.navigator,
    required this.nullItems,
    required this.emptyItems,
  })  : childDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          addSemanticIndexes: false,
        ),
        super(key: key);

  MobileView.custom({
    Key? key,
    required this.slivers,
    required this.detailBuilder,
    required this.childDelegate,
    required this.detailScaffoldKey,
    required this.useRootNavigator,
    required this.navigator,
    required this.nullItems,
    required this.emptyItems,
  }) : super(key: key);

  final List<Widget>? slivers;
  final DetailWidgetBuilder detailBuilder;
  final Key? detailScaffoldKey;
  final bool useRootNavigator;
  final NavigatorState? navigator;
  final Widget? nullItems, emptyItems;
  final SliverChildDelegate childDelegate;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[]
        ..addAll(slivers ?? [])
        ..add(Builder(
          builder: (BuildContext context) {
            if (childDelegate.estimatedChildCount == null && nullItems != null)
              return SliverFillRemaining(child: nullItems);
            if (childDelegate.estimatedChildCount != null &&
                childDelegate.estimatedChildCount == 0 &&
                emptyItems != null)
              return SliverFillRemaining(child: emptyItems);
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new KeepAlive(
                  keepAlive: true,
                  child: new IndexedSemantics(
                    index: index,
                    child: GestureDetector(
                      onTap: () {
                        (navigator ?? Navigator.of(context))
                            .push(MaterialPageRoute(builder: (context) {
                          final _details = detailBuilder(context, index, false);
                          return new DetailView(
                              detailScaffoldKey: detailScaffoldKey,
                              itemCount: childDelegate.estimatedChildCount,
                              details: _details);
                        }));
                      },
                      child: new Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: childDelegate.build(context, index),
                      ),
                    ),
                  ),
                );
              },
              childCount: childDelegate.estimatedChildCount ?? 0,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              addSemanticIndexes: false,
            ));
          },
        )),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.itemCount,
    required DetailsScreen details,
    required this.detailScaffoldKey,
  })  : _details = details,
        super(key: key);

  final int? itemCount;
  final DetailsScreen _details;
  final Key? detailScaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: detailScaffoldKey,
      appBar: _details.appBar,
      body: _details.body,
    );
  }
}
