# Android 侧待修记录

本次只修了 iOS 主实现，Android 侧未改动。下面是核对代码后确认的问题，供后续处理。

## 编译不过

1. **缺依赖** — `app/build.gradle.kts` 只声明了 Gson，但代码用到
   `AppCompatActivity`、`RecyclerView`、`AlertDialog`、`LinearLayoutManager`。
   需要补 `androidx.appcompat:appcompat` 与 `androidx.recyclerview:recyclerview`。
2. **缺资源** — `AndroidManifest.xml` 引用了 `@style/Theme.MyPGRApp` 与
   `@string/app_name`，但 `app/src/main/res/values/` 下只有 `colors.xml`，
   既没有 `themes.xml` 也没有 `strings.xml`。
3. **manifest 冗余属性** — `android:package` 与 `build.gradle.kts` 的
   `namespace` 重复（AGP 8.x 里前者已废弃），建议删掉 manifest 里的 `package`。

## 运行会崩

4. **Activity 未注册** — `AndroidManifest.xml` 只声明了 `MainActivity`，
   但 `MainActivity` 里 `startActivity(CharactersActivity::class.java)` 与
   `OrganizationsActivity`。未注册的 Activity 会抛 `ActivityNotFoundException`，
   也就是首页两个按钮一点就崩。两个 Activity 都需要 `<activity>` 声明。

## 功能失效

5. **图片全部取不到** — `GameData.json` 的 `image` 值是 `LuciaOrion`、`GrayRaven`
   这类 PascalCase，而 `res/drawable/` 里实际是 `lucia1.png`、`gray_raven.png`
   这类小写命名，`getIdentifier()` 因而全部返回 0。与 iOS 侧是同一种病：
   数据键与资源名不一致。修法应当与 iOS 统一到同一个命名契约。
6. **数据已过期** — `app/src/main/assets/GameData.json` 只有 7 角色 / 5 组织，
   iOS 侧已经是 26 / 10，且角色名单不同。目前存在两份彼此独立的数据副本。

## 仓库结构

7. **嵌套克隆** — `android_backup/` 是同一个 GitHub 仓库的完整克隆（自带 `.git`），
   且本身就是旧版。建议删除或移出仓库，否则很容易误改错的那一份。

## 建议的处理顺序

先做 1–4 让 Android 能编译并跑起来（改动集中在两三个配置文件），
再做 5–6 让它显示正确内容；此时应当和 iOS 一起抽出单一的命名契约与单一数据来源，
而不是各自再维护一份。
