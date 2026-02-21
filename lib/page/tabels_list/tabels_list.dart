import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_delete_cubit/tabels_list_delete_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/components/tabel_card.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class TabelsList extends StatefulWidget {
  const TabelsList({super.key});

  @override
  State<TabelsList> createState() => _TabelsListState();
}

class _TabelsListState extends State<TabelsList> {
  @override
  void initState() {
    super.initState();
    context.read<TabelsListCubit>().getTabelsList();
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
                        return BlocProvider(
                          create: (context) =>
                              TabelsListDeleteCubit(tablesRepo: TablesRepo()),
                          child: TabelCard(
                            key: ValueKey(tabel.id),
                            tabel: tabel,
                            onEdit: () {},
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
