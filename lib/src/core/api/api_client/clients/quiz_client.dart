import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/api_client/repositories/quiz_repository.dart';
import 'package:malzama/src/core/api/api_routes/quizes_routes.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';

class QuizClient implements QuizRepository {
  @override
  Future<ContractResponse> deleteQuizItem({String quizItemId, String quizCollectionId, int questionsCount}) async {
    final String queryString = '?quizItemId=$quizItemId&quizCollectionId=$quizCollectionId&questionsCount=$questionsCount';
    return await HttpMethods.get(url: QuizRoutes.DELETE_QUIZ_ITEM, queryString: queryString);
  }

  @override
  Future<ContractResponse> editQuizItem({String quizItemID, String quizCollectionID, QuizEntity quizItem}) async {

    Map<String, dynamic> body = {
      'quizItemId': quizItemID,
      'quizCollectionId': quizCollectionID,
      'quizItem': quizItem.toJSON(),
    };
    return await HttpMethods.post(body: body, url: QuizRoutes.EDIT_QUIZ_ITEM);
  }

  @override
  Future<ContractResponse> fetchQuizByID({String id}) async {
    final String queryString = '?id=$id';
    return await HttpMethods.get(url: QuizRoutes.FETCH_QUIZ_BY_ID, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizHeaders({String idFactor}) async {
    final String queryString = '?idFactor=$idFactor';
    return await HttpMethods.get(url: QuizRoutes.FETCH_QUIZES_HEADERS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizQuestions({quizID, int skipCount}) async {
    final String queryString = '?quizID=$quizID&skipCount=$skipCount';
    return await HttpMethods.get(url: QuizRoutes.FETCH_QUIZES_QUESTIONS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizesCount() async => await HttpMethods.get(url: QuizRoutes.FETCH_QUIZES_COUNT);

  @override
  Future<ContractResponse> fetchSavedQuizesHeaders({@required String collection, @required List<String> ids}) async {
    final String idList = ids.join(',');
    final String query = '?collection=$collection&ids=$idList';
    return await HttpMethods.get(url: QuizRoutes.FETCH_SAVED_QUIZES_HEADERS, queryString: query);
  }

  @override
  Future<ContractResponse> fetchQuizHeadersOnRefresh({@required String collection, @required String idFactor}) async {
    final String query = '?collection=$collection&idFactor=$idFactor';
    return await HttpMethods.get(url: QuizRoutes.FETCH_QUIZES_HEADERS_ON_REFRESH, queryString: query);
  }

  @override
  Future<ContractResponse> fetchAllQuizQuestions({@required quizID}) async {
    final String query = '?quizId=$quizID';
    return await HttpMethods.get(url: QuizRoutes.FETCH_ALL_QUESTIONS, queryString: query);
  }

  @override
  Future<ContractResponse> editEntireQuiz({@required Map<String, dynamic> payload}) async {
    return await HttpMethods.post(body: payload, url: QuizRoutes.EDIT_ENTIRE_QUIZ);
  }
}
