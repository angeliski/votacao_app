import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:votacao_app/model/project.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  ProjectDetailScreen(this.project);

  _ProjectDetailState createState() => _ProjectDetailState(project);
}

class _ProjectDetailState extends State<ProjectDetailScreen> {
  final Project project;
  String renderUrl;

  _ProjectDetailState(this.project);

  void initState() {
    super.initState();
    renderDogPic();
  }

// IRL, we'd want the Dog class itself to get the image
// but this is a simpler way to explain Flutter basics
  void renderDogPic() async {
    // this makes the service call
    await project.getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a variable that can be overwritten
    setState(() {
      renderUrl = project.imageUrl;
    });
  }

  Widget get placeholder {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white54, Colors.grey[600]],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'Bluesoft',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget get projectImage {
    return Hero(
      tag: project,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
                // just like CSS:
                // it takes the same 4 properties
                offset: const Offset(1.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: -1.0,
                color: Colors.white10),
          ],
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(widget.project.imageUrl),
          ),
        ),
      ),
    );
  }

  // The rating section that says ★ 10/10.
  Widget get rating {
    return Column(
      children: <Widget>[
        Row(
          // Center the widgets on the main-axis
          // which is the horizontal axis in a row.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              size: 40.0,
            ),
            Text(' ${widget.project.rating.toStringAsFixed(2)} / 10',
                style: Theme.of(context).textTheme.display2)
          ],
        ),
        SmoothStarRating(
          allowHalfRating: false,
          onRatingChanged: (v) {
            project.rating = v;
            setState(() {});
          },
          starCount: 10,
          rating: project.rating,
          size: 70.0,
          color: Colors.blueAccent,
          borderColor: Colors.green,
        )
      ],
    );
  }

  // The widget that displays the image, rating and dog info.
  Widget get projectProfile {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        // This would be a great opportunity to create a custom LinearGradient widget
        // that could be shared throughout the app but I'll leave that to you.
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.6, 0.8, 0.9],
          colors: [
            Colors.white,
            Colors.white10,
            Colors.white54,
            Colors.white70,
            Colors.grey,
          ],
        ),
      ),
      // The Dog Profile information.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          projectImage,
          Text(
            '${widget.project.name}  🎾',
            style: TextStyle(fontSize: 32.0),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Text(widget.project.description),
          ),
          rating
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is a new page, so you need a new Scaffold!
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text('Avaliação ${widget.project.name}'),
      ),
      body: projectProfile,
    );
  }
}
