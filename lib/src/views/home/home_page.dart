import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_repository/src/databases/virtual_database.dart';
import 'package:learn_repository/src/models/book_model.dart';
import 'package:learn_repository/src/repositories/book_repository_impl.dart';

import '../../controllers/home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController =
      HomePageController(BookRepositoryImpl(VirtualDatabase()));

  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repo Book Store'),
      ),
      body: ListView(children: [
        _Form(
          homeController: _homeController,
          refreshList: _refreshList,
        ),
        _BookTable(
          homeController: _homeController,
          refreshList: _refreshList,
        ),
      ]),
    );
  }
}

class _Form extends StatefulWidget {
  final HomePageController homeController;
  final VoidCallback refreshList;

  const _Form({required this.homeController, required this.refreshList})
      : super();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _yearFieldController = TextEditingController();

  @override
  void dispose() {
    _titleFieldController.dispose();
    _yearFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleFieldController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _yearFieldController,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter released year';
                }
                return null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.homeController.addBook(BookModel(
                          id: 0,
                          title: _titleFieldController.text,
                          year: int.parse(_yearFieldController.text)));
                      _titleFieldController.clear();
                      _yearFieldController.clear();
                      widget.refreshList();
                    }
                  },
                  child: const Text('Add book'),
                )),
          ],
        ),
      ),
    );
  }
}

class _BookTable extends StatelessWidget {
  final HomePageController homeController;
  final VoidCallback refreshList;

  const _BookTable({required this.homeController, required this.refreshList})
      : super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookModel>>(
        future: homeController.getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            return DataTable(
                columns: _createBookTableColumns(),
                rows: _createBookTableRows(snapshot.data ?? []));
          }
        });
  }

  List<DataColumn> _createBookTableColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Book')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createBookTableRows(List<BookModel> books) {
    return books
        .map((book) => DataRow(cells: [
              DataCell(Text('#' + book.id.toString())),
              DataCell(Text('${book.title} (${book.year.toString()})')),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await homeController.removeBook(book.id);
                  refreshList();
                },
              )),
            ]))
        .toList();
  }
}
