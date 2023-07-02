/// {@category Vista}
/// {@category Miscelaneo}
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:habitr_tfg/data/classes/user.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late User myself;
  late Widget _child;
  int selectedFlower = 0;
  late UnityWidgetController _controller;
  @override
  void initState() {
    super.initState();
    var selfState = BlocProvider.of<SelfBloc>(context).state;
    if (!(selfState is SelfLoaded) && !(selfState is SelfReloading))
      BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
    if ((selfState is SelfLoaded) &&
        (selfState.lastLoadTime).difference(DateTime.now()).inMinutes >= 5) {
      // Schedule reload if the data is stale
      BlocProvider.of<SelfBloc>(context).add(ReloadSelfEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfBloc, SelfState>(builder: (context, state) {
      if ((state is SelfLoaded) || (state is SelfReloading)) {
        var flowers = state.self!.flowers;
        _child = UnityWidget(
          onUnityCreated: (UnityWidgetController controller) {
            _controller = controller;
            var tst = flowers.toString().replaceAll(RegExp('\\[|\\]'), '');
            _controller.postMessage("Scripter", "UnlockFlowers", "16");
            _controller.postMessage("Scripter", "ChangeFlowers", tst);
          },
          onUnityUnloaded: () => print('onUnload'),
          onUnityMessage: (handler) async {
            List<String> data = handler.split(',');
            print(data);
            switch (data[0]) {
              case 'ChangeFlower':
                await showDialog(
                    context: context, builder: flowerDialogBuilder);
                flowers[int.parse(data[1])] = selectedFlower;
                _controller.postMessage("Scripter", "ChangeFlowers",
                    flowers.toString().replaceAll(RegExp('\\[|\\]'), ''));
                setState(() {});
                BlocProvider.of<SelfBloc>(context)
                    .add(ChangeFlowersEvent(newFlowers: flowers));
            }
          },
        );
      } else {
        _child = LoadingSpinner();
      }
      return Container(alignment: Alignment.center, child: _child);
    });
  }

  Widget flowerDialogBuilder(BuildContext context) {
    var selection = 4;
    var self = BlocProvider.of<SelfBloc>(context).state.self!;
    var unlockedFlowers = self.xp ~/ 250;
    // Create flower buttons
    ColorFilter grayscale = ColorFilter.mode(Colors.grey, BlendMode.saturation);
    ColorFilter none = ColorFilter.mode(Colors.transparent, BlendMode.lighten);
    ColorFilter selected = ColorFilter.mode(Colors.black, BlendMode.saturation);
    List<String> flowers = [
      'Red Flowers',
      'Blue Flowers',
      'Orange Flowers',
      'Hibiscus',
      'Rose',
      'Sunflower',
      'Dandelion'
    ];
    List<Widget> buttons = List.empty(growable: true);
    for (int i = 0; i < flowers.length; i++) {
      var filter = unlockedFlowers >= i ? none : grayscale;
      var tapFunction = () {
        if (unlockedFlowers >= i) {
          selection = i;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 10.0,
            content:
                Text('You need to be level ${i + 1} to unlock ${flowers[i]}'),
          ));
        }
      };

      var button = ColorFiltered(
          colorFilter: filter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(children: [
                  Image.asset(
                    'assets/icons/${flowers[i].replaceAll(RegExp(" "), "")}.png',
                    fit: BoxFit.contain,
                  ),
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(onTap: tapFunction)),
                  )
                ]),
              ),
              Text(flowers[i])
            ],
          ));
      buttons.add(button);
    }

    return AlertDialog(
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            onPressed: () {
              setState(() {
                selectedFlower = selection;
              });
              Navigator.pop(context);
            },
            child: Text('Confirm'))
      ],
      content: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(8.0),
            crossAxisCount: 3,
            children: buttons,
            semanticChildCount: buttons.length,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height)),
      ),
    );
  }
}
