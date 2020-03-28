import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:reviewapp/models/review_model.dart';
import 'package:reviewapp/models/reviews.dart';
import 'package:reviewapp/widgets/info_card.dart';
import 'package:reviewapp/widgets/review_widget.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final Reviews _reviewsStore = Reviews();
  final List<int> _stars = [1, 2, 3, 4, 5];
  final TextEditingController _commentController = TextEditingController();
  int _selectedStart;

  @override
  void initState() {
    _selectedStart = null;
    _reviewsStore.initReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Review App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.6,
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Write a review",
                        labelText: "Write a review"),
                  ),
                ),
                Container(
                  child: DropdownButton(
                    hint: Text("Stars"),
                    elevation: 0,
                    value: _selectedStart,
                    items: _stars.map((star) {
                      return DropdownMenuItem<int>(
                        child: Text(star.toString()),
                        value: star,
                      );
                    }).toList(),
                    onChanged: (item) {
                      setState(() {
                        _selectedStart = item;
                      });
                    },
                  ),
                ),
                Container(
                  child: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          if (_selectedStart == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                              Text("You can't add a review without star"),
                              duration: Duration(milliseconds: 500),
                            ));
                          } else if (_commentController.text.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                              Text("Review comment cannot be empty"),
                              duration: Duration(milliseconds: 500),
                            ));
                          } else {
                            _reviewsStore.addReview(ReviewModel(
                              comment: _commentController.text,
                              stars: _selectedStart
                            ));
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Observer(
              builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InfoCard(
                      infoLabel: 'reviews',
                      infoValue: _reviewsStore.numberOfReviews.toString(),
                      cardColor: Colors.green,
                      iconData: Icons.comment,
                    ),
                    InfoCard(
                      infoLabel: 'average stars',
                      infoValue: _reviewsStore.averageStars.toStringAsFixed(2),
                      cardColor: Colors.lightBlue,
                      iconData: Icons.star,
                      key: Key('avgStar'),
                    ),
                  ],
                );
              }
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.comment),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Reviews",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Observer(
                  builder: (_) => _reviewsStore.reviews.isNotEmpty ?
                  ListView(
                    children: _reviewsStore.reviews.reversed.map((reviewItem){
                      return ReviewWidget(
                        reviewItem: reviewItem,
                      );
                    }).toList(),
                   ) : Text('No reviews yes'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
