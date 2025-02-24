import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/components/Toast/ErrorToast.dart';
import 'package:app_version_api/components/Toast/SuccessToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/data.dart';
import 'package:glossy/glossy.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var baseClient = BaseClient();
  Data? appData;
  bool? isAddNew;
  bool? reloadData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildMobileLayout(context);
            } else {
              // Desktop Layout
              return _buildDesktopLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Details'),
        leading: Builder(
          builder: (context) {
            return ShadButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: AppDataList(
          baseClient: baseClient,
          onAddNew: () {
            setState(() {
              isAddNew = true;
              Navigator.of(context).pop();
            });
          },
          reloadData: reloadData!,
          onItemSelected: (Data data) {
            setState(() {
              isAddNew = false;
              appData = data;
              Navigator.of(context).pop();
            });
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppDetailsEdit(
              isAddData: isAddNew,
              data: appData,
              dataAdded: () {
                reloadData;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppDataList(
            baseClient: baseClient,
            onAddNew: () {
              setState(() {
                isAddNew = true;
              });
            },
            reloadData: reloadData!,
            onItemSelected: (Data data) {
              setState(() {
                isAddNew = false;
                appData = data;
                print(data.appName);
              });
            },
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 6,
          child: AppDetailsEdit(
            isAddData: isAddNew,
            data: appData,
            dataAdded: () {
              setState(() {
                isAddNew = null;
                appData = null;
                reloadData = true;
              });
            },
          ),
        ),
      ],
    );
  }
}

class AppDetailsEdit extends StatefulWidget {
  const AppDetailsEdit({
    super.key,
    required this.data,
    required this.isAddData,
    required this.dataAdded,
  });

  final Data? data;
  final bool? isAddData; 
  final VoidCallback dataAdded;

  @override
  _AppDetailsEditState createState() => _AppDetailsEditState();
}

class _AppDetailsEditState extends State<AppDetailsEdit>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<ShadFormState>();
  late TextEditingController appVersionTextEditingController;
  late TextEditingController appVersionCodeTextEditingController;
  late TextEditingController appNameTextEditingController;
  late TextEditingController appDownloadLinkTextEditingController;
  bool isLoading = false;
  bool isDeleteLoading = false;

  @override
  void initState() {
    super.initState();

    appVersionTextEditingController = TextEditingController();
    appVersionCodeTextEditingController = TextEditingController();
    appNameTextEditingController = TextEditingController();
    appDownloadLinkTextEditingController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant AppDetailsEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.isAddData != oldWidget.isAddData) {
      if (widget.isAddData == true) {
        _clearControllers();
      } else if (widget.isAddData == false) {
        _initializeControllers();
      }
    }
  }

  void _initializeControllers() {
    final appData = widget.data!;
    appVersionCodeTextEditingController.text =
        appData.appVersionCode?.toString() ?? '';
    appVersionTextEditingController.text = appData.appVersion.toString();
    appDownloadLinkTextEditingController.text = appData.appDownloadLink ?? '';
    appNameTextEditingController.text = appData.appName ?? '';
  }

  void _clearControllers() {
    appVersionCodeTextEditingController.clear();
    appVersionTextEditingController.clear();
    appDownloadLinkTextEditingController.clear();
    appNameTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isAddData);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: widget.isAddData == null
          ? const Center(child: Text('Select or Add App Data'))
          : SingleChildScrollView(
              child: ShadForm(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isAddData == true
                              ? "Add App Data"
                              : "Edit ${widget.data?.appName}",
                          style: ShadTheme.of(context).textTheme.h1,
                        ),
                        if (!(widget.isAddData == true))
                          isDeleteLoading
                              ? const CircularProgressIndicator()
                              : ShadButton.destructive(
                                  onPressed: () async {
                                    setState(() {
                                      isDeleteLoading = true;
                                    });
                                    await BaseClient()
                                        .deleteData(widget.data!.appUUID!);
                                    widget.dataAdded();
                                    setState(() {
                                      isDeleteLoading = false;
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "App Name",
                      controller: appNameTextEditingController,
                      context: context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'App Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      label: "App Version",
                      controller: appVersionTextEditingController,
                      context: context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'App Version is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      label: "App Version Code",
                      controller: appVersionCodeTextEditingController,
                      context: context,
                      validator: (value) {
                        return null; // Optional field
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "App Download Link",
                      controller: appDownloadLinkTextEditingController,
                      context: context,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'App Download Link is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShadButton.outline(
                          onPressed: () {
                            widget.dataAdded();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ShadButton(
                          onPressed: () async {
                            if (_formKey.currentState!.saveAndValidate()) {
                              setState(() {
                                isLoading = true;
                              });
                              var data = Data(
                                appName: appNameTextEditingController.text,
                                appVersion: double.parse(
                                    appVersionTextEditingController.text),
                                appVersionCode: double.tryParse(
                                    appVersionCodeTextEditingController.text),
                                appDownloadLink:
                                    appDownloadLinkTextEditingController.text,
                                appUUID: widget.data?.appUUID,
                              );
                              if (widget.isAddData == true) {
                                var response = await BaseClient()
                                    .saveData(data)
                                    .catchError((error) {
                                  print("From post $error");
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                if (response["success"] == "true") {
                                  widget.dataAdded();
                                  _clearControllers();
                                  Successtoast.show(
                                      context, response["message"].toString());
                                } else {
                                  ErrorToast.show(
                                      context, response["message"].toString());
                                }
                              } else {
                                var response = await BaseClient()
                                    .patchData(data)
                                    .catchError((error) {
                                  print("From patch $error");
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                if (response["success"] == "true") {
                                  widget.dataAdded();
                                  _clearControllers();
                                  Successtoast.show(
                                      context, response["message"].toString());
                                } else {
                                  ErrorToast.show(
                                      context, response["message"].toString());
                                }
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading)
                                Container(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeCap: StrokeCap.round,
                                    strokeWidth: 2,
                                    color: ShadTheme.of(context)
                                        .colorScheme
                                        .primaryForeground,
                                  ),
                                ),
                              if (isLoading) SizedBox(width: 5),
                              const Text("Save"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ShadTheme.of(context).textTheme.p),
        const SizedBox(height: 8),
        ShadInputFormField(
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ShadTheme.of(context).textTheme.h3),
        const SizedBox(height: 8),
        ShadInputFormField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}

class AppDataList extends StatefulWidget {
  AppDataList(
      {super.key,
      required this.baseClient,
      required this.onAddNew,
      required this.onItemSelected,
      required this.reloadData});

  final BaseClient baseClient;
  final Function(Data) onItemSelected;
  final VoidCallback onAddNew;
  bool reloadData;

  @override
  State<AppDataList> createState() => _AppDataListState();
}

class _AppDataListState extends State<AppDataList> {
  List<Data>? _dataList;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var dataList =
          await widget.baseClient.getData(SharedPreferencesHelper.getAPIKEY()!);
      setState(() {
        _dataList = dataList;
        _isLoading = false;
      });
    } catch (error) {
      _dataList = [];
      print(error);
      setState(() {
        if (error.toString().contains("Bad state: No element ")) {
          _error = error.toString();
        }
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppDataList oldWidget) {
    if (widget.reloadData != oldWidget.reloadData) {}
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reloadData == true) {
      _fetchData();
      setState(() {
        widget.reloadData = false;
      });
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: apiKeyView(SharedPreferencesHelper.getAPIKEY(), context),
        ),
        if (_isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (_error != null)
          Expanded(child: Center(child: Text('Error $_error'))),
        if (!_isLoading && _error == null)
          if (_dataList == null || _dataList!.isEmpty)
            const Expanded(child: Center(child: Text('No data found')))
          else
            Expanded(
              child: SuperListView.builder(
                itemCount: _dataList!.length,
                itemBuilder: (context, index) {
                  var dataItem = _dataList![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          widget.onItemSelected(dataItem);
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(dataItem.appName ?? 'No Name'),
                          subtitle: Text("Version: ${dataItem.appVersion}"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              widget.onAddNew();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text("Add"),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  SharedPreferencesHelper.getUsername()!,
                  style: ShadTheme.of(context).textTheme.small,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  SharedPreferencesHelper.clearAll();
                  context.go('/register');
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget apiKeyView(String? api, BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          await Clipboard.setData(ClipboardData(text: api!));
          Successtoast.show(context, "Copied to clipboard");
        } catch (e) {
          ErrorToast.show(context, "Unable to copy");
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: ShadCard(        
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "API Key:",
              style: ShadTheme.of(context).textTheme.small,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: Text(
                api ?? "Error: Please log out and log in again",
                style: ShadTheme.of(context).textTheme.small,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
