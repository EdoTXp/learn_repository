import 'package:learn_repository/src/models/book_model.dart';
import 'package:learn_repository/src/repositories/book_repository_impl.dart';

class HomePageController {
  final BookRepositoryImpl _bookRepository;

  HomePageController(this._bookRepository);

  Future<List<BookModel>> getAllBooks() {
    return _bookRepository.getAll();
  }

  Future<void> addBook(BookModel book) {
    return _bookRepository.insert(book);
  }

  Future<void> removeBook(int id) {
    return _bookRepository.delete(id);
  }
}
