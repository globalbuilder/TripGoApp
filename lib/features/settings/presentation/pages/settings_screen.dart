import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/utils/messages.dart';
import '../blocs/settings_bloc.dart';
import '../blocs/settings_event.dart';
import '../blocs/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading of existing settings from SharedPreferences
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use our CustomAppBar and provide a return/back icon via "leading"
      appBar: CustomAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Remove the drawer – we have a back button now.
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.error) {
            MessageUtils.showErrorMessage(
                context, 'Failed to load or update settings.');
          }
        },
        builder: (context, state) {
          // If we're loading (and language is not yet loaded), show a loader
          if (state.status == SettingsStatus.loading && state.languageCode.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: state.isDarkMode,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(ToggleDarkModeEvent(value));
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: state.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('Arabic'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsBloc>().add(SwitchLanguageEvent(value));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
