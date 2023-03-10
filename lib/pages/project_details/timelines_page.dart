import 'package:echocues/api/models/scene_model.dart';
import 'package:echocues/api/models/timeline_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScenesPageWidget extends StatefulWidget {
  final List<SceneModel> _scenes;

  const ScenesPageWidget({Key? key, required List<SceneModel> scenes})
      : _scenes = scenes,
        super(key: key);

  @override
  State<ScenesPageWidget> createState() => _ScenesPageWidgetState(scenes: _scenes);
}

class _ScenesPageWidgetState extends State<ScenesPageWidget> {
  final List<SceneModel> _scenes;
  late List<ScenePanel> _events;

  _ScenesPageWidgetState({required List<SceneModel> scenes}) : _scenes = scenes;

  @override
  void initState() {
    super.initState();

    _events = [];
    for (SceneModel sceneModel in _scenes) {
      _events.add(ScenePanel(
        sceneName: sceneModel.name!,
        events: sceneModel.events!.map((e) => TimelineEventPanel(timelineEventModel: e)).toList(),
        isExpanded: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (index, expanded) {
          setState(() {
            _events[index].isExpanded = !expanded;
          });
        },
        children: _events.map((scene) {
          return ExpansionPanel(
            headerBuilder: (ctx, expanded) {
              return ListTile(
                title: Text(
                  scene.sceneName,
                  style: GoogleFonts.notoSans(),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ExpansionPanelList(
                expansionCallback: (index, expanded) {
                  setState(() {
                    scene.events[index].isExpanded = !expanded;
                  });
                },
                children: scene.events.map((event) {
                  return ExpansionPanel(
                    headerBuilder: (ctx, expanded) {
                      return ListTile(
                        title: Text(event.timelineEventModel.time!),
                      );
                    },
                    // this should be the notes and the cues
                    body: const Placeholder(),
                    isExpanded: event.isExpanded,
                  );
                }).toList(),
              ),
            ),
            isExpanded: scene.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class ScenePanel {
  String sceneName;
  List<TimelineEventPanel> events;
  bool isExpanded;

  ScenePanel({
    required this.sceneName,
    required this.events,
    required this.isExpanded,
  });
}

class TimelineEventPanel {
  TimelineEventModel timelineEventModel;
  bool isExpanded;
  
  TimelineEventPanel({
    required this.timelineEventModel,
    this.isExpanded = false,
  });
}