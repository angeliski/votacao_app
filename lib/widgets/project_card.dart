import 'package:flutter/material.dart';
import 'package:votacao_app/model/project.dart';
import 'package:votacao_app/routes/project_detail_screen.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  ProjectCard(this.project);

  @override
  _ProjectCardState createState() => _ProjectCardState(project);
}

class _ProjectCardState extends State<ProjectCard> {
  Project project;
  String renderUrl;

  _ProjectCardState(this.project);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                child: mainCard,
              ),
              Positioned(top: 7.5, child: projectImage),
            ],
          ),
        ),
      ),
    );
  }

  showDetail() {
    //TODO read https://medium.com/@diegoveloper/flutter-shared-element-transitions-hero-heroes-f1a083cb123a
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: ProjectDetailScreen(project),
                  );
                });
          },
          transitionDuration: Duration(milliseconds: 700)),
    );
  }

  void initState() {
    super.initState();
    renderProjectPic();
  }

  void renderProjectPic() async {
    await project.getImageUrl();
    setState(() {
      renderUrl = project.imageUrl;
    });
  }

  Widget get projectImage {
    return Hero(
        tag: project,
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: renderUrl != null ? BoxFit.cover : BoxFit.contain,
              image: NetworkImage(renderUrl ??
                  'https://bluesoft.com.br/wp-content/uploads/2018/03/logo-1.png'),
            ),
          ),
        ));
  }

  Widget get mainCard {
    return Container(
        width: 290,
        height: 115,
        child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 64),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(widget.project.name,
                        style: Theme.of(context).textTheme.headline),
                    Text(widget.project.description,
                        style: Theme.of(context).textTheme.caption),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                        ),
                        Text(': ${widget.project.rating} / 10')
                      ],
                    ),
                  ]),
            )));
  }
}
