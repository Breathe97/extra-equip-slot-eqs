name = "额外的装备栏" -- mod的名字

description = [[
󰀜 为人物添加额外的帽子栏、服装栏、护符栏、腰包栏、背包栏。
󰀜 默认：武器 + 护甲 + 头盔 + 护符 + 背包。
󰀜 自动识别：默认只开启护符栏、背包栏。
󰀜 已适配部分模组物品，没有适配的物品会优先智能分配。
󰀜 其他模组的适配可以留言（物品的英文+中文+模组的名称）。

󰀏 近期更新：
2.3.8: 修复雕像等背包重物贴图渲染。
2.3.7: 修复棱镜靠背熊。
2.3.6: 修复错误识别服装栏。
2.3.5: 收紧服装栏自动识别逻辑。

󰀀 图标也抄过来了 嘻嘻。
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
]]

priority = 1                       -- 优先级 默认0 值越大 优先级越低

author = "Breathe"                 -- mod的作者

version = "2.3.8"                  -- mod的版本号

api_version = 10                   -- API版本号

forumthread = ""                   -- 留空就行了

dst_compatible = true              -- 兼容联机
dont_starve_compatible = false     -- 兼容单机
reign_of_giants_compatible = false -- 兼容巨人

all_clients_require_mod = true     -- 客户端mod就false,服务端就true。

-- 为mod指定自定义图标!
icon_atlas = "assets/icon/icon.xml"
icon = "icon.tex"

server_filter_tags = { "refresh", "Krampus", "private" } -- 服务器标签可以不写

configuration_options = {
    { name = "", label = "基本配置", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    {
        name = "SLOTS_HAT",
        label = "头饰栏",
        hover = "是否扩展头饰栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "会额外扩展一个头饰栏，用于装备非护甲的头部物品。"
            }
        },
        default = false
    },
    {
        name = "SLOTS_BELLY",
        label = "服装栏",
        hover = "是否扩展服装栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "会额外扩展一个服装栏。"
            }
        },
        default = false
    },
    {
        name = "SLOTS_WAIST",
        label = "腰包栏",
        hover = "是否扩展腰包栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "会额外扩展一个腰包栏。"
            }
        },
        default = false
    },
    {
        name = "SLOTS_NECK",
        label = "护符栏",
        hover = "是否扩展护符栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "会额外扩展一个护符栏。"
            }
        },
        default = true
    },
    {
        name = "SLOTS_BACK",
        label = "背包栏",
        hover = "是否扩展背包栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "会额外扩展一个背包栏。"
            }
        },
        default = true
    },
    {
        name = "AUTO_SLOTS_BELLY",
        label = "自动识别服装栏物品",
        hover = "通过物品的名称自动识别该物品是否为服装类",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "自动识别未知的模组物品并分配至服装栏。"
            }
        },
        default = false
    },
    {
        name = "AUTO_SLOTS_NECK",
        label = "自动识别护符栏物品",
        hover = "通过物品的名称自动识别该物品是否为护符类",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "自动识别未知的模组物品并分配至护符栏。"
            }
        },
        default = true
    },
    {
        name = "AUTO_SLOTS_BACK",
        label = "自动识别背包栏物品",
        hover = "通过物品的名称自动识别该物品是否为背包类",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "自动识别未知的模组物品并分配至背包栏。"
            }
        },
        default = true
    },
    {
        name = "",
        label = "其他配置 (推荐默认)",
        hover = "",
        options = { { description = "", data = 0 } },
        default = 0
    },
    {
        name = "HOVER_ITEM_CODE",
        label = "物品信息",
        hover = "开启后在游戏内鼠标指向该物品可以查看该物品的代码信息。",
        options = {
            {
                description = "否",
                data = false,
                hover = "关闭物品的代码信息"
            },
            {
                description = "是",
                data = true,
                hover = "显示物品的代码信息"
            }
        },
        default = false
    },
    {
        name = "",
        label = "Uncompromising-永不妥协",
        hover = "",
        options = { { description = "", data = 0 } },
        default = 0
    },
    {
        name = "MOD_YBTX_BELLY",
        label = "强制服装栏",
        hover = "将 透气背心、松软背心、清凉夏装、花衬衫、雨衣 强制识别到服装栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "保持自动分配"
            },
            {
                description = "是",
                data = true,
                hover = "强制装备在服装栏。"
            }
        },
        default = true
    },
    { name = "", label = "Legion-棱镜", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    {
        name = "MOD_LJ_ZGF",
        label = "子圭·釜",
        hover = "强制该物品到身体栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "该物品会装备在背包栏，有失平衡，谨慎开启。"
            },
            {
                description = "是",
                data = true,
                hover = "强制装备在身体栏。"
            }
        },
        default = true
    }
}

local isZh = locale == "zh" or locale == "zhr"

-- 非中文
if not isZh then
    configuration_options = {
        { name = "", label = "Basic configuration",                        hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "SLOTS_HAT",
            label = "Headwear slot",
            hover = "Enable the headwear slot",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Adds an extra slot for non-armor head items." }
            },
            default = false
        },
        {
            name = "SLOTS_BELLY",
            label = "Apparel slot",
            hover = "Enable the apparel slot",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Adds an extra slot for wearable apparel." }
            },
            default = false
        },
        {
            name = "SLOTS_WAIST",
            label = "Waist slot",
            hover = "Enable the waist slot",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Adds an extra slot for waist bag items." }
            },
            default = false
        },
        {
            name = "SLOTS_NECK",
            label = "Amulet slot",
            hover = "Enable the amulet slot",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Adds an extra slot for amulets." }
            },
            default = true
        },
        {
            name = "SLOTS_BACK",
            label = "Backpack slot",
            hover = "Enable the backpack slot",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Adds an extra slot for backpacks." }
            },
            default = true
        },
        {
            name = "AUTO_SLOTS_BELLY",
            label = "Auto-detect apparel",
            hover = "Auto-detect apparel items by their attributes",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Auto-assign unknown mod apparel to the apparel slot." }
            },
            default = false
        },
        {
            name = "AUTO_SLOTS_NECK",
            label = "Auto-detect amulets",
            hover = "Auto-detect amulet items by their tags",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Auto-assign unknown mod amulets to the amulet slot." }
            },
            default = true
        },
        {
            name = "AUTO_SLOTS_BACK",
            label = "Auto-detect backpacks",
            hover = "Auto-detect backpack items by their tags",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Auto-assign unknown mod backpacks to the backpack slot." }
            },
            default = true
        },
        { name = "", label = "Other configurations (recommended default)", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "HOVER_ITEM_CODE",
            label = "Item info",
            hover = "Show item code info on mouse hover in-game.",
            options = {
                { description = "No",  data = false, hover = "Disable item code info." },
                { description = "Yes", data = true,  hover = "Display item code info on hover." }
            },
            default = false
        },
        { name = "", label = "Uncompromising Mode", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_YBTX_BELLY",
            label = "Force apparel slot",
            hover = "Force Breezy Vest, Puffy Vest, Summer Frest, Hawaiian Shirt and Rain Coat into the apparel slot.",
            options = {
                { description = "No",  data = false, hover = "Keep auto-assignment for these items." },
                { description = "Yes", data = true,  hover = "Force these items into the apparel slot." }
            },
            default = true
        },
        { name = "", label = "Legion-棱镜", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_LJ_ZGF",
            label = "子圭·釜 (Zigui Cauldron)",
            hover = "Force this item to the body slot",
            options = {
                { description = "No",  data = false, hover = "This item will be equipped in the backpack slot, may unbalance gameplay, enable with caution." },
                { description = "Yes", data = true,  hover = "Force this item into the body slot." }
            },
            default = true
        }
    }
end
