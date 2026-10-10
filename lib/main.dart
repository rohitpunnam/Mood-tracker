
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mood_provider.dart';
import 'quote_service.dart';

void main() {
  runApp(const MoodApp());
}

// Mood scale: 0 = lowest, 4 = highest.
const moods = [
  ('😢', 'Awful'),
  ('🙁', 'Bad'),
  ('😐', 'Okay'),
  ('🙂', 'Good'),
  ('😄', 'Great'),
];

class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoodProvider(),
      child: MaterialApp(
        title: 'Mood Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 1,
          ),
        ),
        home: const HomeShell(),
        routes: {
          '/history': (_) => const HistoryRoute(),
          '/stats': (_) => const StatsRoute(),
        },
      ),
    );
  }
}

// Main shell with bottom navigation.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    const titles = ['Mood Tracker', 'History', 'Stats'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Open screen',
            onSelected: (route) => Navigator.pushNamed(context, route),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: '/history',
                child: Text('Open History'),
              ),
              PopupMenuItem(
                value: '/stats',
                child: Text('Open Stats'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          LogPage(),
          HistoryPage(),
          StatsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() => _index = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add_reaction_outlined),
            label: 'Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

// Reusable page wrappers for named routes.
class HistoryRoute extends StatelessWidget {
  const HistoryRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood History')),
      body: const HistoryPage(),
    );
  }
}

class StatsRoute extends StatelessWidget {
  const StatsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Statistics')),
      body: const StatsPage(),
    );
  }
}

// --------------------------------------------------
// SCREEN 1: LOG MOOD
class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  int? _selectedMood;
  String _quote = 'Every day is a new beginning.';

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    try {
      final quote = await QuoteService().fetchQuote();

      if (!mounted) return;

      setState(() => _quote = quote);
    } catch (_) {
      // Keep the fallback quote if the API is unavailable.
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveMood() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood first.')),
      );
      return;
    }

    context.read<MoodProvider>().addMood(
          _selectedMood!,
          _noteController.text.trim(),
        );

    setState(() => _selectedMood = null);
    _noteController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mood saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Take a moment to check in with yourself.'),
            const SizedBox(height: 24),

            // Responsive mood selector.
            Wrap(
              alignment: WrapAlignment.center,
              spacing: constraints.maxWidth < 400 ? 4 : 12,
              runSpacing: 12,
              children: [
                for (int i = 0; i < moods.length; i++)
                  MoodOption(
                    emoji: moods[i].$1,
                    label: moods[i].$2,
                    selected: _selectedMood == i,
                    onTap: () => setState(() => _selectedMood = i),
                  ),
              ],
            ),

            const SizedBox(height: 28),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _noteController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Add a note (optional)',
                  hintText: 'What made you feel this way?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (value) {
                  if ((value?.length ?? 0) > 200) {
                    return 'Keep your note under 200 characters.';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: _saveMood,
              icon: const Icon(Icons.check),
              label: const Text('Save mood'),
            ),

            const SizedBox(height: 28),

            // Quote card.
            Card(
              color: scheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 30,
                      color: scheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _quote,
                        style: TextStyle(
                          color: scheme.onSecondaryContainer,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Consumer<MoodProvider>(
                builder: (context, provider, _) => Text(
                  'You have logged ${provider.entries.length} moods.',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom reusable mood option with a simple animation.
class MoodOption extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MoodOption({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 86,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SCREEN 2: HISTORY
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatDate(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(time.day)}/${two(time.month)}/${time.year} '
        '${two(time.hour)}:${two(time.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<MoodProvider>().entries;

    if (entries.isEmpty) {
      return const Center(
        child: Text('No moods logged yet.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return Dismissible(
          key: ValueKey(entry.time.toIso8601String()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<MoodProvider>().deleteMood(entry);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mood entry deleted.')),
            );
          },
          child: Card(
            child: ListTile(
              leading: Text(
                moods[entry.mood].$1,
                style: const TextStyle(fontSize: 32),
              ),
              title: Text(moods[entry.mood].$2),
              subtitle: Text(
                entry.note.isEmpty
                    ? _formatDate(entry.time)
                    : '${entry.note}\n${_formatDate(entry.time)}',
              ),
              isThreeLine: entry.note.isNotEmpty,
            ),
          ),
        );
      },
    );
  }
}

// --------------------------------------------------
// SCREEN 3: STATS
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<MoodProvider>().entries;

    if (entries.isEmpty) {
      return const Center(
        child: Text('Log a mood to see your statistics.'),
      );
    }

    final counts = List<int>.filled(moods.length, 0);

    for (final entry in entries) {
      counts[entry.mood]++;
    }

    final average =
        entries.map((entry) => entry.mood).reduce((a, b) => a + b) /
            entries.length;

    final averageMood = moods[average.round()];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  averageMood.$1,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Average mood: ${averageMood.$2}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('${entries.length} entries logged'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Mood breakdown',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),

        for (int i = moods.length - 1; i >= 0; i--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  moods[i].$1,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                SizedBox(width: 48, child: Text(moods[i].$2)),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: counts[i] / entries.length,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 24,
                  child: Text('${counts[i]}'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
