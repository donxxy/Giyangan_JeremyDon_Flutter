  import 'package:flutter/material.dart';

void main() {
  runApp(const LostAndFoundApp());
}

class LostAndFoundApp extends StatelessWidget {
  const LostAndFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LostAndFoundHomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
// DATA MODEL
//
// A listing needs more than a Note-style {title, body} shape. It needs a
// status flag (Lost vs Found) that drives both the UI treatment and (in a
// real system) different downstream logic, plus a location field since
// "where" is the single most useful piece of info for reuniting people with
// their stuff. A timestamp is included so listings can be sorted by
// recency, which is how a real bulletin board naturally organizes itself
// (newest posts on top).
// ---------------------------------------------------------------------------

enum ListingType { lost, found }

class LostFoundItem {
  final String id;
  ListingType type;
  String description;
  String location;
  DateTime datePosted;

  LostFoundItem({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.datePosted,
  });
}

class LostAndFoundHomePage extends StatefulWidget {
  const LostAndFoundHomePage({super.key});

  @override
  State<LostAndFoundHomePage> createState() => _LostAndFoundHomePageState();
}

class _LostAndFoundHomePageState extends State<LostAndFoundHomePage> {
  // In-memory data store. Cleared on app restart, per the lab spec.
  final List<LostFoundItem> _items = [];
  int _nextId = 1;

  // ---------------------------------------------------------------------
  // CREATE
  //
  // Opens the shared form dialog with no existing item passed in. The
  // dialog itself doesn't know or care whether it's creating or editing;
  // it just returns a result. Here, a null "existing" means we're building
  // a brand-new LostFoundItem with a fresh id.
  // ---------------------------------------------------------------------
  Future<void> _createItem() async {
    final result = await _showItemFormDialog();
    if (result == null) return; // user cancelled

    setState(() {
      _items.insert(
        0,
        LostFoundItem(
          id: 'item_${_nextId++}',
          type: result.type,
          description: result.description,
          location: result.location,
          datePosted: DateTime.now(),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------
  // UPDATE
  //
  // Same dialog as create, but pre-filled with the existing item's data.
  // We mutate the existing item's fields in place (rather than replacing
  // it in the list) so its id and original datePosted are preserved --
  // editing a listing should correct details, not make it look like a
  // brand-new post.
  // ---------------------------------------------------------------------
  Future<void> _editItem(LostFoundItem item) async {
    final result = await _showItemFormDialog(existing: item);
    if (result == null) return; // user cancelled

    setState(() {
      item.type = result.type;
      item.description = result.description;
      item.location = result.location;
    });
  }

  // ---------------------------------------------------------------------
  // DELETE
  //
  // Deletion is destructive and irreversible in this in-memory model --
  // there's no "undo" or trash bin -- so it's always gated behind an
  // AlertDialog confirmation. A simple confirm dialog was chosen over,
  // say, a "hold to delete" gesture or swipe-to-dismiss-with-snackbar-undo
  // because it is the most explicit and accessible option: it forces a
  // deliberate second action, clearly states what will happen, and works
  // identically regardless of input method (touch, mouse, keyboard,
  // screen reader) -- fitting for something modeling an item being handed
  // back to its owner, where accidentally "un-posting" the wrong listing
  // is a real annoyance.
  // ---------------------------------------------------------------------
  Future<void> _deleteItem(LostFoundItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove this listing?'),
        content: Text(
          'This will permanently remove "${item.description}" from the board. '
          'Use this once the item has been claimed or returned.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: Colors.red.shade900,
              backgroundColor: Colors.red.shade50,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _items.removeWhere((i) => i.id == item.id);
      });
    }
  }

  // ---------------------------------------------------------------------
  // Shared Create/Update form dialog.
  //
  // Returns a small result record with the submitted values, or null if
  // the user cancelled. Using one dialog for both operations avoids
  // duplicating the form + validation logic; only the dialog title/button
  // label and the initial field values differ.
  // ---------------------------------------------------------------------
  Future<_ItemFormResult?> _showItemFormDialog({LostFoundItem? existing}) {
    return showDialog<_ItemFormResult>(
      context: context,
      builder: (context) => _ItemFormDialog(existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found'),
      ),
      // -------------------------------------------------------------
      // READ
      //
      // The list view is just a projection of _items. When _items is
      // empty we show a friendly empty state instead of a bare blank
      // screen, so new users understand the board is working, just
      // unused.
      // -------------------------------------------------------------
      body: _items.isEmpty ? _buildEmptyState() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createItem,
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No listings yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Listing" to post a lost or found item.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _items[index];
        final isLost = item.type == ListingType.lost;
        final accentColor = isLost ? Colors.red.shade700 : Colors.green.shade700;
        final chipColor = isLost ? Colors.red.shade50 : Colors.green.shade50;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // Visual distinction between Lost and Found: icon + color +
            // text label, so the status is legible even without color
            // (e.g. for colorblind users) via the icon and label alone.
            leading: CircleAvatar(
              backgroundColor: chipColor,
              child: Icon(
                isLost ? Icons.help_outline : Icons.check_circle_outline,
                color: accentColor,
              ),
            ),
            title: Text(
              item.description,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isLost ? 'LOST' : 'FOUND',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editItem(item),
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteItem(item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Small immutable carrier for what the form dialog submits back.
class _ItemFormResult {
  final ListingType type;
  final String description;
  final String location;

  _ItemFormResult({
    required this.type,
    required this.description,
    required this.location,
  });
}

// ---------------------------------------------------------------------------
// Shared Create/Update dialog widget.
//
// Kept as its own StatefulWidget (rather than inline in the parent) because
// it owns transient form state (the controllers, the GlobalKey<FormState>,
// the currently-selected ListingType) that has nothing to do with the list
// screen's state, and giving it its own lifecycle keeps that state properly
// scoped and disposed.
// ---------------------------------------------------------------------------
class _ItemFormDialog extends StatefulWidget {
  final LostFoundItem? existing;

  const _ItemFormDialog({this.existing});

  @override
  State<_ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<_ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late ListingType _selectedType;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.existing?.description ?? '');
    _locationController =
        TextEditingController(text: widget.existing?.location ?? '');
    _selectedType = widget.existing?.type ?? ListingType.lost;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    // Running validators is what actually triggers the "required" error
    // text under each field; if any validator returns non-null, the form
    // is invalid and we stop here instead of popping the dialog.
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      _ItemFormResult(
        type: _selectedType,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Listing' : 'New Listing'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lost/Found captured via a segmented toggle. Chosen over a
              // dropdown because there are only two mutually exclusive
              // options, and a toggle makes both choices visible at once
              // without an extra tap to open a menu.
              SegmentedButton<ListingType>(
                segments: const [
                  ButtonSegment(
                    value: ListingType.lost,
                    label: Text('Lost'),
                    icon: Icon(Icons.help_outline),
                  ),
                  ButtonSegment(
                    value: ListingType.found,
                    label: Text('Found'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (selection) {
                  setState(() => _selectedType = selection.first);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Item description',
                  hintText: 'e.g. Black umbrella with wooden handle',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                // Required field #1: an empty description makes the
                // listing meaningless, so this is enforced with a clear
                // inline error rather than silently allowing a blank post.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe the item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g. Library, 2nd floor',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                // Required field #2: location is the other piece of info
                // that actually helps someone recover their item, so it's
                // validated the same way as description.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter where it was lost or found';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditing ? 'Save Changes' : 'Post Listing'),
        ),
      ],
    );
  }
}
