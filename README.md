# extra-equip-slot-eqs 额外的装备栏

为《饥荒联机版》添加额外的 **服装栏、护符栏、背包栏**，实现六格装备栏（武器 + 护甲 + 头盔 + 服装 + 护符 + 背包）。

- 这是一个为爱发电的项目。
- 模组详细说明请查看 Steam 创意工坊：[额外的装备栏](https://steamcommunity.com/sharedfiles/filedetails/?id=2946486855)

---

## 功能

- **服装栏**：将背心、大衣等衣物类物品分离到独立插槽，不与护甲冲突
- **护符栏**：将护符类物品分离到独立插槽，可与护甲同时佩戴
- **背包栏**：将背包类物品分离到独立插槽，可与护甲同时装备
- **智能分配**：基于 DST 组件（Component）和标签（Tag）自动识别未知模组物品并分配到对应插槽
- **手动适配**：已适配大量常用模组的物品，精确分配插槽

## 配置选项

| 选项 | 说明 |
|------|------|
| 服装栏 | 是否扩展服装栏 |
| 护符栏 | 是否扩展护符栏 |
| 背包栏 | 是否扩展背包栏 |
| 自动识别服装栏物品 | 将非护甲、非背包的 BODY 槽物品自动分配到服装栏 |
| 自动识别护符栏物品 | 将有 `amulet` 标签的物品自动分配到护符栏 |
| 自动识别背包栏物品 | 将有容器组件的物品自动分配到背包栏 |
| 物品信息 | 鼠标指向物品时显示代码信息 |

## 智能分配逻辑

开启对应自动识别后，对所有 BODY 槽物品按以下优先级判定：

```
1. 有 amulet 标签         → 护符栏（NECK）    ← 最高优先级
2. 有 armor 组件          → 留在身体栏（BODY） ← 有防御的不动
3. 无 armor + 有 container → 背包栏（BACK）
4. 无 armor + 无 container → 服装栏（BELLY）   ← 兜底
```

相比传统的名称字符串匹配，组件/标签检测的优点：
- ✅ **护甲**：`inst.components.armor ~= nil` — 无论物品名是否含 "armor" 都能识别
- ✅ **护符**：`inst:HasTag("amulet")` — 不依赖名称含 "amulet"
- ✅ **背包**：`inst.components.container ~= nil` — 不依赖名称含 "back"/"pack"
- ✅ **多属性物品**：护符标签优先级最高，即使同时有护甲也会分配到护符栏
- ✅ **未知模组兼容**：无需手动适配，自动识别

## 手动适配物品清单

### 服装栏（symbol_belly）

| 物品 | 来源 |
|------|------|
| `raincoat`, `onemanband`, `sweatervest`, `beargervest`, `balloonvest`, `hawaiianshirt`, `armorslurper`, `reflectivevest`, `trunkvest_summer`, `trunkvest_winter`, `carnival_vest_a/b/c` | 原版 |
| `down_filled_coat` | 能力勋章 |
| `cassock`, `kam_lan_cassock`, `madameweb_armor` | 神话书说 |
| `sachet` | 棱镜 |
| `veneto_yifu` | 战舰少女维内托 |
| `dress_sea`, `seele_swimsuit` | 希儿 |
| `lg_fufeng` | 海洋传说 |
| `krm_uniform` | 狂三 |
| `to_school`, `to_angel`, `to_satan` | 鸢一折纸 |
| `woolen_sweater`, `fsm_yunmie_outfits` | 山海秘藏 |
| `ccs_skirt1` | 魔法小樱 |
| `armor_lifejacket`, `tarsuit`, `armor_windbreaker`, `blubbersuit`, `armor_snakeskin` | 岛屿冒险 |
| `myxl_dreambook` | 璇儿 |
| `m_scarf` | M.louis |
| `third_eye`, `third_eye2` | 古明地恋 |
| `satori_eye`, `satori_eye2` | 古明地觉 |
| `armor_carrotlure` | 胡萝卜 |
| `sdf_victorian_suit` | Medievil Reanimated |
| `zhifu` | 战舰少女补给包 |
| `dante_cloth`, `sinner_cloth` | **Limbus Company 边狱巴士** |

### 护符栏（symbol_neck）

| 物品 | 来源 |
|------|------|
| `amulet`, `blueamulet`, `purpleamulet`, `orangeamulet`, `yellowamulet`, `greenamulet` | 原版 |
| `brooch1`~`brooch9`, `brooch24`, `moon_brooch`, `star_brooch` | 伊蕾娜 |
| `sora2amulet`, `sorabowknot` | 小穹 |
| `luckamulet` | 经济学 |
| `wharang_amulet` | 千年狐 |
| `fhl_hsf` | 风幻龙 |
| `ndnr_opalpreciousamulet` | 富贵 |
| `fixer_medal_crimson`, `fixer_medal_indigo`, `fixer_medal_siegfried`, `fixer_medal_winter` | **Limbus Company 边狱巴士** |

### 背包栏（symbol_back）

| 物品 | 来源 |
|------|------|
| `backpack`, `piggyback`, `icepack`, `krampus_sack`, `candybag`, `seedpouch`, `spicepack` | 原版 |
| `mone_seasack`, `mone_seedpouch` | 更多物品 |
| `thatchpack`, `seasack`, `piratepack`, `sludge_sack` | 永不妥协 |

## 兼容性

- 本模组为**服务端模组**（`all_clients_require_mod = true`）
- 与大部分模组兼容，如有兼容问题请在创意工坊留言
- 智能分配基于 DST 组件/标签系统，即使未手动适配的模组物品也能自动分配到正确插槽
- 如遇其他模组的物品未正确分配到对应插槽，请提供物品英文名+模组名称以便适配

## 技术说明

- 通过向 `GLOBAL.EQUIPSLOTS` 注册新插槽实现扩展
- 使用 `AddEquipSlot` 在 UI 中添加装备格子
- 背包物品的容器通过 `GetOverflowContainer` 机制集成到物品堆叠系统
- 兼容新旧 DST 版本的状态图名称（`rebirth` / `amulet_rebirth`）
- 智能分配使用 `inst.components.armor`（护甲组件）、`inst:HasTag("amulet")`（护符标签）、`inst.components.container`（容器组件）进行判定

## 更新历史

- **2.0.5**：
  - 修复代码合并造成的 `Equip` 返回值错误导致鼠标点击物品无响应的问题
- **2.0.4**：
  - 智能分配从名称字符串匹配升级为**组件/标签检测**（更精准、覆盖更广）
  - 新增 Limbus Company 边狱巴士模组适配（2件服装 + 4枚护符）
  - 修复自动分配中 `is_adaptation` 变量未生效的死代码问题
  - 适配复活背包自动打开
  - 新增 `inventory_replica.GetEquippedItem` 补丁提升第三方模组兼容性
- **2.0.3**：修复建造护符崩溃问题、作祟重生护符贴图残留问题、光谱背包贴图问题、融合背包箭头贴图问题
- **1.6.2**：增加更多模组物品装备
- **1.6.1**：增加配置菜单英文支持
- **1.6.0**：移除穹の护为服装栏，并新增其他强制服装栏物品
- **1.5.9**：调整加载优先级以适配其他同类互斥模组
