import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_search_route.dart';
import 'package:flutter_maps_creator_v3/maps/models/enums.dart';
import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:flutter_maps_creator_v3/maps/providers/data_general.dart';
import 'package:flutter_maps_creator_v3/maps/providers/google_maps_api.dart';
import 'package:get/get.dart';

class SearchRouteWidget extends StatelessWidget {
  final Function(
          Prediction? origin, Prediction? destiny, bool valid, TypePoint type)?
      onChange;
  final Function()? onTapPointA;
  final Function()? onTapPointB;
  final ControllerSearchRoute miController;
  final TypePoint typePoint;

  const SearchRouteWidget(
      {super.key,
      this.onChange,
      required this.miController,
      this.onTapPointA,
      this.onTapPointB,
      this.typePoint = TypePoint.PointNull});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerSearchRoute>(
        init: miController,
        builder: (ControllerSearchRoute controller) {
          return SizedBox(
            width: Get.width,
            height: Get.height * .2,
            // color: Colors.red,
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: onTapPointA,
                          icon: const Icon(Icons.adjust),
                          color: typePoint == TypePoint.PointA
                              ? Colors.blue
                              : null,
                        ),
                        for (int i = 0; i <= 3; i++)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 1),
                            child: Icon(
                              Icons.circle,
                              size: 4.5,
                            ),
                          ),
                        IconButton(
                          onPressed: onTapPointB,
                          icon: const Icon(Icons.pin_drop_outlined),
                          color: typePoint == TypePoint.PointB
                              ? Colors.blue
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFieldSearch(
                            hintText: 'Origen',
                            controller: controller.controllerOrigin,
                            focusNode: controller.focusNodeOrigin,
                            onTap: () {
                              Navigator.push<Prediction?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PageSearchPlace(
                                    prediction: controller.originPlace,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  controller.originPlace = value;
                                  controller.controllerOrigin.text =
                                      value.description;
                                  onChange?.call(
                                      controller.originPlace,
                                      controller.destinyPlace,
                                      controller.destinyPlace != null,
                                      TypePoint.PointA);
                                }

                                controller.focusNodeOrigin.unfocus();
                              });
                            },
                          ),
                          SizedBox(height: Get.height * .02),
                          TextFieldSearch(
                            hintText: 'Destino',
                            controller: controller.controllerDestiny,
                            focusNode: controller.focusNodeDestiny,
                            onTap: () {
                              Navigator.push<Prediction?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PageSearchPlace(
                                    prediction: controller.destinyPlace,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  controller.destinyPlace = value;
                                  controller.controllerDestiny.text =
                                      value.description;
                                  onChange?.call(
                                      controller.originPlace,
                                      controller.destinyPlace,
                                      controller.originPlace != null,
                                      TypePoint.PointB);
                                }
                                controller.focusNodeDestiny.unfocus();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Transform.rotate(
                          angle: 90 * math.pi / 180,
                          child: const IconButton(
                            icon: Icon(
                              Icons.compare_arrows,
                            ),
                            onPressed: null,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                */
                ],
              ),
            ),
          );
        });
  }
}

class TextFieldSearch extends StatelessWidget {
  final String? hintText;
  final void Function()? onTap;
  final TextEditingController? controller;
  final FocusNode? _focusNode;

  const TextFieldSearch(
      {super.key, this.hintText, this.onTap, this.controller, focusNode})
      : _focusNode = focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: controller,
      readOnly: true,
      onTap: onTap,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(
            // maxWidth: Get.width * .2,
            minWidth: Get.width * .07),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class PageSearchPlace extends StatefulWidget {
  final Prediction? _prediction;
  const PageSearchPlace({super.key, prediction}) : _prediction = prediction;

  @override
  State<PageSearchPlace> createState() => _PageSearchPlaceState();
}

class _PageSearchPlaceState extends State<PageSearchPlace> {
  final MiClienteHttp cliente = MiClienteHttp();
  String _textSearch = '';
  late final FocusNode _focusNode;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _textSearch = widget._prediction?.description ?? '';
    _searchController.text = _textSearch;
    _focusNode = FocusNode();
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
      _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length));
    });
  }

  @override
  void dispose() {
    log('dispose');

    _textSearch = '';
    _searchController.dispose();
    _focusNode.dispose();
    _debounce = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      _searchController.text = '';
                    },
                  ),
                  hintText: 'Buscar dirección',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FutureBuilder(
                  // si la caja de texto NO esta vacio entonces
                  future: _getPredictions(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Prediction>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: ((snapshot.data ?? []).length +
                            DataGeneral().previusSelected.length),
                        itemBuilder: (BuildContext context, int index) {
                          int lenghtP = (snapshot.data ?? []).length;
                          if (index < lenghtP) {
                            Prediction p = snapshot.data![index];
                            return ListTile(
                              visualDensity: const VisualDensity(vertical: -3),
                              title: Text(p.description),
                              leading: const Icon(Icons.pin_drop_outlined),
                              onTap: () {
                                cliente
                                    .getDetailsByIdPlace(p.placeId)
                                    .then((placeDetails) {
                                  double lat = placeDetails['result']
                                      ['geometry']['location']['lat'];
                                  double lng = placeDetails['result']
                                      ['geometry']['location']['lng'];
                                  p.setLatLg(lat, lng);
                                  DataGeneral().previusSelected.add(p);

                                  Navigator.pop(context, p);
                                });
                              },
                            );
                          } else {
                            Prediction pPrevius =
                                DataGeneral().previusSelected[index - lenghtP];
                            return ListTile(
                              visualDensity: const VisualDensity(vertical: -3),
                              title: Text(pPrevius.description),
                              leading: const Icon(Icons.access_time),
                              trailing: const Text('Reciente'),
                              onTap: () {
                                Navigator.pop(context, pPrevius);
                              },
                            );
                          }
                        },
                      );
                    } else {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchTextChanged(String text) {
    log('Se buscara: $text');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (text.isNotEmpty) {
        // await cliente.getPredictions('mexico');
        setState(() {
          log('State: ');
          _textSearch = text;
        });
      }
    });
  }

  Future<List<Prediction>> _getPredictions() async {
    List<Prediction> prediccions = await (_textSearch.isNotEmpty
        // si el objeto _prediction no es nulo
        // Y la lista anterior de prediciones NO esta vacia
        // Y ademas el texto de la busqueda anterior es el mismo que _textSearch entonces
        // regresamos la lista anterior
        ? widget._prediction != null &&
                widget._prediction!.predictionsAntesor.predictions.isNotEmpty &&
                widget._prediction!.predictionsAntesor.searchText == _textSearch
            // se muestran las prediciones anteriores
            ? Future(() => widget._prediction!.predictionsAntesor.predictions)
            // si no, se buscan las predicciones
            : cliente.getPredictions(_textSearch)
        // se muestra una lista vacia
        : Future(() => <Prediction>[]));

    List<Prediction> retorno = [];

    for (Prediction p in prediccions) {
      bool seRepite = false;

      for (Prediction pPrevius in DataGeneral().previusSelected) {
        if (pPrevius.placeId == p.placeId) {
          seRepite = true;
          break;
        }
      }

      if (!seRepite) {
        retorno.add(p);
      }
    }

    // odena las predicciones anteriores
    // _orderPredictions(DataGeneral()., _textSearch);
    DataGeneral().orderPredictions(_textSearch);
    return retorno;
  }
}
