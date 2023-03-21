local IsServer = GLOBAL.TheNet:GetIsServer()
local DST = GLOBAL.TheSim:GetGameID() == "DST"

local SLOTS_BELLY = GetModConfigData("SLOTS_BELLY")
local SLOTS_NECK = GetModConfigData("SLOTS_NECK")
local SLOTS_BACK = GetModConfigData("SLOTS_BACK")
local AUTO_SLOTS_BELLY = GetModConfigData("AUTO_SLOTS_BELLY")
local AUTO_SLOTS_NECK = GetModConfigData("AUTO_SLOTS_NECK")
local AUTO_SLOTS_BACK = GetModConfigData("AUTO_SLOTS_BACK")

local symbol_belly = require("symbol_belly") -- 定义服装栏物品
local symbol_neck = require("symbol_neck") -- 定义护符栏物品
local symbol_back = require("symbol_back") -- 定义背包栏物品

-- 引用图片资源
Assets = {Asset("IMAGE", "images/equip_slots.tex"), Asset("ATLAS", "images/equip_slots.xml")}

-- 定义装备栏插槽
EQUIPSLOTS_MAP = {
    -- HANDS = "hands", -- 手持
    -- BODY = "body", -- 身体
    -- HEAD = "head" -- 头部
    BELLY = SLOTS_BELLY and "extra_slots_belly" or nil, -- 身体-扩展-腹部-衣服
    NECK = SLOTS_NECK and "extra_slots_neck" or nil, -- 身体-扩展-颈部-护符
    BACK = SLOTS_BACK and "extra_slots_back" or nil -- 身体-扩展-背部-背包
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
    AddGlobalClassPostConstruct(
        "widgets/inventorybar",
        "Inv",
        function()
            local Inv = GLOBAL.require "widgets/inventorybar"
            local Inv_Refresh_base = Inv.Refresh or function()
                    return ""
                end
            local Inv_Rebuild_base = Inv.Rebuild or function()
                    return ""
                end

            function Inv:LoadExtraSlots(self)
                -- 反正就是计算原始宽度 这段抄的社区 id:2324689937的 我的确不会写 只好说声谢谢了
                local function CalcTotalWidth(num_slots, num_equip, num_buttons)
                    -- See `scripts/widgets/inventorybar.lua:212-217`.
                    local W = 68
                    local SEP = 12
                    local INTERSEP = 28
                    local num_slotintersep = math.ceil(num_slots / 5)
                    local num_equipintersep = num_buttons > 0 and 1 or 0
                    return (num_slots + num_equip + num_buttons) * W +
                        (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP +
                        (num_slotintersep + num_equipintersep) * INTERSEP
                end

                local num_slots = self.owner.replica.inventory:GetNumSlots() -- 物品栏个数
                local num_equip = #self.equipslotinfo -- 装备栏个数
                local do_self_inspect = not (self.controller_build or GLOBAL.GetGameModeProperty("no_avatar_popup")) -- 不知道啥意思

                local scale_default = 1.22 -- See `scripts/widgets/inventorybar.lua:261-262`. 原始缩放值
                local total_w_default = CalcTotalWidth(num_slots, 3, 1) -- 默认宽度
                local total_w_real = CalcTotalWidth(num_slots, num_equip, do_self_inspect and 1 or 0) -- 现在的宽度

                local scale_real = scale_default / (total_w_default / total_w_real) -- 稍微改了下 我有强迫症 我想把 total_w_default 放中间
                self.bg:SetScale(scale_real, 1, 1)
                self.bgcover:SetScale(scale_real, 1, 1)

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
                -- 暂未成功 对融合式背包栏箭头进行调整 -- See `scripts/widgets/inventorybar.lua:313`.
                -- local inventory = self.owner.replica.inventory
                -- local overflow = inventory:GetOverflowContainer()
                -- overflow = (overflow ~= nil and overflow:IsOpenedBy(self.owner)) and overflow or nil
                -- local do_integrated_backpack = overflow ~= nil and self.integrated_backpack
                -- print("do_integrated_backpack", do_integrated_backpack)
                -- if do_integrated_backpack then
                --     local W = 68 * 3
                --     local SEP = 12
                --     local INTERSEP = 28
                --     local x = self.inv[#self.inv]:GetPosition().x + W * 0.5 + INTERSEP + 61 + 30
                --     self.integrated_arrow:SetPosition(x, 8)
                -- end
                end
            end

            function Inv:Refresh()
                Inv_Refresh_base(self)
                Inv:LoadExtraSlots(self)
            end

            function Inv:Rebuild()
                Inv_Rebuild_base(self)
                Inv:LoadExtraSlots(self)
            end
        end
    )

    -- 看不懂 大概意思就是说进入游戏后先获取原来人物的物品 比如你本来是6格 会把多余的物品给你卸下来
    AddPrefabPostInit(
        "inventory_classified",
        function(inst)
            function GetOverflowContainer(inst)
                local item = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BACK)
                return item ~= nil and item.replica.container or nil
            end

            function Count(item)
                return item.replica.stackable ~= nil and item.replica.stackable:StackSize() or 1
            end

            function Has(inst, prefab, amount)
                local count =
                    inst._activeitem ~= nil and inst._activeitem.prefab == prefab and Count(inst._activeitem) or 0

                if inst._itemspreview ~= nil then
                    for i, v in ipairs(inst._items) do
                        local item = inst._itemspreview[i]
                        if item ~= nil and item.prefab == prefab then
                            count = count + Count(item)
                        end
                    end
                else
                    for i, v in ipairs(inst._items) do
                        local item = v:value()
                        if item ~= nil and item ~= inst._activeitem and item.prefab == prefab then
                            count = count + Count(item)
                        end
                    end
                end

                local overflow = GetOverflowContainer(inst)
                if overflow ~= nil then
                    local overflowhas, overflowcount = overflow:Has(prefab, amount)
                    count = count + overflowcount
                end

                return count >= amount, count
            end

            if not IsServer then
                inst.GetOverflowContainer = GetOverflowContainer
                inst.Has = Has
            end
        end
    )

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
        -- AddStategraphPostInit(
        --     "wilson",
        --     function(self)
        --         local amulet_rebirth_state = self.states["amulet_rebirth"]
        --         amulet_rebirth_state.onenter = function()

        --         end
        --     end
        -- )
    end

    -- 开启背包栏后的修复
    if GLOBAL.EQUIPSLOTS.BACK then
        -- 看不懂 大概意思修复捡东西进背包
        AddComponentPostInit(
            "inventory",
            function(self, inst)
                local original_Equip = self.Equip
                self.Equip = function(self, item, old_to_active)
                    if
                        original_Equip(self, item, old_to_active) and item and item.components and
                            item.components.equippable
                     then
                        local eslot = item.components.equippable.equipslot
                        if self.equipslots[eslot] ~= item then
                            if eslot == GLOBAL.EQUIPSLOTS.BACK and item.components.container ~= nil then
                                self.inst:PushEvent("setoverflow", {overflow = item})
                            end
                        end
                        return true
                    else
                        return
                    end
                end

                self.GetOverflowContainer = function()
                    if self.ignoreoverflow then
                        return
                    end
                    local item = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
                    return item ~= nil and item.components.container or nil
                end
            end
        )
    end
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
                        local skin_build = inst:GetSkinBuild() -- 皮肤构造器(用这个api来生成新贴图)
                        local toAnim = owner.AnimState
                        local old_swap = symbol_back[inst.prefab] -- 当前贴图名称
                        local place_swap = "swap_body_tall" -- 将要替换的贴图名称(据说只有一个 只能给背包用)
                        local new_swap = "swap_" .. old_swap -- 新的贴图名称
                        -- 下面是啥意思不知道 就是把变量抽离了一下 看起来只有一行 好看
                        if skin_build ~= nil then
                            owner:PushEvent("equipskinneditem", inst:GetSkinName())
                            toAnim:OverrideItemSkinSymbol(old_swap, skin_build, old_swap, inst.GUID, new_swap)
                            toAnim:OverrideItemSkinSymbol(place_swap, skin_build, "swap_body", inst.GUID, new_swap)
                        else
                            toAnim:OverrideSymbol(place_swap, old_swap, "backpack")
                            toAnim:OverrideSymbol(place_swap, old_swap, "swap_body")
                        end
                    end
                    if not DST then
                        owner.components.inventory:SetOverflow(nil)
                    end
                    inst.components.container:Open(owner)
                end
                -- 卸载背包 大概意思就是卸载背包时清楚之前的形象
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
                    -- 重写背包事件
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
        AddPrefabPostInitAny(
            function(inst)
                if not (GLOBAL.TheWorld.ismastersim and inst.components.equippable ~= nil) then
                    return
                end

                -- 除身体部分物品外 其余的物品不判断
                local equipslot = inst.components.equippable.equipslot or nil
                if equipslot == nil or equipslot ~= "body" then
                end

                local prefab = inst.prefab -- 物品名称

                -- 护甲类优先不进行调整
                local is_armor = string.find(prefab, "armor") -- 是否为护甲
                -- 如果是护甲则不进行分配
                if is_armor ~= nil then
                    return
                end

                -- 自动分配服装栏
                if GLOBAL.EQUIPSLOTS.BELLY and AUTO_SLOTS_BELLY then
                -- 自动匹配腹部上的物品 暂时不支持
                -- local function AutoMatchBelly()
                --     local is_amulet = string.find(prefab, "amulet") -- 是否为护符
                --     if is_amulet then
                --         inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY
                --     end
                -- end
                -- AutoMatchBelly()
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
            end
        )
    end
end
InitPrefab()
