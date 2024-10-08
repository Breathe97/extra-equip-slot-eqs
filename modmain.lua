local IsServer = GLOBAL.TheNet:GetIsServer()
local DST = GLOBAL.TheSim:GetGameID() == "DST"

local SLOTS_BELLY = GetModConfigData("SLOTS_BELLY")
local SLOTS_NECK = GetModConfigData("SLOTS_NECK")
local SLOTS_BACK = GetModConfigData("SLOTS_BACK")
local AUTO_SLOTS_BELLY = GetModConfigData("AUTO_SLOTS_BELLY")
local AUTO_SLOTS_NECK = GetModConfigData("AUTO_SLOTS_NECK")
local AUTO_SLOTS_BACK = GetModConfigData("AUTO_SLOTS_BACK")
local HOVER_ITEM_CODE = GetModConfigData("HOVER_ITEM_CODE")
local MOD_HYCS_YHFF = GetModConfigData("MOD_HYCS_YHFF")
local MOD_YYZZ_MJTS = GetModConfigData("MOD_YYZZ_MJTS")
local MOD_YYZZ_JSMW = GetModConfigData("MOD_YYZZ_JSMW")
local MOD_YBTX_BELLY = GetModConfigData("MOD_YBTX_BELLY")
local MOD_LJ_ZGF = GetModConfigData("MOD_LJ_ZGF")
local MOD_XE_YMYD = GetModConfigData("MOD_XE_YMYD")

local symbol_belly = require("symbol_belly")             -- 定义服装栏物品
local symbol_neck = require("symbol_neck")               -- 定义护符栏物品
local symbol_back = require("symbol_back")               -- 定义背包栏物品
local force_symbol_body = require("force_symbol_body")   -- 定义强制身体栏物品
local force_symbol_belly = require("force_symbol_belly") -- 定义强制服装栏物品

-- 校准 symbol表 根据设置中生成最终的物品表 后续再根据该表进行装备栏的分配
local function CalibrationSymBol()
    -- 移除特殊设置项的物品识别
    if not MOD_HYCS_YHFF then
        symbol_belly['lg_fufeng'] = nil
    end
    if not MOD_YYZZ_MJTS then
        symbol_belly['to_angel'] = nil
    end
    if not MOD_YYZZ_JSMW then
        symbol_belly['to_satan'] = nil
    end
    if not MOD_XE_YMYD then
        symbol_belly['myxl_dreambook'] = nil
    end
    -- 如果不开启强制服装栏 调整的是 force_symbol_belly 表
    if MOD_YBTX_BELLY == false then
        force_symbol_belly['trunkvest_summer'] = nil
        force_symbol_belly['trunkvest_winter'] = nil
        force_symbol_belly['reflectivevest'] = nil
        force_symbol_belly['hawaiianshirt'] = nil
        force_symbol_belly['raincoat'] = nil
    end
    -- 这里就是取true 调整的是 force_symbol_body 表
    if MOD_LJ_ZGF then
        force_symbol_body['siving_suit_gold'] = nil
    end
end
CalibrationSymBol()

local Inv = GLOBAL.require "widgets/inventorybar"

-- 引用图片资源
Assets = { Asset("IMAGE", "images/equip_slots.tex"), Asset("ATLAS", "images/equip_slots.xml") }

-- 定义装备栏插槽
EQUIPSLOTS_MAP = {
    -- 这三个是系统默认的 不做处理
    -- HANDS = "hands", -- 手持
    -- BODY = "body", -- 身体
    -- HEAD = "head" -- 头部
    BELLY = SLOTS_BELLY and "extra_slots_belly" or nil, -- 身体-扩展-腹部-衣服
    NECK = SLOTS_NECK and "extra_slots_neck" or nil,    -- 身体-扩展-颈部-护符
    BACK = SLOTS_BACK and "extra_slots_back" or nil     -- 身体-扩展-背部-背包
}

-- 申明插槽
for k, v in pairs(EQUIPSLOTS_MAP) do
    if v then
        GLOBAL.EQUIPSLOTS[k] = v
    end
end

-- 初始化插槽数量和位置
local function InitSlot()
    -- 看不懂 大概意思就是说在原来的装备栏后面添加额外的衣服格子、背包格子、护符格子
    local function PostConstruct()
        local Inv_Refresh_base = Inv.Refresh or function()
            return ""
        end
        local Inv_Rebuild_base = Inv.Rebuild or function()
            return ""
        end

        function Inv:RebuildExtraSlots(self)
            -- See `scripts/widgets/inventorybar.lua:212-217`.
            local W = 68        -- 格子宽度
            local SEP = 12      -- 格子间隙
            local INTERSEP = 28 -- 组格子间隙 5个一组

            -- 反正就是计算原始宽度
            local function CalcTotalWidth(num_slots, num_equip, num_buttons)
                local slot_group = math.ceil(num_slots / 5)
                local num_equipintersep = num_buttons > 0 and 1 or 0

                local inventory_w = num_slots * W + (num_slots * SEP) + (slot_group - 1) * (INTERSEP - SEP) -- 物品栏宽度
                local equip_w = num_equip * W + (num_equip - 1) * SEP                                       -- 装备栏宽度
                local buttons_w = num_equipintersep * W                                                     -- 最后的按钮宽度

                local offset_x = inventory_w + equip_w + buttons_w                                          -- 总宽度
                return offset_x
            end

            local num_slots = self.owner.replica.inventory:GetNumSlots()                                         -- 物品栏个数
            local num_equip = #self
                .equipslotinfo                                                                                   -- 装备栏个数
            local do_self_inspect = not (self.controller_build or GLOBAL.GetGameModeProperty("no_avatar_popup")) -- 不知道啥意思

            local scale_default = 1.22                                                                           -- See `scripts/widgets/inventorybar.lua:261-262`. 原始缩放值
            local total_w_default = CalcTotalWidth(num_slots, 3, 1)                                              -- 默认宽度
            local total_w_real = CalcTotalWidth(num_slots, num_equip, do_self_inspect and 1 or 0)                -- 现在的宽度
            local scale_real = scale_default /
                (total_w_default / total_w_real)                                                                 -- 稍微改了下 我有强迫症 我想把 total_w_default 放中间

            -- 添加额外格子
            if self.addextraslots == nil then
                self.addextraslots = 1
                if GLOBAL.EQUIPSLOTS.BELLY ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BELLY, "images/equip_slots.xml", "belly.tex")
                end
                if GLOBAL.EQUIPSLOTS.NECK ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "images/equip_slots.xml", "neck.tex")
                end
                if GLOBAL.EQUIPSLOTS.BACK ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/equip_slots.xml", "back.tex")
                end
            end

            -- 修正贴图
            self.bg:SetScale(scale_real, 1, 1)
            self.bgcover:SetScale(scale_real, 1, 1)

            -- 对融合式背包栏箭头进行调整 -- See `scripts/widgets/inventorybar.lua:313`.
            if GLOBAL.EQUIPSLOTS.BACK ~= nil and num_equip > 3 and self.integrated_arrow then
                local x = self.inv[#self.inv]:GetPosition().x + W * 0.5 + INTERSEP + 61 -- 原始位置
                local offset_x = (W + SEP) * (num_equip - 2)                            -- 偏移值 原始位置就在第二个格子 所以要总格子数减去2
                self.integrated_arrow:SetPosition(x + offset_x, 8)
            end
        end

        function Inv:Rebuild()
            Inv_Rebuild_base(self)
            Inv:RebuildExtraSlots(self)
        end

        function Inv:Refresh()
            Inv_Refresh_base(self)
            Inv:RebuildExtraSlots(self)
        end
    end
    AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", PostConstruct)
end
InitSlot()

-- 初始化物品栏
local function InitPrefab()
    if IsServer then
        -- 如果开启服装栏
        if GLOBAL.EQUIPSLOTS.BELLY then
            -- 初始化服装栏物品
            local function InitBellyPrefab()
                -- 给服装分配插槽
                local function InitBelly(inst)
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY or GLOBAL.EQUIPSLOTS.BODY
                end
                -- 标注服装栏物品
                for k, v in pairs(symbol_belly) do
                    AddPrefabPostInit(k, InitBelly)
                end
            end
            InitBellyPrefab()
        end

        -- 如果开启护符栏
        if GLOBAL.EQUIPSLOTS.NECK then
            -- 初始化护符栏物品
            local function InitNeckPrefab()
                -- 给护符分配插槽
                local function InitNeck(inst)
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK or GLOBAL.EQUIPSLOTS.BODY
                end
                -- 标注护符栏物品
                for k, v in pairs(symbol_neck) do
                    AddPrefabPostInit(k, InitNeck)
                end
            end
            InitNeckPrefab()
        end

        -- 如果开启背包栏
        if GLOBAL.EQUIPSLOTS.BACK then
            -- 初始化背包栏物品
            local function InitBackPrefab()
                -- 装备背包 大概意思就是装备背包时重写人物形象
                local function bagonequip(inst, owner)
                    if DST then
                        local skin_build = inst:GetSkinBuild()    -- 皮肤构造器(用这个api来生成新贴图)
                        local animState = owner.AnimState
                        local old_swap = symbol_back[inst.prefab] -- 当前贴图名称
                        local place_swap = "swap_body_tall"       -- 将要替换的贴图名称(据说只有一个 只能给背包用)
                        local new_swap = "swap_" .. old_swap      -- 新的贴图名称
                        -- 下面是啥意思不知道 就是把变量抽离了一下 看起来只有一行 好看
                        if skin_build ~= nil then
                            owner:PushEvent("equipskinneditem", inst:GetSkinName())
                            animState:OverrideItemSkinSymbol(old_swap, skin_build, old_swap, inst.GUID, new_swap)
                            animState:OverrideItemSkinSymbol(place_swap, skin_build, "swap_body", inst.GUID, new_swap)
                        else
                            animState:OverrideSymbol(place_swap, old_swap, "backpack")
                            animState:OverrideSymbol(place_swap, old_swap, "swap_body")
                        end
                    end
                    if not DST then
                        owner.components.inventory:SetOverflow(nil)
                    end
                    inst.components.container:Open(owner)
                end
                -- 卸载背包 大概意思就是卸载背包时清除之前的形象
                local function bagonunequip(inst, owner)
                    if DST then
                        local skin_build = inst:GetSkinBuild()
                        if skin_build ~= nil then
                            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
                        end
                    end
                    owner.AnimState:ClearOverrideSymbol("swap_body_tall")
                    owner.AnimState:ClearOverrideSymbol("backpack")
                    if not DST then
                        owner.components.inventory:SetOverflow(inst)
                    end
                    inst.components.container:Close(owner)
                end
                -- 给背包分配插槽
                local function InitBack(inst)
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BODY
                    -- 监听背包装备卸下事件
                    if DST then
                        inst.components.equippable:SetOnEquip(bagonequip)
                        inst.components.equippable:SetOnUnequip(bagonunequip)
                    end
                end

                -- 标注背包栏物品
                for k, v in pairs(symbol_back) do
                    AddPrefabPostInit(k, InitBack)
                end
            end
            InitBackPrefab()
        end

        -- 为其他物品智能分配插槽
        AddPrefabPostInitAny(function(inst)
            if not (GLOBAL.TheWorld.ismastersim and inst.components.equippable ~= nil) then
                return
            end

            local prefab = inst.prefab -- 物品名称

            -- 一些模组物品会被误以为是额外的装备 但是它实际上应该在服装栏
            local is_force_symbol_belly = force_symbol_belly[prefab] -- 是否属于强制服装物品
            if is_force_symbol_belly then
                inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY or
                    GLOBAL.EQUIPSLOTS
                    .BODY -- 优先分配到服装栏 如果没有开启服装栏就分配到身体栏
                return
            end

            -- 一些模组物品会被误以为是额外的装备 但是它实际上应该在身体栏
            local is_force_symbol_body = force_symbol_body[prefab] -- 是否属于强制身体物品
            if is_force_symbol_body then
                inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BODY
                return
            end

            -- 如果已经进行了适配的物品也不进行智能适配
            local is_adaptation = symbol_belly[prefab] or symbol_neck[prefab] or symbol_back[prefab] or
                force_symbol_body[prefab] or force_symbol_belly[prefab]
            if is_force_symbol_body then
                return
            end

            -- 只要不属于身体的物品就不往下走
            local equipslot = inst.components.equippable.equipslot or nil
            if equipslot == nil or equipslot ~= "body" then
                return
            end

            -- 护甲类优先不进行调整
            local is_armor = string.find(prefab, "armor") -- 是否为护甲
            -- 如果是护甲则不进行分配
            if is_armor ~= nil then
                return
            end

            -- 自动分配服装栏
            if GLOBAL.EQUIPSLOTS.BELLY and AUTO_SLOTS_BELLY then
                -- 自动匹配腹部上的物品 暂时不支持
                local function AutoMatchBelly()
                    local is_clothing = string.find(prefab, "clothing") -- 是否为服装
                    if is_clothing then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY
                    end
                end
                AutoMatchBelly()
            end

            -- 自动分配护符栏
            if GLOBAL.EQUIPSLOTS.NECK and AUTO_SLOTS_NECK then
                -- 自动匹配脖子上的物品
                local function AutoMatchNeck()
                    local is_amulet = string.find(prefab, "amulet") -- 是否为护符
                    if is_amulet then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK
                    end
                end
                AutoMatchNeck()
            end

            -- 自动分配背包栏
            if GLOBAL.EQUIPSLOTS.BACK and AUTO_SLOTS_BACK then
                -- 自动匹配背上的物品
                local function AutoMatchBack()
                    local is_back = string.find(prefab, "back") -- 是否为背上物品
                    if is_back then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK
                    end
                end
                AutoMatchBack()
            end
        end)
    end
end
InitPrefab()

-- 因为部分物品调整装备栏带来的修复
local function RepairExtra()
    -- 看不懂 大概意思就是 声明怎么获取当前人物的物品以及数量、后期怎么堆叠什么的
    -- 这里参考了该作者的源码 https://steamcommunity.com/sharedfiles/filedetails/?id=1819567085 解决了物品放置的问题
    local function PrefabPostInit(inst)
        local function GetOverflowContainer(inst)
            if inst.ignoreoverflow then
                return
            end

            local backitem = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BACK)
            local bodyitem = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BODY)
            local headitem = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.HEAD)
            local bellyitem = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BELLY)

            if backitem ~= nil and backitem.replica and backitem.replica.container and backitem.replica.container._isopen then
                return backitem.replica.container
            elseif bodyitem ~= nil and bodyitem.replica and bodyitem.replica.container and bodyitem.replica.container._isopen then
                return bodyitem.replica.container
            elseif headitem ~= nil and headitem.replica and headitem.replica.container and headitem.replica.container._isopen then
                return headitem.replica.container
            elseif bellyitem ~= nil and bellyitem.replica and bellyitem.replica.container and bellyitem.replica.container._isopen then
                return bellyitem.replica.container
            end
        end

        -- 定义相关的方法然后遍历修改
        local funclist = {
            "Has",
            "UseItemFromInvTile",
            "ControllerUseItemOnItemFromInvTile",
            "ControllerUseItemOnSelfFromInvTile",
            "ControllerUseItemOnSceneFromInvTile",
            "ReceiveItem",
            "RemoveIngredients"
        }

        -- 修改指定的方法中的GetOverflowContainer
        local function setval(fn, path, new)
            local val = fn
            local prev = nil
            local i
            for entry in path:gmatch("[^%.]+") do
                i = 1
                prev = val
                while true do
                    local name, value = GLOBAL.debug.getupvalue(val, i)
                    if name == entry then
                        val = value
                        break
                    elseif name == nil then
                        return
                    end
                    i = i + 1
                end
            end
            GLOBAL.debug.setupvalue(prev, i, new)
        end
        for _, v in ipairs(funclist) do
            if inst[v] and type(inst[v]) == "function" then
                setval(inst[v], "GetOverflowContainer", GetOverflowContainer)
            end
        end

        if not IsServer and not GLOBAL.TheWorld.ismastersim then
            inst.GetOverflowContainer = GetOverflowContainer
        end
    end
    AddPrefabPostInit("inventory_classified", PrefabPostInit)

    -- 开启护符栏后的修复
    if GLOBAL.EQUIPSLOTS.NECK then
        -- 绿护符在制作栏中显示-20%
        local Inv = GLOBAL.require "widgets/redux/craftingmenu_ingredients"
        local SetRecipe_base = Inv.SetRecipe

        Inv.SetRecipe = function(self, ...)
            local inventory = self.owner.replica.inventory
            local GetEquippedItem_Orig = inventory.GetEquippedItem
            inventory.GetEquippedItem = function(inst)
                return GetEquippedItem_Orig(inst, GLOBAL.EQUIPSLOTS.NECK)
            end
            SetRecipe_base(self, ...)
            inventory.GetEquippedItem = GetEquippedItem_Orig
        end

        -- 红护符复活
        AddStategraphPostInit("wilson", function(self)
            local original_amulet_rebirth = self.states["amulet_rebirth"]
            local original_amulet_rebirth_onexit = original_amulet_rebirth.onexit
            original_amulet_rebirth.onexit = function(inst)
                local item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
                if item and item.prefab == "amulet" then
                    item = inst.components.inventory:RemoveItem(item)
                    if item then
                        item:Remove()
                        item.persists = false
                    end
                end
                original_amulet_rebirth_onexit(inst)
            end
        end)
    end

    -- 开启背包栏后的修复
    if GLOBAL.EQUIPSLOTS.BACK then
        -- 对人物物品变化添加额外的事件
        AddComponentPostInit("inventory", function(self, inst)
            local original_Equip = self.Equip
            -- 这个是装备背包的方法
            self.Equip = function(self, item, old_to_active)
                if original_Equip(self, item, old_to_active) and item and item.components and item.components.equippable then
                    local eslot = item.components.equippable.equipslot
                    if self.equipslots[eslot] ~= item then
                        if eslot == GLOBAL.EQUIPSLOTS.BACK and item.components.container ~= nil then
                            self.inst:PushEvent("setoverflow", { overflow = item })
                        end
                    end
                    return true
                else
                    return
                end
            end
            -- 监听背包卸载
            self.inst:ListenForEvent(
                "unequip",
                function(inst, data)
                    local inventory = DST and inst.replica.inventory or inst.components.inventory
                    if inventory ~= nil then
                        local equipment = inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
                        if equipment and equipment.components.equippable.onequipfn then
                            if equipment.task ~= nil then
                                equipment.task:Cancel()
                                equipment.task = nil
                            end
                            equipment.components.equippable.onequipfn(equipment, inst)
                        end
                    end
                end
            )

            -- 调整物品叠加到背包时的逻辑
            self.GetOverflowContainer = function()
                if self.ignoreoverflow then
                    return
                end

                local function isOpencontainers(doer, inst)
                    return doer.components.inventory.opencontainers[inst]
                end

                local backitem = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
                local bodyitem = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)

                if backitem ~= nil and backitem.components.container and isOpencontainers(self.inst, backitem) then
                    return backitem.components.container
                elseif bodyitem ~= nil and bodyitem.components.container and isOpencontainers(self.inst, bodyitem) then
                    return bodyitem.components.container
                end
            end
        end)
    end

    -- 参考于 2950481491
    if GLOBAL.EQUIPSLOTS.BELLY then
        -- 5. 当你给“寄居蟹隐士”一件外套时，她会尝试使用旧的装备槽。让我们也用新的.
        -- See `scripts/prefabs/hermitcrab.lua`.
        AddPrefabPostInit("hermitcrab", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            local function iscoat(item)
                return item.components.insulator and
                    item.components.insulator:GetInsulation() >= GLOBAL.TUNING.INSULATION_SMALL and
                    item.components.insulator:GetType() == GLOBAL.SEASONS.WINTER and
                    item.components.equippable and
                    item.components.equippable.equipslot == EQUIPSLOTS_MAP.BELLY
            end

            local function getcoat(inst1)
                local equipped = inst1.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.BELLY)
                return inst1.components.inventory:FindItem(function(testitem) return iscoat(testitem) end)
                    or (equipped and iscoat(equipped) and equipped)
            end

            -- 添加一个额外的项目监听器.
            -- See `scripts/prefabs/hermitcrab.lua:1011`.
            inst:ListenForEvent("itemget", function(_, data)
                if iscoat(data.item) and GLOBAL.TheWorld.state.issnowing then
                    local TASKS_GIVE_PUFFY_VEST = 11 -- Copy from `prefabs/hermitcrab.lua:57`.
                    inst.components.inventory:Equip(data.item)
                    inst.components.friendlevels:CompleteTask(TASKS_GIVE_PUFFY_VEST)
                end
            end)

            -- 覆盖 `ShouldAcceptItem`.
            -- See `scripts/prefabs/hermitcrab.lua:122-123,127`.
            local ShouldAcceptItem_Base = inst.components.trader.test
            inst.components.trader:SetAcceptTest(function(inst1, item)
                return (iscoat(item) and GLOBAL.TheWorld.state.issnowing and not getcoat(inst1))
                    or ShouldAcceptItem_Base(inst1, item)
            end)

            -- 覆盖 `OnRefuseItem`.
            -- See `scripts/prefabs/hermitcrab.lua:144-146`.
            local OnRefuseItem_Base = inst.components.trader.onrefuse
            inst.components.trader.onrefuse = function(inst1, giver, item)
                if iscoat(item) then
                    if getcoat(inst1) then
                        inst1.components.npc_talker:Say(GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT_HASONE
                            [math.random(#GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT_HASONE)])
                    elseif not GLOBAL.TheWorld.state.issnowing then
                        inst1.components.npc_talker:Say(GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT
                            [math.random(#GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT)])
                    end
                end
                OnRefuseItem_Base(inst, giver, item)
            end

            -- 覆盖 `iscoat`.
            -- See `scripts/prefabs/hermitcrab.lua:1363`.
            inst.iscoat = iscoat
            inst.getcoat = getcoat
        end)


        -- 6. “寄居蟹隐士”有一个大脑，可以让她在旧装备槽中装备/取消装备外套。让我们也用新的.
        -- See `scripts/brains/hermitcrabbrain.lua`.
        AddBrainPostInit("hermitcrabbrain", function(brain)
            local function using_coat(inst)
                local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.BELLY)
                return equipped and inst.iscoat(equipped) or nil
            end

            local function has_coat(inst)
                return inst.components.inventory:FindItem(function(testitem) return inst.iscoat(testitem) end)
            end

            local function EquipCoat(inst)
                local coat = inst.getcoat(inst)
                if coat then
                    inst.components.inventory:Equip(coat)
                end
            end

            local function UnequipCoat(inst)
                local item = inst.components.inventory:Unequip(EQUIPSLOTS_MAP.BELLY)
                inst.components.inventory:GiveItem(item)
            end

            local new_children = {}
            for _, child in ipairs(brain.bt.root.children) do
                if child.name == "Sequence" and child.children[1].name == "coat" then
                    table.insert(new_children,
                        GLOBAL.IfNode(
                            function()
                                return not brain.inst.sg:HasStateTag("busy") and GLOBAL.TheWorld.state.issnowing and
                                    has_coat(brain.inst) and not using_coat(brain.inst)
                            end,
                            "coat",
                            GLOBAL.DoAction(brain.inst, EquipCoat, "coat", true))
                    )
                elseif child.name == "Sequence" and child.children[1].name == "stop coat" then
                    table.insert(new_children,
                        GLOBAL.IfNode(
                            function()
                                return not brain.inst.sg:HasStateTag("busy") and
                                    not GLOBAL.TheWorld.state.issnowing and using_coat(brain.inst)
                            end,
                            "stop coat",
                            GLOBAL.DoAction(brain.inst, UnequipCoat, "stop coat", true))
                    )
                else
                    table.insert(new_children, child)
                end
            end
            brain.bt = GLOBAL.BT(brain.inst, GLOBAL.PriorityNode(new_children, 0.5))
        end)
    end
end
RepairExtra()

-- 鼠标显示物品代码
local function HoverItemCode()
    GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

    local function GetBuild(inst)
        local strnn = ""
        local str = inst.entity:GetDebugString()

        if not str then
            return nil
        end
        local bank, build, anim = str:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")

        if bank ~= nil and build ~= nil then
            strnn = strnn .. "动画: anim/" .. bank .. ".zip"
            strnn = strnn .. "\n" .. "贴图: anim/" .. build .. ".zip"
        end
        return strnn
    end

    AddClassPostConstruct("widgets/hoverer", function(self)
        local old_SetString = self.text.SetString
        self.text.SetString = function(text, str)
            local target = TheInput:GetHUDEntityUnderMouse()
            if target ~= nil then
                target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
            else
                target = TheInput:GetWorldEntityUnderMouse()
            end
            if target and target.entity ~= nil then
                if target.prefab ~= nil then
                    str = str .. "\n" .. "代码: " .. target.prefab
                end
                local build = GetBuild(target)
                if build ~= nil then
                    str = str .. "\n" .. build
                end
            end
            return old_SetString(text, str)
        end
    end)
end

if HOVER_ITEM_CODE then
    HoverItemCode()
end
