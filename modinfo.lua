

name = "额外的装备栏" -- mod的名字

description =
    [[
󰀜 为人物添加额外的服装栏、护符栏、背包栏。
󰀜 默认：武器 + 护甲 + 头盔 + 服装 + 护符 + 背包。
󰀜 大理石占据护甲而不是背包。
󰀜 已适配部分模组物品，没有适配的物品会优先智能分配。
󰀜 其他模组的适配可以留言（物品的英文+中文+模组的名称）。

󰀏 近期更新：
1.3.5：优化代码逻辑。
1.3.3：兼容鸢一折纸-校服。
1.3.2：修复关闭背包时物品不能快捷移动的问题兼容衣服、帽子多储存格子。
1.2.8：兼容服装栏物品：海洋传说-雨花·扶风 狂三-校服。

󰀀 图标也抄过来了 嘻嘻。
                    󰀜󰀝󰀀󰀞󰀘󰀁󰀟󰀠󰀡󰀂󰀪󰀕󰀫󰀖󰀛󰀬󰀭󰀮󰀰󰀉󰀚󰀊󰀋󰀌󰀍
                    󰀃󰀄󰀢󰀅󰀣󰀆󰀇󰀈󰀤󰀙󰀦󰀐󰀑󰀒󰀧󰀱󰀎󰀏󰀗󰀯󰀔󰀩󰀨󰀓󰀥
]]

priority = -1 -- 优先级 默认0

author = "Breathe" -- mod的作者

version = "1.3.5" -- mod的版本号

api_version = 10 -- API版本号

forumthread = "" -- 留空就行了

dst_compatible = true -- 兼容联机
dont_starve_compatible = false -- 兼容单机
reign_of_giants_compatible = false -- 兼容巨人

all_clients_require_mod = true -- 客户端mod就false,服务端就true。

-- 为mod指定自定义图标!
icon_atlas = "preview.xml"
icon = "preview.tex"

server_filter_tags = {"refresh", "Krampus", "private"} -- 服务器标签可以不写

configuration_options = {
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
    }
}
