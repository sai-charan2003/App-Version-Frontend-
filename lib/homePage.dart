 // Ensure correct import
import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/components/data.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:glossy/glossy.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  var baseClient = BaseClient(); 
  Data? appData;
  bool? isAddNew;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(          
          children: [
            Expanded(child: AppDataList(baseClient: baseClient, onAddNew: () { 
              setState(() {       
                isAddNew = true;         
                
              });
             }, onItemSelected: (Data data) { 
                setState(() {
                  isAddNew = false;
                  print("hi");
                  print(data.appDownloadLink);
                  appData = data;
                });
              },)),
              VerticalDivider(),
              
            Expanded(flex: 3,child: AppDetailsEdit(isAddData: isAddNew, data: appData)),
          ],
        ),
      ),
    );
  }

}

class AppDetailsEdit extends StatelessWidget {
  const AppDetailsEdit({
    super.key,
    required this.data,
    required this.isAddData
  });
  final Data? data;
  final bool? isAddData;

  @override
  Widget build(BuildContext context) {
    print(isAddData);
    Data appData = isAddData == false ? data! : Data();
    var appVersionTextEditingController = TextEditingController();
    var appVersionCodeTextEditingController = TextEditingController();
    var appNameTextEditingController = TextEditingController();
    var appDownloadLinkTextEditingController = TextEditingController();
    if(isAddData == false){
      appVersionCodeTextEditingController.text = appData.appVersionCode.toString();
      appVersionTextEditingController.text = appData.appVersion.toString();
      appDownloadLinkTextEditingController.text = appData.appDownloadLink.toString();
      appNameTextEditingController.text = appData.appName.toString();
    }
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: isAddData==null?Container():Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isAddData == false ? "Edit App Data" : "Add App Data"),
          const SizedBox(height: 16),
          const Text("App Version"),
          TextField(
            controller: appVersionTextEditingController,
            decoration: const InputDecoration(
              
              border: OutlineInputBorder(
                
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("App Name"),
          TextField(
            controller: appNameTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text("App Version Code"),
          TextField(
            controller: appVersionCodeTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text("App Download Link"),
          TextField(
            controller: appDownloadLinkTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(onPressed: () {
            var data = Data(
              appName: appNameTextEditingController.text,
              appVersion: int.parse(appVersionTextEditingController.text),
              appVersionCode: int.parse(appVersionCodeTextEditingController.text),
              appDownloadLink: appDownloadLinkTextEditingController.text
            );
            
            
            var response = BaseClient().saveData(data).catchError((error){print(error);});
                     

          }, child: const Text("Register")),

        
        ],
      ),
    );
  }
}

class AppDataList extends StatelessWidget {
  const AppDataList({
    super.key,
    required this.baseClient,
    required this.onAddNew,
    required this.onItemSelected,
    
  });

  final BaseClient baseClient;
  final Function(Data) onItemSelected;
  final VoidCallback onAddNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 16),
        apiKeyView(SharedPreferencesHelper.getAPIKEY(),context),
        Expanded(
          child: FutureBuilder<List<Data>>(
            future: baseClient.getData(SharedPreferencesHelper.getAPIKEY()!),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); 
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var dataItem = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          onItemSelected(dataItem);
                        
                        },
                        child: GlossyContainer(
                          height: 200,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(children: [
                                const Text("App Name: "),
                                Text(dataItem.appName ?? 'No Name'),                              
                        
                              ],),
                              Row(children: [
                                const Text("App Version: "),
                                Text(dataItem.appVersion.toString() ?? 'No Name'),                              
                        
                              ],),
                              Row(children: [
                                const Text("App Version Code: "),
                                Text(dataItem.appVersionCode.toString() ?? 'No Name'),                              
                        
                              ],),
                              Row(children: [
                                const Text("App Download Link: "),
                                Text(dataItem.appDownloadLink ?? 'No Name'),                              
                        
                              ],),
                        
                              
                              
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
              } else {
                return const Center(child: Text('Unexpected error'));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0), 
          child: InkWell(
            customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
            onTap: () {
              print("object");
              onAddNew();
              
                            
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Row(
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
      ],
    );
  }
}

Widget apiKeyView(String? api,BuildContext context){
  return GlossyContainer(
    borderRadius: BorderRadius.circular(12),
    padding: const EdgeInsets.all(8),
    height: 40,
    width: double.infinity,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("API Key:",style: Theme.of(context).textTheme.bodySmall),
          Text(api ?? "Error Please logOut and login again",style: Theme.of(context).textTheme.bodySmall,),       
      
        ],
      
      ),
    ),
  );
}

