name = "额外的装备栏" -- mod的名字

description =
[[
󰀜 为人物添加额外的服装栏、护符栏、背包栏。
󰀜 默认：武器 + 护甲 + 头盔 + 服装 + 护符 + 背包。
󰀜 大理石占据护甲而不是背包。
󰀜 已适配部分模组物品，没有适配的物品会优先智能分配。
󰀜 其他模组的适配可以留言（物品的英文+中文+模组的名称）。

󰀏 近期更新：
1.6.2：增加更多模组物品装备。
1.6.1：增加配置菜单英文支持。
1.6.0：移除 穹の护 为服装栏，并新增其他强制服装栏物品。
1.5.9：调整加载优先级以适配其他同类互斥模组。

󰀀 图标也抄过来了 嘻嘻。
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
]]

priority = 1                       -- 优先级 默认0 值越大 优先级越低

author = "Breathe"                 -- mod的作者

version = "1.6.2"                  -- mod的版本号

api_version = 10                   -- API版本号

forumthread = ""                   -- 留空就行了

dst_compatible = true              -- 兼容联机
dont_starve_compatible = false     -- 兼容单机
reign_of_giants_compatible = false -- 兼容巨人

all_clients_require_mod = true     -- 客户端mod就false,服务端就true。

-- 为mod指定自定义图标!
icon_atlas = "preview.xml"
icon = "preview.tex"

server_filter_tags = { "refresh", "Krampus", "private" } -- 服务器标签可以不写


configuration_options = {
    { name = "", label = "基本配置", hover = "", options = { { description = "", data = 0 } }, default = 0 },
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
        default = true
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
                hover = "衣服目前没有一个比较好的适配办法，所以暂时不支持。"
            },
            -- {
            --     description = "是",
            --     data = true,
            --     hover = "自动识别未知的模组物品并分配至服装栏。"
            -- }
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

    { name = "", label = "其他配置 (推荐默认)", hover = "", options = { { description = "", data = 0 } }, default = 0 },
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
    { name = "", label = "Uncompromising-永不妥协", hover = "", options = { { description = "", data = 0 } }, default = 0 },
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
    { name = "", label = "海洋传说-Legend and sea", hover = "", options = { { description = "", data = 0 } }, default = 0 },
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
    },
    { name = "", label = "鸢一折纸-Tobiichi Origami", hover = "", options = { { description = "", data = 0 } }, default = 0 },
    {
        name = "MOD_YYZZ_MJTS",
        label = "绝灭天使",
        hover = "是否识别该物品到额外装备栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "有兼容问题暂不支持开启。"
            }
        },
        default = false
    },
    {
        name = "MOD_YYZZ_JSMW",
        label = "救世魔王",
        hover = "是否识别该物品到额外装备栏",
        options = {
            {
                description = "否",
                data = false,
                hover = "有兼容问题暂不支持开启。"
            }
        },
        default = false
    }
}


local isZh = locale == "zh" or locale == "zhr"

-- 非中文
if not isZh then
    configuration_options = {
        { name = "", label = "Basic configuration",                        hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "SLOTS_BELLY",
            label = "Clothing section",
            hover = "Do you want to expand the clothing section",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "It's all down, are you sure you don't want to open it?"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "An additional clothing column will be added."
                }
            },
            default = true
        },
        {
            name = "SLOTS_NECK",
            label = "Talisman fence",
            hover = "Do you want to expand the talisman bar",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "It's all down, are you sure you don't want to open it?"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "An additional talisman bar will be added."
                }
            },
            default = true
        },
        {
            name = "SLOTS_BACK",
            label = "Backpack bar",
            hover = "Do you want to expand the backpack compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "It's all down, are you sure you don't want to open it?"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "An additional backpack compartment will be added."
                }
            },
            default = true
        },
        {
            name = "AUTO_SLOTS_BELLY",
            label = "Automatically identify items in the clothing column",
            hover = "Automatically identify whether an item belongs to the clothing category by its name",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "There is currently no good fitting method for clothes, so it is not supported temporarily."
                },
                -- {
                --     description = "Yes",
                --     data = true,
                --     hover = "Automatically identify unknown module items and assign them to the clothing column."
                -- }
            },
            default = false
        },
        {
            name = "AUTO_SLOTS_NECK",
            label = "Automatically identify items in the talisman bar",
            hover = "Automatically identify whether an item belongs to the talisman category by its name",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "It's all down, are you sure you don't want to open it?"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "Automatically identify unknown module items and assign them to the talisman bar."
                }
            },
            default = true
        },
        {
            name = "AUTO_SLOTS_BACK",
            label = "Automatically identify backpack items",
            hover = "Automatically identify whether an item belongs to the backpack category by its name",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "It's all down, are you sure you don't want to open it?"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "Automatically identify unknown module items and assign them to the backpack compartment."
                }
            },
            default = true
        },

        { name = "", label = "Other configurations (recommended default)", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "HOVER_ITEM_CODE",
            label = "Item information",
            hover =
            "After opening, pointing the mouse at the item in the game can view the code information of the item.",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "Code information for closing items"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "Display the code information of the item"
                }
            },
            default = false
        },
        { name = "", label = "Uncompromising-永不妥协", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_YBTX_BELLY",
            label = "Mandatory clothing column",
            hover =
            "Forcefully identify breathable vests, soft vests, cool summer clothes, floral shirts, and raincoats in the clothing column",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "Maintain automatic allocation"
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "Mandatory equipment in the clothing store."
                }
            },
            default = true
        },
        { name = "", label = "Legion-棱镜", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_LJ_ZGF",
            label = "Zigui · Pot",
            hover = "Do you recognize the item in the additional equipment compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "Keep the item in the body compartment."
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "该物品会装备在背包栏，有失平衡，谨慎开启。"
                }
            },
            default = false
        },
        { name = "", label = "海洋传说-Legend and sea", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_HYCS_YHFF",
            label = "雨花·扶风",
            hover = "Do you recognize the item in the additional equipment compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = ""
                },
                {
                    description = "Yes",
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
            hover = "Do you recognize the item in the additional equipment compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "Keep the item in the body compartment."
                },
                {
                    description = "Yes",
                    data = true,
                    hover = "This item will be equipped in the clothing section."
                }
            },
            default = true
        },
        { name = "", label = "鸢一折纸-Tobiichi Origami", hover = "", options = { { description = "", data = 0 } }, default = 0 },
        {
            name = "MOD_YYZZ_MJTS",
            label = "Extinguishing Angel",
            hover = "Do you recognize the item in the additional equipment compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "There is a compatibility issue and it is currently not supported to enable."
                }
            },
            default = false
        },
        {
            name = "MOD_YYZZ_JSMW",
            label = "Salvation Demon King",
            hover = "Do you recognize the item in the additional equipment compartment",
            options = {
                {
                    description = "No",
                    data = false,
                    hover = "There is a compatibility issue and it is currently not supported to enable."
                }
            },
            default = false
        }
    }
end
