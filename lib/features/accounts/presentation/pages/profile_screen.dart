// lib/features/accounts/presentation/pages/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_router.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../blocs/accounts_bloc.dart';
import '../blocs/accounts_event.dart';
import '../blocs/accounts_state.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AccountsBloc _accountsBloc;
  
  @override
  void initState() {
    super.initState();
    _accountsBloc = context.read<AccountsBloc>();
    _accountsBloc.add(FetchUserInfoEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: () => Navigator.pushNamed(context, AppRouter.profileEdit),
          ),
        ],
      ),
      body: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          if (state.status == AccountsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.user == null) {
            return const Center(child: Text("No user data available."));
          }
          
          final user = state.user!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        if (user.email != null && user.email!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              user.email!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Information",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text("First Name"),
                          subtitle: Text(user.firstName ?? "-"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text("Last Name"),
                          subtitle: Text(user.lastName ?? "-"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text("Phone Number"),
                          subtitle: Text(user.phoneNumber ?? "-"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text("Address"),
                          subtitle: Text(user.address ?? "-"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
