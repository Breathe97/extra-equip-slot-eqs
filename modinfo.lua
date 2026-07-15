name = "额外的装备栏" -- mod的名字

description = [[
󰀜 为人物添加额外的服装栏、护符栏、背包栏。
󰀜 默认：武器 + 护甲 + 头盔 + 服装 + 护符 + 背包。
󰀜 大理石占据护甲而不是背包。
󰀜 已适配部分模组物品，没有适配的物品会优先智能分配。
󰀜 其他模组的适配可以留言（物品的英文+中文+模组的名称）。

󰀏 近期更新：
2.2.6：更新封面图标。
2.2.5：更新图标降低包体积。
2.2.4：优化人物整体渲染逻辑，强化兼容性。
2.2.3：增加强制头盔栏物品。

󰀀 图标也抄过来了 嘻嘻。
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
]]

priority = 1                       -- 优先级 默认0 值越大 优先级越低

author = "Breathe"                 -- mod的作者

version = "2.2.6"                  -- mod的版本号

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
        name = "AUTO_SLOTS_HAT",
        label = "自动识别头饰栏物品",
        hover = "通过物品的属性自动识别该物品是否为非护甲头饰类",
        options = {
            {
                description = "否",
                data = false,
                hover = "下都下了，你确定不开启？"
            },
            {
                description = "是",
                data = true,
                hover = "自动识别未知的模组头饰物品并分配至头饰栏。"
            }
        },
        default = false
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
        hover = "是否识别该物品到额外装备栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "保持该物品在身体栏。"
            },
            {
                description = "是",
                data = true,
                hover = "该物品会装备在背包栏，有失平衡，谨慎开启。"
            }
        },
        default = false
    },
    {
        name = "",
        label = "海洋传说-Legend and sea",
        hover = "",
        options = { { description = "", data = 0 } },
        default = 0
    },
    {
        name = "MOD_HYCS_YHFF",
        label = "雨花·扶风",
        hover = "是否识别该物品到额外装备栏",
        options = {
            {
                description = "否",
                data = false,
                hover = ""
            },
            {
                description = "是",
                data = true,
                hover = "会丢失原模组套装效果：同时装备雨花·涟漪、雨花·冰魄、雨花·扶风，每秒为玩家额外上涨3点潮湿值。"
            }
        },
        default = false
    },
    { name = "", label = "璇儿-XuanEr", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    {
        name = "MOD_XE_YMYD",
        label = "遗梦芸典",
        hover = "是否识别该物品到额外装备栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "保持该物品在身体栏。"
            },
            {
                description = "是",
                data = true,
                hover = "该物品会装备在服装栏。"
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
            name = "AUTO_SLOTS_HAT",
            label = "Auto-detect headwear",
            hover = "Auto-detect non-armor head items by their attributes",
            options = {
                { description = "No",  data = false, hover = "You installed the mod but won't enable it?" },
                { description = "Yes", data = true,  hover = "Auto-assign unknown mod headwear to the headwear slot." }
            },
            default = false
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
            hover = "Assign this item to an extra equipment slot",
            options = {
                { description = "No",  data = false, hover = "Keep this item in the body slot." },
                { description = "Yes", data = true,  hover = "Equips in the backpack slot. May unbalance gameplay, enable with caution." }
            },
            default = false
        },
        { name = "", label = "Legend and Sea-海洋传说", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_HYCS_YHFF",
            label = "雨花·扶风 (Yuhua Fufeng)",
            hover = "Assign this item to an extra equipment slot",
            options = {
                { description = "No",  data = false, hover = "" },
                { description = "Yes", data = true,  hover = "Loses the original set bonus: equipping Lianyi, Bingpo, and Fufeng together grants +3 wetness per second." }
            },
            default = false
        },
        { name = "", label = "璇儿-XuanEr", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_XE_YMYD",
            label = "遗梦芸典 (Yimeng Yundian)",
            hover = "Assign this item to an extra equipment slot",
            options = {
                { description = "No",  data = false, hover = "Keep this item in the body slot." },
                { description = "Yes", data = true,  hover = "This item will be equipped in the apparel slot." }
            },
            default = true
        }
    }
end
