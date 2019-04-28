import 'package:flutter/material.dart';
import 'package:votacao_app/model/project.dart';
import 'package:votacao_app/widgets/project_card.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;

  const ProjectList(this.projects);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      shrinkWrap: true,
      // TODO read https://medium.com/flutter-community/flutter-listview-and-scrollphysics-a-detailed-look-7f0912df2754
      physics: const BouncingScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, int) {
        return ProjectCard(projects[int]);
      },
    );
  }
}
