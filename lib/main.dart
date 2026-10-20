import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------- Màu sắc ----------
const kBlue = Color(0xFF1E88E5);
const kItemBlue = Color(0xFFBBDEFB);
const kBoxLight = Color(0xFF9DB8F5);
const kBoxDark = Color(0xFF4F86EE);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Components',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: kBlue),
      home: const WelcomeScreen(),
    );
  }
}

// =====================================================
// Dữ liệu danh sách components (theo slide 63 + 64)
// =====================================================
class UiItem {
  final String title;
  final String desc;
  final Widget Function() builder;
  const UiItem(this.title, this.desc, this.builder);
}

class UiSection {
  final String title;
  final List<UiItem> items;
  const UiSection(this.title, this.items);
}

final List<UiSection> sections = [
  UiSection('Display', [
    UiItem('Text', 'Displays text', () => const TextDetail()),
    UiItem('Image', 'Displays an image', () => const ImageDetail()),
  ]),
  UiSection('Input', [
    UiItem('TextField', 'Input field for text', () => const TextFieldDetail()),
    UiItem('PasswordField', 'Input field for passwords', () => const PasswordDetail()),
    UiItem('Toggle', 'On/off switch', () => const ToggleDetail()),
    UiItem('Slider', 'Selects a value from a range', () => const SliderDetail()),
    UiItem('DatePicker', 'Selects a date and time', () => const DatePickerDetail()),
  ]),
  UiSection('Selection', [
    UiItem('Button', 'Triggers an action when tapped', () => const ButtonDetail()),
    UiItem('Checkbox', 'Selects one or multiple options', () => const CheckboxDetail()),
    UiItem('RadioButton', 'Selects a single option', () => const RadioDetail()),
    UiItem('Picker', 'Selects a value from a list', () => const PickerDetail()),
  ]),
  UiSection('Navigation', [
    UiItem('NavigationView', 'Navigation container with title and back button',
        () => const NavigationViewDetail()),
    UiItem('TabBar', 'Switches between main sections', () => const TabBarDetail()),
    UiItem('Menu', 'Shows a menu with multiple actions', () => const MenuDetail()),
  ]),
  UiSection('Content', [
    UiItem('List', 'Displays a list of items', () => const ListDetail()),
    UiItem('Card', 'Container with content and style', () => const CardDetail()),
    UiItem('Divider', 'Separates content into sections', () => const DividerDetail()),
  ]),
  UiSection('Layout', [
    UiItem('Column', 'Arranges elements vertically', () => const ColumnDetail()),
    UiItem('Row', 'Arranges elements horizontally', () => const RowDetail()),
  ]),
];

// =====================================================
// 1. Màn hình chào
// =====================================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/jetpack_compose_logo.png', height: 140),
              const SizedBox(height: 24),
              const Text('Jetpack Compose',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              const Text(
                'Jetpack Compose is a modern UI toolkit for building native '
                'Android applications using a declarative programming approach.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: kBlue),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComponentsListScreen()),
                  ),
                  child: const Text("I'm ready"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// 2. Danh sách UI Components
// =====================================================
class ComponentsListScreen extends StatelessWidget {
  const ComponentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('UI Components List',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kBlue, fontSize: 18)),
            ),
            for (final s in sections) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 6),
                child: Text(s.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
              ),
              for (final item in s.items)
                ComponentItem(
                  item: item,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScaffold(
                          title: item.title, body: item.builder()),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ComponentItem extends StatelessWidget {
  final UiItem item;
  final VoidCallback onTap;
  const ComponentItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: kItemBlue,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(item.desc, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// Khung chung cho màn chi tiết (có nút Back)
// =====================================================
class DetailScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  const DetailScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title, style: const TextStyle(color: kBlue)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: body,
    );
  }
}

// =====================================================
// DISPLAY
// =====================================================
class TextDetail extends StatelessWidget {
  const TextDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 26, height: 1.8, color: Colors.black),
            children: [
              const TextSpan(text: 'The '),
              const TextSpan(
                  text: 'quick ',
                  style: TextStyle(decoration: TextDecoration.lineThrough)),
              const TextSpan(
                  text: 'Brown\n',
                  style: TextStyle(color: Color(0xFFCC7A00), fontSize: 34)),
              const TextSpan(text: 'fox '),
              const TextSpan(text: 'jumps ', style: TextStyle(letterSpacing: 6)),
              const TextSpan(
                  text: 'over\n',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
              const TextSpan(
                  text: 'the ',
                  style: TextStyle(decoration: TextDecoration.underline)),
              const TextSpan(
                  text: 'lazy ',
                  style: TextStyle(
                      fontFamily: 'cursive',
                      fontStyle: FontStyle.italic,
                      fontSize: 18)),
              const TextSpan(text: 'dog.'),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDetail extends StatelessWidget {
  const ImageDetail({super.key});

  static const url =
      'https://giaothongvantaitphcm.edu.vn/wp-content/uploads/2025/01/Logo-GTVT.png';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                  height: 160, child: Center(child: Icon(Icons.broken_image))),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(url,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11, decoration: TextDecoration.underline)),
          ),
          const SizedBox(height: 16),
          // Ảnh trong app: đặt assets/uth_campus.jpg và khai báo trong pubspec.yaml
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/uth_campus.jpg',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                  height: 160,
                  child: Center(child: Text('Chưa có assets/uth_campus.jpg'))),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('In app',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// INPUT
// =====================================================
class TextFieldDetail extends StatefulWidget {
  const TextFieldDetail({super.key});

  @override
  State<TextFieldDetail> createState() => _TextFieldDetailState();
}

class _TextFieldDetailState extends State<TextFieldDetail> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (v) => setState(() => text = v),
            decoration: InputDecoration(
              hintText: 'Thông tin nhập',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text.isEmpty ? 'Tự động cập nhật dữ liệu theo textfield' : text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PasswordDetail extends StatefulWidget {
  const PasswordDetail({super.key});

  @override
  State<PasswordDetail> createState() => _PasswordDetailState();
}

class _PasswordDetailState extends State<PasswordDetail> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: TextField(
          obscureText: hidden,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(hidden ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => hidden = !hidden),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleDetail extends StatefulWidget {
  const ToggleDetail({super.key});

  @override
  State<ToggleDetail> createState() => _ToggleDetailState();
}

class _ToggleDetailState extends State<ToggleDetail> {
  bool wifi = true;
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Wi-Fi'),
          subtitle: Text(wifi ? 'Đang bật' : 'Đang tắt'),
          value: wifi,
          onChanged: (v) => setState(() => wifi = v),
        ),
        SwitchListTile(
          title: const Text('Chế độ tối'),
          subtitle: Text(dark ? 'Đang bật' : 'Đang tắt'),
          value: dark,
          onChanged: (v) => setState(() => dark = v),
        ),
      ],
    );
  }
}

class SliderDetail extends StatefulWidget {
  const SliderDetail({super.key});

  @override
  State<SliderDetail> createState() => _SliderDetailState();
}

class _SliderDetailState extends State<SliderDetail> {
  double value = 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${value.round()}',
              style: const TextStyle(fontSize: 48, color: kBlue)),
          Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            label: value.round().toString(),
            onChanged: (v) => setState(() => value = v),
          ),
        ],
      ),
    );
  }
}

class DatePickerDetail extends StatefulWidget {
  const DatePickerDetail({super.key});

  @override
  State<DatePickerDetail> createState() => _DatePickerDetailState();
}

class _DatePickerDetailState extends State<DatePickerDetail> {
  DateTime? date;
  TimeOfDay? time;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
        context: context, initialTime: time ?? TimeOfDay.now());
    if (t != null) setState(() => time = t);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = date == null
        ? 'Chưa chọn ngày'
        : '${date!.day}/${date!.month}/${date!.year}';
    final timeText = time == null ? 'Chưa chọn giờ' : time!.format(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$dateText  -  $timeText',
              style: const TextStyle(fontSize: 18, color: kBlue)),
          const SizedBox(height: 24),
          Wrap(spacing: 12, children: [
            FilledButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Chọn ngày')),
            FilledButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.access_time),
                label: const Text('Chọn giờ')),
          ]),
        ],
      ),
    );
  }
}

// =====================================================
// SELECTION
// =====================================================
class ButtonDetail extends StatelessWidget {
  const ButtonDetail({super.key});

  void _say(BuildContext c, String s) => ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('Bạn vừa bấm: $s')));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilledButton(
              onPressed: () => _say(context, 'Filled'),
              child: const Text('Filled')),
          ElevatedButton(
              onPressed: () => _say(context, 'Elevated'),
              child: const Text('Elevated')),
          OutlinedButton(
              onPressed: () => _say(context, 'Outlined'),
              child: const Text('Outlined')),
          TextButton(
              onPressed: () => _say(context, 'Text'),
              child: const Text('Text')),
          IconButton(
              onPressed: () => _say(context, 'Icon'),
              icon: const Icon(Icons.favorite)),
          FloatingActionButton(
              onPressed: () => _say(context, 'FAB'),
              child: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

class CheckboxDetail extends StatefulWidget {
  const CheckboxDetail({super.key});

  @override
  State<CheckboxDetail> createState() => _CheckboxDetailState();
}

class _CheckboxDetailState extends State<CheckboxDetail> {
  final Map<String, bool> options = {
    'Kotlin': true,
    'Flutter': true,
    'Swift': false,
    'React Native': false,
  };

  @override
  Widget build(BuildContext context) {
    final chosen = options.entries.where((e) => e.value).map((e) => e.key);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final e in options.entries)
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(e.key),
            value: e.value,
            onChanged: (v) => setState(() => options[e.key] = v!),
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Đã chọn: ${chosen.isEmpty ? '(không có)' : chosen.join(', ')}',
              style: const TextStyle(color: kBlue)),
        ),
      ],
    );
  }
}

class RadioDetail extends StatefulWidget {
  const RadioDetail({super.key});

  @override
  State<RadioDetail> createState() => _RadioDetailState();
}

class _RadioDetailState extends State<RadioDetail> {
  String selected = 'Nam';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final v in ['Nam', 'Nữ', 'Khác'])
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: Text(v),
            value: v,
            // ignore: deprecated_member_use
            groupValue: selected,
            // ignore: deprecated_member_use
            onChanged: (x) => setState(() => selected = x!),
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Đã chọn: $selected', style: const TextStyle(color: kBlue)),
        ),
      ],
    );
  }
}

class PickerDetail extends StatefulWidget {
  const PickerDetail({super.key});

  @override
  State<PickerDetail> createState() => _PickerDetailState();
}

class _PickerDetailState extends State<PickerDetail> {
  final cities = ['TP.HCM', 'Hà Nội', 'Đà Nẵng', 'Cần Thơ', 'Huế', 'Nha Trang'];
  String dropdown = 'TP.HCM';
  int wheel = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dropdown', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: dropdown,
            isExpanded: true,
            items: cities
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => dropdown = v!),
          ),
          const SizedBox(height: 24),
          const Text('Wheel picker', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 36,
              onSelectedItemChanged: (i) => setState(() => wheel = i),
              children: cities.map((c) => Center(child: Text(c))).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Text('Dropdown: $dropdown  |  Wheel: ${cities[wheel]}',
              style: const TextStyle(color: kBlue)),
        ],
      ),
    );
  }
}

// =====================================================
// NAVIGATION
// =====================================================
class NavigationViewDetail extends StatelessWidget {
  const NavigationViewDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Màn hình này có title và nút Back ở trên.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DetailScaffold(
                  title: 'Trang con',
                  body: Center(child: Text('Bấm nút Back để quay lại')),
                ),
              ),
            ),
            child: const Text('Đi tới trang con'),
          ),
        ],
      ),
    );
  }
}

class TabBarDetail extends StatelessWidget {
  const TabBarDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: const [
          TabBar(tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.search), text: 'Search'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ]),
          Expanded(
            child: TabBarView(children: [
              Center(child: Text('Nội dung tab Home')),
              Center(child: Text('Nội dung tab Search')),
              Center(child: Text('Nội dung tab Profile')),
            ]),
          ),
        ],
      ),
    );
  }
}

class MenuDetail extends StatefulWidget {
  const MenuDetail({super.key});

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  String action = 'Chưa chọn';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => action = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Chỉnh sửa', child: Text('Chỉnh sửa')),
              PopupMenuItem(value: 'Chia sẻ', child: Text('Chia sẻ')),
              PopupMenuItem(value: 'Xóa', child: Text('Xóa')),
            ],
            child: const Chip(
              avatar: Icon(Icons.more_vert),
              label: Text('Mở menu'),
            ),
          ),
          const SizedBox(height: 24),
          Text('Hành động: $action', style: const TextStyle(color: kBlue)),
        ],
      ),
    );
  }
}

// =====================================================
// CONTENT
// =====================================================
class ListDetail extends StatelessWidget {
  const ListDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (_, i) => ListTile(
        leading: CircleAvatar(child: Text('${i + 1}')),
        title: Text('Item ${i + 1}'),
        subtitle: Text('Mô tả cho item ${i + 1}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class CardDetail extends StatelessWidget {
  const CardDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: ListTile(
            leading: Icon(Icons.school, color: kBlue),
            title: Text('UTH'),
            subtitle: Text('University of Transport HCMC'),
          ),
        ),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Card có đổ bóng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Card là container có nội dung, bo góc và đổ bóng.'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {}, child: const Text('Xem thêm')),
                ),
              ],
            ),
          ),
        ),
        Card(
          color: kItemBlue,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Card có màu nền riêng'),
          ),
        ),
      ],
    );
  }
}

class DividerDetail extends StatelessWidget {
  const DividerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('Phần 1', style: TextStyle(fontSize: 18)),
        Divider(),
        Text('Phần 2', style: TextStyle(fontSize: 18)),
        Divider(thickness: 3, color: kBlue),
        Text('Phần 3 (divider dày, có màu)', style: TextStyle(fontSize: 18)),
        Divider(indent: 40, endIndent: 40),
        Text('Phần 4 (divider thụt lề)', style: TextStyle(fontSize: 18)),
        SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Trái'),
              VerticalDivider(width: 32, thickness: 2),
              Text('Phải'),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// LAYOUT
// =====================================================
class ColumnDetail extends StatelessWidget {
  const ColumnDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(
          4,
          (i) => Container(
            width: double.infinity,
            height: 64,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: i.isEven ? kBoxLight : kBoxDark,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class RowDetail extends StatelessWidget {
  const RowDetail({super.key});

  Widget _box(Color c) => Expanded(
        child: Container(
          height: 52,
          decoration: BoxDecoration(
              color: c, borderRadius: BorderRadius.circular(10)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _box(kBoxLight),
                const SizedBox(width: 8),
                _box(kBoxDark),
                const SizedBox(width: 8),
                _box(kBoxLight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
