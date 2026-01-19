# 📦 AnimatedExpand
A customizable and animated expandable widget for Flutter.

`AnimatedExpand` allows you to smoothly expand and collapse UI elements with animations. It supports both **vertical and horizontal** expansion, custom controllers, and fine-tuned animation settings.

---

## 🚀 Features
✔ **Smooth Expansion & Collapse** using `AnimatedSize` and `AnimatedSwitcher`  
✔ **Customizable Headers** – Supports different widgets for expanded & collapsed states  
✔ **Works with Controllers** – Use `ExpandController` to programmatically control state  
✔ **Supports Both Directions** – Expand **horizontally** or **vertically**  
✔ **Flexible Layout Options** – Customize spacing, alignment, clip behavior, etc.  
✔ **Callback Support** – Get notified when animation completes  

---

## 📦 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  animated_expand: 1.0.2
```

Then, import the package in your Flutter app:

```dart
import 'package:animated_expand/animated_expand.dart'; 
```

---

## 🔧 Usage

### **🔹 Basic Example**
```dart
AnimatedExpand(
  expandedHeader: Text('Expanded Header'),
  collapsedHeader: Text('Collapsed Header'),
  content: Text('This is the content that will expand.'),
)
```

---

### **🔹 With `ExpandController` (Programmatic Control)**
Use `ExpandController` to manually expand/collapse the widget.

```dart
final controller = ExpandController();

AnimatedExpand(
  controller: controller,
  expandedHeader: GestureDetector(
    onTap: controller.collapse,
    child: Text('Tap to Collapse'),
  ),
  collapsedHeader: GestureDetector(
    onTap: controller.expand,
    child: Text('Tap to Expand'),
  ),
  content: Text('Expanding content...'),
);

// Programmatically control expansion:
controller.expand();
controller.collapse();
controller.toggle();
```

---

### **🔹 Horizontal Expansion**
```dart
AnimatedExpand(
  axis: Axis.horizontal,
  expandedHeader: Icon(Icons.arrow_back),
  collapsedHeader: Icon(Icons.arrow_forward),
  content: Row(
    children: [Icon(Icons.star), Icon(Icons.star)],
  ),
)
```

---

### **🔹 Reversed Order**
```dart
AnimatedExpand(
  reversed: true, // Content appears before the header
  expandedHeader: Text("Expanded Header"),
  collapsedHeader: Text("Collapsed Header"),
  content: Text("This is the content"),
)
```

---

## 🎛️ Customization Options

| Property               | Type                    | Default               | Description |
|------------------------|------------------------|-----------------------|-------------|
| `expandedHeader`       | `Widget`               | **Required**          | The header shown when expanded |
| `collapsedHeader`      | `Widget?`              | `null`                | The header shown when collapsed |
| `content`             | `Widget?`              | `null`                | The expanding content |
| `controller`          | `ExpandController?`    | `null` (optional)     | External controller for programmatic expansion |
| `initialState`        | `ExpandState`          | `ExpandState.collapsed` | Initial state |
| `axis`               | `Axis`                 | `Axis.vertical`       | Expansion direction |
| `spacing`            | `double`               | `0.0`                 | Space between header & content |
| `curve`              | `Curve`                | `Curves.fastOutSlowIn` | Animation curve |
| `duration`           | `Duration`             | `Durations.medium1`   | Expand animation duration |
| `reverseDuration`    | `Duration`             | `Duration.zero`       | Collapse animation duration |
| `mainAxisSize`       | `MainAxisSize`         | `MainAxisSize.max`    | Column/Row main axis size |
| `mainAxisAlignment`  | `MainAxisAlignment`    | `MainAxisAlignment.start` | Alignment along the main axis |
| `crossAxisAlignment` | `CrossAxisAlignment`   | `CrossAxisAlignment.center` | Alignment along the cross axis |
| `clipBehavior`       | `Clip`                 | `Clip.hardEdge`       | Clipping behavior |
| `reversed`           | `bool`                 | `false`               | If `true`, content appears **before** the header |
| `onEnd`              | `VoidCallback?`        | `null`                | Callback when animation completes |
| `animationAlignment` | `AlignmentGeometry`    | `Alignment.center`    | Alignment of animation |

---

## ✅ Testing
This package includes unit tests. To run them:

```sh
flutter test
```

---

## 📜 License
MIT License

---

## 🌟 Support
Like this package? Give it a ⭐ on GitHub!  
