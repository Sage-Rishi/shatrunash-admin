import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shatrunash_admin/api/users_api.dart';
import 'package:shatrunash_admin/screens/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Init State
  @override
  void initState() {
    super.initState();
    getUnverifiedUsers();
  }

  //Get users
  Future<void> getUnverifiedUsers() async {
    setState(() => loading = true);
    users = filteredUsers = await UsersApi().getAllUnverifiedUsers(context);
    print("USERS: $users");
    setState(() => loading = false);
  }

  //State Variables
  bool loading = false;
  bool loadingAction = false;
  List<dynamic>? users, filteredUsers;
  String assignedRole = "";
  //Controllers and Keys
  final TextEditingController searchController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  //Widget Build
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        actions: [
          IconButton(onPressed: getUnverifiedUsers, icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: "Search for users",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty ? IconButton(onPressed: _clearSearch, icon: const Icon(Icons.close)) : null,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: loading == true
                    ? [const LinearProgressIndicator()]
                    : loading == false && filteredUsers == null
                        ? [const Text("No users found")]
                        : loading == false && filteredUsers!.isNotEmpty
                            ? List.generate(
                                filteredUsers!.length,
                                (index) => officerCard(index, width, height, context),
                              )
                            : [const Text("No such users found")],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearSearch() {
    searchController.text = "";
    _filterUsers("");
  }

  void _filterUsers(value) {
    if (value.isEmpty) {
      filteredUsers = users;
    } else {
      filteredUsers = users!.where((element) => element['full_name'].toString().toLowerCase().contains(value.toLowerCase())).toList();
    }
    setState(() {});
  }

  GestureDetector officerCard(int index, double width, double height, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  width: width,
                  height: height * 0.75,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RefreshIndicator.adaptive(
                          onRefresh: getUnverifiedUsers,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              CircleAvatar(radius: 80, backgroundImage: NetworkImage(filteredUsers![index]['image_url'])),
                              const SizedBox(height: 10),
                              Text(filteredUsers![index]['full_name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              Text("Phone Number: ${filteredUsers![index]['phone']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              Text("Unit Name: ${filteredUsers![index]['unit']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              Text("Role: ${filteredUsers![index]['role']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              Text("Date of Enrolment: ${formatMillisecondsSinceEpoch(filteredUsers![index]['date_of_enrolment'])}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              Text("Date of Birth: ${formatMillisecondsSinceEpoch(filteredUsers![index]['date_of_birth'])}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              const SizedBox(height: 15),
                              const Text("Assign Role", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              DropdownMenu(
                                width: width - 40,
                                controller: roleController,
                                label: const Text('Select Role for the Officer'),
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(value: 'officer', label: 'Officer'),
                                  DropdownMenuEntry(value: 'commanding_officer', label: 'Commanding Officer'),
                                  DropdownMenuEntry(value: '', label: '-')
                                ],
                                onSelected: (value) => setState(() => assignedRole = value!),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete Officer"),
                                        content: const Text("Are you sure you want to delete this officer?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                setState(() => loadingAction = true);
                                                await UsersApi().deleteUser(context, filteredUsers![index]['uid']);
                                                setState(() => loadingAction = false);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Yes")),
                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
                                        ],
                                      );
                                    });
                              },
                              child: const Text("Delete Officer")),
                          FilledButton(
                              onPressed: () {
                                if (assignedRole.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Verify Officer"),
                                          content: const Text("Are you sure you want to verify this officer?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() => loadingAction = true);
                                                  await UsersApi().verifyUser(context, filteredUsers![index]['uid'], assignedRole);
                                                  setState(() => loadingAction = false);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Yes")),
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
                                          ],
                                        );
                                      });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a role')));
                                }
                              },
                              child: const Text("Verify Officer")),
                        ],
                      ),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    ],
                  ),
                );
              });
            });
        getUnverifiedUsers();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(users![index]['image_url'])),
            title: Text(users![index]['full_name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            subtitle: Text("Phone Number: ${users![index]['phone']}\nUnit Name: ${users![index]['unit']}\nTap for actions", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  String formatMillisecondsSinceEpoch(String milliseconds) {
    int milliInt = int.parse(milliseconds);
    var date = DateTime.fromMillisecondsSinceEpoch(milliInt);
    var formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }
}
