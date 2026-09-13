# 已知缺陷与后续工作

记录本次审查中发现、但**尚未修复**的问题。已修复的内容见 README 与提交历史。

## 1. 自定义字体从未生效（本次不动工程）

代码用名字引用了 Rajdhani：

```swift
UIFont(name: "Rajdhani-Bold", size: 20)
UIFont(name: "Rajdhani-Regular", size: 14)
```

但字体文件既没有加入 target 的 Resources，`Info.plist` 也没有 `UIAppFonts` 声明：

- `project.pbxproj` 中 Rajdhani 出现次数：0
- `Info.plist` 中 `UIAppFonts`：无

也就是说 `UIFont(name:)` 一直返回 `nil`，界面实际渲染的是系统字体。字体文件已在
`OnboradingExperience/Fonts/` 入库，但目前只是保存，没有被应用使用。

**修复要点**（下次动工程时）：

1. 把 `.ttf` 加入 app target 的 Resources（`.eot`/`.woff`/`.woff2`/`.svg` 是 Web 格式，iOS 用不到，不需要入包）。
2. 在 `Info.plist` 增加 `UIAppFonts` 数组，逐项填写文件名。
3. **核对真实 PostScript 名**。`Rajdhani-Bold` / `Rajdhani-Regular` 是猜测值，可能与字体内嵌名称不符。用下列命令确认后再改代码：

   ```bash
   python3 -c "
   from fontTools.ttLib import TTFont
   import sys
   for p in sys.argv[1:]:
       f = TTFont(p)
       print(p, '->', f['name'].getDebugName(6))
   " OnboradingExperience/Fonts/*.ttf
   ```

   （无 fontTools 时用「字体册.app」打开 .ttf 查看「PostScript 名称」。）
4. 字体加载失败时不应静默降级，建议保留现在 `if let font = ...` 的写法并补一条日志。

## 2. 首页两个磁贴没有目标页面

`Items&Concepts` 与 `Developers` 的视图控制器在 `d9f7ffc` 重构时被删除，但 storyboard
里仍保留着同名 scene 的 identifier，首页磁贴也仍列着它们。

本次改动后点击不会崩（置灰 + 记日志），但功能仍然缺失。后续要么补回页面，要么从首页移除。

## 3. Android 侧

见 [android-todo.md](./android-todo.md)。
