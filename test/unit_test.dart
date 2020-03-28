import 'package:flutter_test/flutter_test.dart';
import 'package:reviewapp/models/review_model.dart';
import 'package:reviewapp/models/reviews.dart';


void main() {
  test('Test MobX state class', () async {
    final Reviews _reviewsStore = Reviews();

    _reviewsStore.initReviews();

    expect(_reviewsStore.totalStarts, 0);

    expect(_reviewsStore.averageStars, 0);
    _reviewsStore.addReview(ReviewModel(
      comment: "This is a test review",
      stars: 3,
    ));

    expect(_reviewsStore.totalStarts, 3);
    _reviewsStore.addReview(ReviewModel(
      comment: "This is a test review",
      stars: 5,
    ));

    expect(_reviewsStore.averageStars, 4);

  });
}
