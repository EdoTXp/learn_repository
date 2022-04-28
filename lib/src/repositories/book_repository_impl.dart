import 'package:learn_repository/src/databases/virtual_database.dart';
import 'package:learn_repository/src/models/book_model.dart';
import 'package:learn_repository/src/repositories/interfaces/book_repository_interface.dart';

class BookRepositoryImpl implements IBookRepository {
  final VirtualDatabase _database;

  BookRepositoryImpl(this._database);

  @override
  Future<List<BookModel>> getAll() async {
    var items = await _database.list();
    return items.map((item) => BookModel.fromMap(item)).toList();
  }

  @override
  Future<BookModel?> getOne(int id) async {
    var item = await _database.findOne(id);
    if (item != null) {
      return BookModel.fromMap(item);
    } else {
      return null;
    }
  }

  @override
  Future<void> insert(BookModel book) async {
    await _database.insert(book.toMap());
  }

  @override
  Future<void> update(BookModel book) async {
    await _database.update(book.toMap());
  }

  @override
  Future<void> delete(int id) async {
    await _database.remove(id);
  }
}
