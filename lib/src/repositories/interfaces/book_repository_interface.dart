import 'package:learn_repository/src/models/book_model.dart';

abstract class IBookRepository {
  Future<List<BookModel>> getAll();
  Future<BookModel?> getOne(int id);
  Future<void> insert(BookModel book);
  Future<void> update(BookModel book);
  Future<void> delete(int id);
}
