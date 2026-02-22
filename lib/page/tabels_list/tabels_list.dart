import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_delete_cubit/tabels_list_delete_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/components/tabel_card.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';
import 'package:restaukitchen_app/page/table_form/bloc/table_form_cubit.dart';
import 'package:restaukitchen_app/page/table_form/table_form_repo/table_form_repo.dart';
import 'package:restaukitchen_app/page/table_form/table_from.dart';

class TabelsList extends StatefulWidget {
  const TabelsList({super.key});

  @override
  State<TabelsList> createState() => _TabelsListState();
}

class _TabelsListState extends State<TabelsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabController;
  bool _fabExpanded = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    context.read<TabelsListCubit>().getTabelsList();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _fabExpanded = !_fabExpanded;
      _fabExpanded ? _fabController.forward() : _fabController.reverse();
    });
  }

  Future<void> _onRefresh() async {
    context.read<TabelsListCubit>().getTabelsList();
    await context.read<TabelsListCubit>().stream.firstWhere(
      (state) => state.status != TabelsListStatus.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _fabController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.extended(
                heroTag: 'fab_action_1',
                onPressed: () async {
                  _toggleFab();
                  final bool? result = await Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: BlocProvider<TableFormCubit>(
                        create: (context) =>
                            TableFormCubit(tableFormRepo: TableFormRepo()),
                        child: TableForm(),
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    context.read<TabelsListCubit>().getTabelsList();
                  }
                },
                icon: const Icon(Icons.table_bar),
                label: const Text('Nuovo tavolo'),
              ),
            ),
          ),
          ScaleTransition(
            scale: _fabController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.extended(
                heroTag: 'fab_action_2',
                onPressed: () {
                  _toggleFab();
                  // TODO: second action
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Ordina tavoli'),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: 'fab_main',
            onPressed: _toggleFab,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _fabController,
            ),
          ),
        ],
      ),
      body: BlocConsumer<TabelsListCubit, TabelsListState>(
        listener: (context, state) {
          if (state.status == TabelsListStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == TabelsListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TabelsListStatus.loaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,

              child: state.tabels?.isEmpty ?? true
                  ? ListView(
                      children: [
                        const SizedBox(height: 200),
                        const Center(child: Text('No tavoli')),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      itemCount: state.tabels?.length ?? 0,
                      itemBuilder: (context, index) {
                        final tabel = state.tabels![index];
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => TabelsListDeleteCubit(
                                tablesRepo: TablesRepo(),
                              ),
                            ),
                          ],
                          child: TabelCard(
                            key: ValueKey(tabel.id),
                            tabel: tabel,
                            onEdit: () {
                              context.read<TabelsListCubit>().getTabelsList();
                            },
                            onOrder: () {},
                            onGenerateQr: () {},
                            onDelete: () {
                              context.read<TabelsListCubit>().removeTabel(
                                tabel.id ?? '',
                              );
                            },
                            onStatusChanged: (reserved) {},
                          ),
                        );
                      },
                    ),
            );
          }
          if (state.status == TabelsListStatus.error) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage ?? 'Error'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<TabelsListCubit>().getTabelsList(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Tavoli'));
        },
      ),
    );
  }
}
