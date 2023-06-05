import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 0;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rate this app:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.star),
                  color: rating >= 1 ? Colors.orange : Colors.grey,
                  onPressed: () {
                    setState(() {
                      rating = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  color: rating >= 2 ? Colors.orange : Colors.grey,
                  onPressed: () {
                    setState(() {
                      rating = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  color: rating >= 3 ? Colors.orange : Colors.grey,
                  onPressed: () {
                    setState(() {
                      rating = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  color: rating >= 4 ? Colors.orange : Colors.grey,
                  onPressed: () {
                    setState(() {
                      rating = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  color: rating >= 5 ? Colors.orange : Colors.grey,
                  onPressed: () {
                    setState(() {
                      rating = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tell us your feedback',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform some action with the selected rating and comment
                print('Selected rating: $rating');
                print('Comment: $comment');
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 51, 139, 81), // Set the background color
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
