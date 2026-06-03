# 🦴 养狗日记 (Dog Diary)

> 纯本地单机养宠管理软件 — Flutter 3.44 / Dart 3.5

---

## 5 端通用 (一套源码)

| 平台 | 状态 | 验证 |
|------|------|------|
| **macOS** | ✅ 编译 + 启动 + 数据库 | `flutter build macos` → 进程 PID 验证 + sqlite3 表验证 |
| **iOS 真机** | ✅ 编译 | `flutter build ios --no-codesign` → `Runner.app` 生成 |
| **iOS 模拟器** | ✅ 编译 + 安装 + 启动 | `xcrun simctl install/launch` → PID 验证 |
| **Android** | ⚠️ 平台生成 + 子项目完整 | Gradle 9.1.0 + AGP 9.0.1 网络下载卡死，未能完成首次构建 |
| **Windows** | ⚠️ 平台生成 | 需 Windows 机器构建 |
| **Web** | ❌ dart:ffi 不支持 (sqlite3_flutter_libs) | 需切换到 drift/wasm |

**已验证跑通**：macOS + iOS 真机 + iOS 模拟器
**未跑通（环境问题，非代码问题）**：Android 首次构建卡在网络/Gradle 9 大版本下载、Web 端 sqlite3 兼容性

---

## 13 张数据表 (drift + SQLite)

```
pets                宠物档案
weight_records      体重历史
pet_images          宠物照片
health_events       健康事件 (体检/疫苗/驱虫/跳蚤/手术)
medications         用药
food_inventory      狗粮库存
feeding_records     喂食记录
expenses            记账
walk_records        遛狗
training_logs       训练
settings            设置
forbidden_foods     禁食食物 (15 条种子)
contacts            紧急电话
```

---

## 功能模块 (全部完成)

### 1. 仪表盘
- 宠物数量卡片
- 4 个统计卡: 已逾期/30天内/低库存/本月支出
- 4 个快捷入口
- 顶栏 "扫描提醒" → 立即触发本地通知

### 2. 宠物档案 (CRUD)
- 完整 CRUD: 新建/编辑/删除
- 字段: 名字/品种/生日/性别/绝育/备注
- 体重录入 + 折线图 (fl_chart)
- 历史体重列表 (滑删)

### 3. 健康 (CRUD + 提醒)
- 健康事件: 6 种类型, 含下次提醒日期
- 用药管理: 每日/每周/每月, 在用开关
- 提醒 Tab: 红色已逾期 + 橙色即将到期
- 30 天内提醒自动计算

### 4. 饮食 (CRUD + 库存联动)
- 库存管理: 品牌/产品/口味/总重/剩余/价格/过期
- 低库存警告 (< 1kg)
- 喂食记录: 自动扣减库存, 删除回滚
- 6 种喂食类型: 正餐/零食

### 5. 记账 (CRUD + 图表)
- 6 种类别: 食物/医疗/美容/玩具/训练/其他
- 月度切换 (← →)
- 月度饼图 (fl_chart)
- 分类统计

### 6. 工具
- 数据库备份 (.db 文件复制)
- Excel 多 sheet 导出 (10 sheet)
- 通知扫描: 立即触发
- 主题切换: 跟随系统/浅/深
- 关于

### 7. 二期功能
- 禁食食物库: 15 条内置 + 搜索
- 紧急电话: CRUD, 4 种类型
- 遛狗打卡: 时长/距离/路线
- 训练日志: 指令/时长/表现

---

## 技术栈

```yaml
flutter: 3.44.1 stable
dart: 3.5+
drift: ^2.20.0        # 类型安全 SQLite
flutter_riverpod: ^2.5.1
fl_chart: ^0.69.0     # 图表
flutter_local_notifications: ^17.2.3
excel: ^4.0.2
share_plus: ^10.0.2
file_picker: ^8.1.2
```

---

## 项目结构

```
lib/
├── core/
│   ├── app_router.dart          # 路由
│   ├── app_shell.dart           # 5 Tab 壳
│   ├── notification_service.dart
│   ├── providers.dart
│   ├── reminder_service.dart
│   └── theme.dart
├── db/
│   └── database.dart            # 13 表 + 种子
├── features/
│   ├── contacts/                # 紧急电话
│   ├── dashboard/               # 仪表盘
│   ├── finance/                 # 记账
│   ├── food/                    # 饮食 + 禁食库
│   ├── health/                  # 健康 + 用药
│   ├── pets/                    # 宠物 CRUD
│   ├── tools/                   # 工具
│   ├── training/                # 训练
│   └── walks/                   # 遛狗
└── main.dart
```

---

## 开发命令

```bash
# 装依赖
flutter pub get

# 重新生成 drift 代码
dart run build_runner build --delete-conflicting-outputs

# Mac
flutter build macos --debug
flutter run -d macos

# iOS 真机
flutter build ios --debug --no-codesign
flutter run -d "00008150-001025882E40401C"  # iPhone 17 Pro Max

# iOS 模拟器
xcrun simctl boot "CBE2DB5C-3DFB-48E7-88D9-9EE3B47DA2CF"  # iPhone 17 Pro Max
flutter build ios --debug --no-codesign --simulator
xcrun simctl install booted build/ios/iphonesimulator/Runner.app
xcrun simctl launch booted com.baba.dogDiary

# Android
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
flutter build apk --debug

# Windows
flutter build windows --debug
```

---

## 数据备份

应用目录 (macOS):
```
~/Library/Containers/com.baba.dogDiary/Data/Documents/
├── dog_diary.db             # 主数据库
├── dog_diary_backups/       # 备份
└── dog_diary_exports/       # Excel 导出
```

---

## 编译验证清单

- ✅ `flutter analyze` 0 错误 0 警告
- ✅ `flutter build macos` 编译成功 + 启动 + 数据库写入
- ✅ `flutter build ios --no-codesign` 编译成功
- ✅ `flutter build ios --simulator` 编译成功 + 安装到 iOS 26.3 模拟器 + 启动
- ⚠️ Android 编译卡在 Gradle 9.1.0 首次依赖下载
- ⚠️ Web 端 `sqlite3_flutter_libs` 的 `dart:ffi` 不支持

---

## 已知限制

1. **照片上传未实装** - 表已建 (`pet_images`)，UI 入口未做
2. **通知调度未做定时器** - `scanAndNotify` 是手动触发，没注册后台周期
3. **Excel 导入未实装** - 导出做了，导入只占位
4. **共享/分享按钮未实装** - `share_plus` 装了但没调用

---

_项目最后构建时间: 2026-06-03_

## Build via GitHub Actions

Updated: Thu Jun  4 01:55:35 CST 2026
