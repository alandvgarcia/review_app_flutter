import 'dart:async';
import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:reviewapp/models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'reviews.g.dart';

class Reviews = ReviewsBase with _$Reviews;
abstract class ReviewsBase with Store {
  @observable
  ObservableList<ReviewModel> reviews = ObservableList.of([]);

  @observable
  double averageStars = 0;

  @computed
  int get numberOfReviews => reviews.length;

  int totalStarts = 0;

  @action
  void addReview(ReviewModel newReview) {
    reviews.add(newReview);
    averageStars = _calculateAverageStars(newReview.stars);
    totalStarts += newReview.stars;
    _persistReview(reviews);
  }

  @action
  Future<void> initReviews() async {
    await _getReviews().then((onValue) {
      reviews = ObservableList.of(onValue);
      for (ReviewModel review in reviews) {
        totalStarts += review.stars;
      }
    });
    averageStars = totalStarts / reviews.length;
  }

  double _calculateAverageStars(int newStars){
    return (newStars + totalStarts) / numberOfReviews;
  }

  void _persistReview(List<ReviewModel> updatedReviews) async {
    List<String> reviewsStringList = [];
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    for (ReviewModel review in updatedReviews) {
      Map<String, dynamic> reviewMap = review.toJson();
      String reviewString = jsonEncode(ReviewModel.fromJson(reviewMap));
      reviewsStringList.add(reviewString);
    }
    _preferences.setStringList('userReviews', reviewsStringList);
  }

  Future<List<ReviewModel>> _getReviews() async {
    final SharedPreferences _preferences =
    await SharedPreferences.getInstance();
    final List<String> reviewsStringList =
        _preferences.getStringList('userReviews') ?? [];
    final List<ReviewModel> retrievedReviews = [];
    for (String reviewString in reviewsStringList) {
      Map<String, dynamic> reviewMap = jsonDecode(reviewString);
      ReviewModel review = ReviewModel.fromJson(reviewMap);
      retrievedReviews.add(review);
    }
    return retrievedReviews;
  }
}
