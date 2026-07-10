local IsServer = GLOBAL.TheNet:GetIsServer()

local SLOTS_BELLY = GetModConfigData("SLOTS_BELLY")
local SLOTS_NECK = GetModConfigData("SLOTS_NECK")
local SLOTS_BACK = GetModConfigData("SLOTS_BACK")
local SLOTS_WAIST = GetModConfigData("SLOTS_WAIST")

local AUTO_SLOTS_BELLY = GetModConfigData("AUTO_SLOTS_BELLY")
local AUTO_SLOTS_NECK = GetModConfigData("AUTO_SLOTS_NECK")
local AUTO_SLOTS_BACK = GetModConfigData("AUTO_SLOTS_BACK")

local HOVER_ITEM_CODE = GetModConfigData("HOVER_ITEM_CODE")
local MOD_HYCS_YHFF = GetModConfigData("MOD_HYCS_YHFF")
local MOD_YBTX_BELLY = GetModConfigData("MOD_YBTX_BELLY")
local MOD_LJ_ZGF = GetModConfigData("MOD_LJ_ZGF")
local MOD_XE_YMYD = GetModConfigData("MOD_XE_YMYD")

local SYMBOL_BELLY = require("symbol_belly")             -- 定义服装栏物品
local SYMBOL_NECK = require("symbol_neck")               -- 定义护符栏物品
local SYMBOL_BACK = require("symbol_back")               -- 定义背包栏物品
local SYMBOL_WAIST = require("symbol_waist")             -- 定义腰包栏物品

local FORCE_SYMBOL_BODY = require("force_symbol_body")   -- 定义强制身体栏物品
local FORCE_SYMBOL_BELLY = require("force_symbol_belly") -- 定义强制服装栏物品

-- 校准 symbol表 根据设置中生成最终的物品表 后续再根据该表进行装备栏的分配
local function CalibrationSymBol()
    -- 移除特殊设置项的物品识别
    if not MOD_HYCS_YHFF then
        SYMBOL_BELLY['lg_fufeng'] = nil
    end
    if not MOD_XE_YMYD then
        SYMBOL_BELLY['myxl_dreambook'] = nil
    end
    -- 如果不开启强制服装栏 清空 FORCE_SYMBOL_BELLY 表
    if MOD_YBTX_BELLY == false then
        FORCE_SYMBOL_BELLY['trunkvest_summer'] = nil
        FORCE_SYMBOL_BELLY['trunkvest_winter'] = nil
        FORCE_SYMBOL_BELLY['reflectivevest'] = nil
        FORCE_SYMBOL_BELLY['hawaiianshirt'] = nil
        FORCE_SYMBOL_BELLY['raincoat'] = nil
    end
    -- 这里就是取true 调整的是 FORCE_SYMBOL_BODY 表
    if MOD_LJ_ZGF then
        FORCE_SYMBOL_BODY['siving_suit_gold'] = nil
    end
end
CalibrationSymBol()

local Inv = GLOBAL.require "widgets/inventorybar"

-- 引用图片资源
Assets = {
    Asset("IMAGE", "assets/equip_slot_belly/equip_slot_belly.tex"), -- 服装栏图标
    Asset("ATLAS", "assets/equip_slot_belly/equip_slot_belly.xml"), -- 服装栏atlas
    Asset("IMAGE", "assets/equip_slot_neck/equip_slot_neck.tex"),   -- 护符栏图标
    Asset("ATLAS", "assets/equip_slot_neck/equip_slot_neck.xml"),   -- 护符栏atlas
    Asset("IMAGE", "assets/equip_slot_back/equip_slot_back.tex"),   -- 背包栏图标
    Asset("ATLAS", "assets/equip_slot_back/equip_slot_back.xml"),   -- 背包栏atlas
    Asset("IMAGE", "assets/equip_slot_waist/equip_slot_waist.tex"), -- 腰包栏图标
    Asset("ATLAS", "assets/equip_slot_waist/equip_slot_waist.xml")  -- 腰包栏atlas
}

-- 定义装备栏插槽
EQUIPSLOTS_MAP = {
    -- 这三个是系统默认的 不做处理
    -- HANDS = "hands", -- 手持
    -- BODY = "body", -- 身体
    -- HEAD = "head" -- 头部
    BELLY = SLOTS_BELLY and "extra_slots_belly" or nil, -- 身体-扩展-腹部-衣服
    NECK = SLOTS_NECK and "extra_slots_neck" or nil,    -- 身体-扩展-颈部-护符
    BACK = SLOTS_BACK and "extra_slots_back" or nil,    -- 身体-扩展-背部-背包
    WAIST = SLOTS_WAIST and "extra_slots_waist" or nil  -- 身体-扩展-腰部-腰包
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
        local Inv_Refresh_base = Inv.Refresh or nil
        local Inv_Rebuild_base = Inv.Rebuild or nil

        function Inv:RebuildExtraSlots()
            -- See `scripts/widgets/inventorybar.lua:212-217`.
            -- 添加额外格子
            if self.addextraslots == nil then
                self.addextraslots = 1
                if GLOBAL.EQUIPSLOTS.BELLY ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BELLY, "assets/equip_slot_belly/equip_slot_belly.xml", "equip_slot_belly.tex") -- 服装栏图标
                end
                if GLOBAL.EQUIPSLOTS.NECK ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "assets/equip_slot_neck/equip_slot_neck.xml", "equip_slot_neck.tex") -- 护符栏图标
                end
                if GLOBAL.EQUIPSLOTS.BACK ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "assets/equip_slot_back/equip_slot_back.xml", "equip_slot_back.tex") -- 背包栏图标
                end
                if GLOBAL.EQUIPSLOTS.WAIST ~= nil then
                    self:AddEquipSlot(GLOBAL.EQUIPSLOTS.WAIST, "assets/equip_slot_waist/equip_slot_waist.xml", "equip_slot_waist.tex") -- 腰包栏图标
                end
            end

            local W = 68                                                           -- 格子宽度
            local SEP = 12                                                         -- 格子间隙
            local INTERSEP = 28                                                    -- 组格子间隙 5个一组
            local inv_x = self.inv[#self.inv]:GetPosition().x + W * 0.5 + INTERSEP -- 装备栏起始坐标

            -- 计算原始宽度
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
            local num_equip = #self.equipslotinfo                                                                -- 装备栏个数
            local do_self_inspect = not (self.controller_build or GLOBAL.GetGameModeProperty("no_avatar_popup")) -- 不知道啥意思

            local scale_default = 1.22                                                                           -- See `scripts/widgets/inventorybar.lua:261-262`. 原始缩放值
            local total_w_default = CalcTotalWidth(num_slots, 3, 1)                                              -- 默认宽度
            local total_w_real = CalcTotalWidth(num_slots, num_equip, do_self_inspect and 1 or 0)                -- 现在的宽度
            local scale_real = scale_default / (total_w_default / total_w_real)                                  -- 稍微改了下 我有强迫症 我想把 total_w_default 放中间

            -- 修正贴图
            self.bg:SetScale(scale_real, 1, 1)
            self.bgcover:SetScale(scale_real, 1, 1)

            -- 对融合式背包栏箭头进行调整 -- See `scripts/widgets/inventorybar.lua:313`.
            if GLOBAL.EQUIPSLOTS.BACK ~= nil and num_equip > 3 and self.integrated_arrow then
                local x = inv_x + W + SEP                                                  -- 背包栏原始x坐标
                local new_x = self.equip[GLOBAL.EQUIPSLOTS.BACK]:GetPosition().x - W * 0.5 -- 背包栏新x坐标
                local offset_x = new_x - x                                                 -- 偏移距离

                local old_tex_x = inv_x + 61                                               -- 箭头原始x坐标（+61是因为原版贴图就有便宜）
                local tex_x = old_tex_x + (offset_x * 0.5)                                 -- 箭头新x坐标 （因为要缩放箭头 所以取一半）

                local tex_w = W + SEP + W * 0.5                                            -- 箭头原图宽度 = 1格子 + 1sep + 0.5格子
                local new_tex_w = tex_w + offset_x                                         -- 箭头新宽度

                local scale_x = new_tex_w / tex_w                                          -- 箭头缩放倍率

                self.integrated_arrow:SetPosition(tex_x, 8)                                -- 设置x坐标
                self.integrated_arrow:SetScale(scale_x, 1, 1)                              -- 设置缩放
            end

            -- 指南针 HUD 位置修正：将指南针 HUD 移至实际栏位上方
            -- 原版写死在手持栏位置，改为跟随腰包栏位置（若启用）
            if GLOBAL.EQUIPSLOTS.WAIST ~= nil and self.equip[GLOBAL.EQUIPSLOTS.WAIST] ~= nil then
                local waist_x = self.equip[GLOBAL.EQUIPSLOTS.WAIST]:GetPosition().x
                local compass_y = self.integrated_arrow ~= nil and 80 or 40
                self.hudcompass:SetPosition(waist_x, compass_y, 0)
                self.hand_inv:SetPosition(waist_x, compass_y, 0)
            end
        end

        function Inv:Rebuild()
            if Inv_Rebuild_base then
                Inv_Rebuild_base(self)
            end
            Inv:RebuildExtraSlots()
        end

        function Inv:Refresh()
            if Inv_Refresh_base then
                Inv_Refresh_base(self)
            end
            Inv:RebuildExtraSlots()
        end
    end
    AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", PostConstruct)
end
InitSlot()

-- 初始化物品栏
local function InitPrefab()
    if IsServer then
        -- 为所有物品智能分配插槽
        AddPrefabPostInitAny(function(inst)
            if inst.components.equippable == nil then return end   -- 不可装备物品

            local equipslot = inst.components.equippable.equipslot -- 物品原所属栏

            -- 身体 或者 手持
            if equipslot == 'body' or equipslot == 'hands' then
                local prefab = inst.prefab                   -- 物品名称
                if FORCE_SYMBOL_BODY[prefab] then return end -- 一些模组物品会被误以为是额外的装备 但是它实际上应该在身体栏

                -- 检查是否属于强制服装栏
                if GLOBAL.EQUIPSLOTS.BELLY and FORCE_SYMBOL_BELLY[prefab] then
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY -- 分配到服装栏
                    return
                end

                -- 检查是否属于护符栏
                if GLOBAL.EQUIPSLOTS.NECK and SYMBOL_NECK[prefab] then
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK -- 分配到护符栏
                    return
                end

                -- 检查是否属于背包栏
                if GLOBAL.EQUIPSLOTS.BACK and SYMBOL_BACK[prefab] then
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK -- 分配到背包栏
                    return
                end

                -- 检查是否属于服装栏
                if GLOBAL.EQUIPSLOTS.BELLY and SYMBOL_BELLY[prefab] then
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY -- 分配到服装栏
                    return
                end

                -- 检查是否属于腰包栏
                if GLOBAL.EQUIPSLOTS.WAIST and SYMBOL_WAIST[prefab] then
                    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.WAIST
                    return
                end

                -- 当开启自动识别护符栏
                if GLOBAL.EQUIPSLOTS.NECK and AUTO_SLOTS_NECK then
                    local matched = inst:HasTag("amulet")                             -- 是否有护符标签
                    if matched then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK -- 分配到护符栏
                        return
                    end
                end

                -- 当开启自动识别背包栏
                if GLOBAL.EQUIPSLOTS.BACK and AUTO_SLOTS_BACK then
                    local matched = inst:HasTag("backpack") or inst:HasTag("candybag") -- 是否有背包、糖果袋标签
                    if matched then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK  -- 分配到背包栏
                        return
                    end
                end

                -- 当开启自动识别服装栏
                if GLOBAL.EQUIPSLOTS.BELLY and AUTO_SLOTS_BELLY then
                    local matched = inst.components.waterproofer ~= nil or inst.components.insulator ~= nil or inst.components.rainimmunity ~= nil -- 是否有服装属性（防水/保暖/防雨）
                    if matched then
                        inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BELLY                                                             -- 分配到服装栏
                        return
                    end
                end
            end
        end)
    end
end
InitPrefab()

-- 因为部分物品调整装备栏带来的修复
local function RepairExtra()
    -- 开启服装栏后的修复 参考于 2950481491
    if GLOBAL.EQUIPSLOTS.BELLY then
        -- 当你给“寄居蟹隐士”一件外套时，她会尝试使用旧的装备槽。让我们也用新的.
        -- See `scripts/prefabs/hermitcrab.lua`.
        AddPrefabPostInit("hermitcrab", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            local function iscoat(item)
                return item.components.insulator and item.components.insulator:GetInsulation()
                    >= GLOBAL.TUNING.INSULATION_SMALL
                    and item.components.insulator:GetType() == GLOBAL.SEASONS.WINTER and item.components.equippable
                    and item.components.equippable.equipslot == EQUIPSLOTS_MAP.BELLY
            end

            local function getcoat(inst1)
                local equipped = inst1.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.BELLY)
                return inst1.components.inventory:FindItem(function(testitem) return iscoat(testitem) end)
                    or (equipped and iscoat(equipped) and equipped)
            end

            -- 添加一个额外的项目监听器.
            -- See `scripts/prefabs/hermitcrab.lua:1011`.
            inst:ListenForEvent("itemget", function(_, data)
                if data == nil then return end
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
                        inst1.components.npc_talker:Say(GLOBAL.STRINGS
                            .HERMITCRAB_REFUSE_COAT_HASONE
                            [math.random(#GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT_HASONE)])
                    elseif not GLOBAL.TheWorld.state.issnowing then
                        inst1.components.npc_talker:Say(GLOBAL.STRINGS
                            .HERMITCRAB_REFUSE_COAT
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

        -- “寄居蟹隐士”有一个大脑，可以让她在旧装备槽中装备/取消装备外套。让我们也用新的.
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
                    table.insert(
                        new_children,
                        GLOBAL.IfNode(function()
                            return not brain.inst.sg:HasStateTag("busy") and GLOBAL.TheWorld.state.issnowing
                                and has_coat(brain.inst) and not using_coat(brain.inst)
                        end, "coat", GLOBAL.DoAction(brain.inst, EquipCoat, "coat", true))
                    )
                elseif child.name == "Sequence" and child.children[1].name == "stop coat" then
                    table.insert(
                        new_children,
                        GLOBAL.IfNode(function()
                            return not brain.inst.sg:HasStateTag("busy") and not GLOBAL.TheWorld.state.issnowing
                                and using_coat(brain.inst)
                        end, "stop coat", GLOBAL.DoAction(brain.inst, UnequipCoat, "stop coat", true))
                    )
                else
                    table.insert(new_children, child)
                end
            end
            brain.bt = GLOBAL.BT(brain.inst, GLOBAL.PriorityNode(new_children, 0.5))
        end)
    end

    -- 开启护符栏后的修复
    if GLOBAL.EQUIPSLOTS.NECK then
        -- 重生护符复活：在 SG 状态退出时移除 NECK 槽护符，并清理 swap_body 视觉符号
        local function fixAmuletRebirth()
            AddStategraphPostInit("wilson", function(self)
                -- 获取重生状态（amulet_rebirth 或 rebirth，取决于护符类型）
                local rebirth_state = self.states["amulet_rebirth"] or self.states["rebirth"]
                if not rebirth_state then
                    return
                end

                local original_rebirth_onexit = rebirth_state.onexit -- 保存原版重生状态的退出函数，后续需在自定义逻辑后调用，确保原版功能不受影响

                rebirth_state.onexit = function(inst)
                    local item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK) -- 从 NECK 槽查找护符（原版查 BODY，但现在护符在 NECK）

                    -- 查询到重生护符
                    if item and item.prefab == "amulet" then
                        inst.components.inventory:RemoveItem(item)      -- 从 NECK 槽移除护符
                        inst.AnimState:ClearOverrideSymbol("swap_body") -- 清理角色身体上的背包/服装贴图残留
                        item.persists = false
                        item:Remove()                                   -- 销毁护符（防止复活后重复使用）
                    end

                    -- 执行原版退出函数（如果存在的话）
                    if original_rebirth_onexit then
                        original_rebirth_onexit(inst)
                    end
                end
            end)
        end
        fixAmuletRebirth() -- 修复重生护符问题

        -- 建造护符在制作栏显示 -20% 折扣标记（安全回退 BODY→NECK，不修改函数签名）
        local function fixSetRecipe()
            local CraftingInv = GLOBAL.require "widgets/redux/craftingmenu_ingredients"
            local SetRecipe_base = CraftingInv.SetRecipe -- 原设置配方回调

            -- 重写配方回调
            CraftingInv.SetRecipe = function(self, ...)
                local inventory = self.owner.replica.inventory         -- 前玩家的 inventory 副本
                local orig_GetEquippedItem = inventory.GetEquippedItem -- 原查询物品的方法

                -- 重写物品查询
                inventory.GetEquippedItem = function(self, eslot)
                    -- 查询body物品
                    if eslot == GLOBAL.EQUIPSLOTS.BODY then
                        return orig_GetEquippedItem(self, GLOBAL.EQUIPSLOTS.NECK) or orig_GetEquippedItem(self, GLOBAL.EQUIPSLOTS.BODY) -- 优先查 NECK（建造护符可能在那），找不到再查 BODY
                    end
                    return orig_GetEquippedItem(self, eslot)
                end

                SetRecipe_base(self, ...)                        -- 执行原版（此时 GetEquippedItem 仍被劫持）
                inventory.GetEquippedItem = orig_GetEquippedItem -- 恢复原版
            end
        end
        fixSetRecipe() -- 修复护符栏配方查询
    end

    -- 开启背包栏后的修复
    if GLOBAL.EQUIPSLOTS.BACK then
        -- 修复背包贴图
        AddPlayerPostInit(function(player)
            local equipped_items = {
                body = nil,  -- 护甲物品
                belly = nil, -- 服装物品
                neck = nil,  -- 护符物品
                back = nil,  -- 背包物品
                waist = nil, -- 腰包物品
            }

            --重写贴图渲染逻辑
            local function RefreshEquipOverrides()
                player.AnimState:ClearOverrideSymbol("swap_body_tall") -- 先卸载swap_body_tall（swap_body 游戏引擎内部会卸载）

                -- 设置贴图
                local function setSymbol(item, symbolName)
                    local build = item.AnimState:GetBuild()                                      -- 原版物品贴图
                    if build then                                                                -- 如果背包原版贴图存在
                        player.AnimState:OverrideSymbol(symbolName, build, "swap_body")          -- 设置原版物品贴图
                    end
                    local skin_build = item:GetSkinBuild()                                       -- 背包皮肤贴图
                    if skin_build and skin_build ~= '' then                                      -- 如果背包皮肤贴图存在
                        player.AnimState:OverrideSkinSymbol(symbolName, skin_build, "swap_body") -- 设置皮肤物品贴图
                    end
                end

                -- 设置背包栏贴图
                -- 大部分背包都可以直接分配到 swap_body_tall，但是已变色的光谱背包只能设置在swap_body
                -- 因为只有 swap_body 支持它的变色组件，然而额外的变色组件是叠加在 swap_body 上，所以可以与其他物品的贴图共存
                local function setBackSymbol()
                    local item = equipped_items.back -- 背包栏物品
                    if item == nil then return end

                    -- 是否为已变色的光谱背包
                    local function isSpectralBackpack()
                        if item.components.colouradder == nil then return end -- 无颜色叠加器组件
                        -- 通过 colouradder 检测当前颜色
                        local r, g, b, a = item.components.colouradder:GetCurrentColour()
                        local is_color_changed = (r ~= 0 or g ~= 0 or b ~= 0)
                        return is_color_changed
                    end

                    -- 让已变色的光谱背包留在swap_body
                    if isSpectralBackpack() then
                        setSymbol(item, 'swap_body')
                        return
                    end

                    setSymbol(item, 'swap_body_tall')
                end

                -- 设置身体栏贴图
                local function setBodySymbol()
                    local item = equipped_items.body or equipped_items.belly or equipped_items.neck -- 不需要显示指南针
                    if item == nil then return end
                    setSymbol(item, 'swap_body')
                end

                -- 必须依次执行否则可能出现异常
                player:DoTaskInTime(0, function()                                             -- 第1帧
                    setBodySymbol()
                    player:DoTaskInTime(0, function()                                         -- 第2帧
                        setBackSymbol()
                        player:DoTaskInTime(0, function()                                     -- 第3帧
                            player.AnimState:SetSymbolExchange("swap_body_tall", "swap_body") -- 设置贴图层级 1 < 2 < 3 （swap_body_tall 在 swap_body 下面 ）
                        end)
                    end)
                end)
            end

            -- 装备
            player:ListenForEvent("equip", function(_, data)
                if not data or not data.item then return end

                -- 护甲栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BODY then
                    equipped_items.body = data.item -- 记录当前物品
                end

                -- 服装栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BELLY then
                    equipped_items.belly = data.item -- 记录当前物品
                end

                -- 护符栏
                if data.eslot == GLOBAL.EQUIPSLOTS.NECK then
                    equipped_items.neck = data.item -- 记录当前物品
                end

                -- 背包栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BACK then
                    equipped_items.back = data.item -- 记录当前物品
                end

                -- 腰包栏
                if data.eslot == GLOBAL.EQUIPSLOTS.WAIST then
                    equipped_items.waist = data.item -- 记录当前物品
                end

                RefreshEquipOverrides()
            end)

            -- 卸载
            player:ListenForEvent("unequip", function(_, data)
                if not data then return end

                -- 护甲栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BODY then
                    equipped_items.body = nil -- 移除当前物品
                end

                -- 服装栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BELLY then
                    equipped_items.belly = nil -- 移除当前物品
                end

                -- 护符栏
                if data.eslot == GLOBAL.EQUIPSLOTS.NECK then
                    equipped_items.neck = nil -- 移除当前物品
                end

                -- 背包栏
                if data.eslot == GLOBAL.EQUIPSLOTS.BACK then
                    equipped_items.back = nil -- 移除当前物品
                end

                -- 腰包栏
                if data.eslot == GLOBAL.EQUIPSLOTS.WAIST then
                    equipped_items.waist = nil -- 移除当前物品
                end
                RefreshEquipOverrides()
            end)
        end)

        -- 监听从鬼魂复活事件，重新打开背包容器
        -- 大门/传送阵/肉块雕像复活时，引擎会关闭所有容器，护符复活没有这个问题
        AddPrefabPostInitAny(function(inst)
            if not GLOBAL.TheWorld.ismastersim then return end
            -- 只对玩家角色生效（有 inventory 和 health 组件的就是玩家）
            if inst.components.inventory ~= nil and inst.components.health ~= nil then
                inst:ListenForEvent("respawnfromghost", function()
                    -- 延迟一帧确保复活流程完全结束
                    inst:DoTaskInTime(0, function()
                        local backitem = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
                        if backitem and backitem.components.container then
                            -- 检查容器是否已关闭，如果关闭则重新打开
                            if not backitem.components.container:IsOpen() then
                                backitem.components.container:Open(inst)
                            end
                        end
                    end)
                end)
            end
        end)
    end

    -- 开启腰包栏后的修复
    if GLOBAL.EQUIPSLOTS.WAIST then
        -- 修复指南针 HUD 适配腰包栏
        -- 原版 TryCompass 只检查 EQUIPSLOTS.HANDS，腰包指南针无法触发 HUD
        AddGlobalClassPostConstruct("widgets/hudcompass", "HudCompass", function(self)
            -- 卸下腰包指南针时关闭 HUD
            self.inst:ListenForEvent("unequip", function(inst, data)
                if data.eslot == GLOBAL.EQUIPSLOTS.WAIST then
                    self:CloseCompass()
                end
            end, self.owner)

            -- 刷新背包时检查腰包栏
            self.inst:ListenForEvent("refreshinventory", function()
                if self.owner.replica.inventory ~= nil then
                    local equipment = self.owner.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.WAIST)
                    if equipment ~= nil and equipment:HasTag("compass") then
                        self:OpenCompass()
                    end
                end
            end, self.owner)

            -- 初始化时检查腰包栏（原版 TryCompass 只查 HANDS）
            self.inst:DoTaskInTime(0, function()
                if self.owner.replica.inventory ~= nil then
                    local equipment = self.owner.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.WAIST)
                    if equipment ~= nil and equipment:HasTag("compass") then
                        self:OpenCompass()
                    end
                end
            end)
        end)
    end

    -- 容器堆叠修复：为新增装备槽（BELLY/NECK/BACK）提供正确的物品堆叠容器识别
    -- 问题背景：原版 GetOverflowContainer 只检查 BODY 和 HEAD 槽位的打开容器。
    --          当物品被分配到 BELLY 或 BACK 槽时，这些槽位的容器不会被识别为"溢出目标"，
    --          导致玩家从背包/服装容器中拿取物品时，堆叠/整理逻辑失效。
    -- 解决思路：重写 GetOverflowContainer，使其覆盖所有可能装有容器的装备槽位。
    local function PrefabPostInit(inst)
        -- 自定义的溢出容器查找函数，替代 inventory_classified 中的原版函数
        -- 返回值：当前玩家正打开的某个容器（用于物品堆叠的目标容器），如果没有打开的容器则返回 nil
        local function GetOverflowContainer()
            -- 如果设置了忽略溢出标志，则跳过（某些特殊物品或状态需要）
            if inst.ignoreoverflow then
                return
            end

            -- 获取指定装备槽位上已打开的容器，如果该槽位没有物品或无容器/未打开则返回 nil
            local function getOpenContainer(eslot)
                local item = inst.GetEquippedItem(inst, eslot)
                if item and item.replica and item.replica.container and item.replica.container._isopen then
                    return item.replica.container
                end
            end

            -- 按优先级顺序查找已打开的容器
            -- 原版只检查 body 和 head，这里新增了 back、belly 和 neck
            -- 优先级：BACK > BODY > HEAD > BELLY > NECK
            return getOpenContainer(GLOBAL.EQUIPSLOTS.BACK)
                or getOpenContainer(GLOBAL.EQUIPSLOTS.BODY)
                or getOpenContainer(GLOBAL.EQUIPSLOTS.HEAD)
                or getOpenContainer(GLOBAL.EQUIPSLOTS.BELLY)
                or getOpenContainer(GLOBAL.EQUIPSLOTS.NECK)
                or getOpenContainer(GLOBAL.EQUIPSLOTS.WAIST)
        end

        -- 需要替换内部 GetOverflowContainer 引用的方法列表
        -- 这些方法内部都通过 upvalue（上值）引用了原版的 GetOverflowContainer
        -- 我们需要用 debug.setupvalue 将它们替换为新版本
        local funclist = {
            "Has",                                 -- 检查是否持有某物品
            "UseItemFromInvTile",                  -- 从物品栏格子使用物品
            "ControllerUseItemOnItemFromInvTile",  -- 手柄：在物品栏格子上对物品使用物品
            "ControllerUseItemOnSelfFromInvTile",  -- 手柄：在物品栏格子上对自身使用物品
            "ControllerUseItemOnSceneFromInvTile", -- 手柄：在物品栏格子上对场景使用物品
            "ReceiveItem",                         -- 接收物品（拾取/交易等）
            "RemoveIngredients"                    -- 移除合成材料
        }

        -- 替换函数内部的 upvalue（上值）
        -- fn：要修改的函数
        -- path：上值访问路径（如 "GetOverflowContainer"）
        -- new：要替换的新值
        local function setval(fn, path, new)
            local val = fn
            local prev = nil
            local i
            -- 按点号分割路径，逐层查找上值
            for entry in path:gmatch("[^%.]+") do
                i = 1
                prev = val
                -- 遍历指定函数的所有上值（upvalue），找到匹配名称的
                while true do
                    local name, value = GLOBAL.debug.getupvalue(val, i)
                    if name == entry then
                        val = value
                        break
                    elseif name == nil then
                        return -- 没找到，跳过
                    end
                    i = i + 1
                end
            end
            -- 替换找到的上值为新函数
            GLOBAL.debug.setupvalue(prev, i, new)
        end

        -- 遍历所有需要修改的方法，将其内部的 GetOverflowContainer 引用替换为新版本
        for _, v in ipairs(funclist) do
            if inst[v] and type(inst[v]) == "function" then
                setval(inst[v], "GetOverflowContainer", GetOverflowContainer)
            end
        end

        -- 在客户端（非服务器）上，直接暴露新的 GetOverflowContainer 方法
        -- 因为客户端的一些 UI 逻辑（如物品拖拽）也会调用这个方法
        if not IsServer then
            inst.GetOverflowContainer = GetOverflowContainer
        end
    end

    -- 只要开启了任意新增槽位，就应用这个修复
    -- 因为即使只开了一个槽位，也需要确保容器堆叠能正确识别该槽位
    if GLOBAL.EQUIPSLOTS.NECK or GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BELLY or GLOBAL.EQUIPSLOTS.WAIST then
        AddPrefabPostInit("inventory_classified", PrefabPostInit)
    end

    -- 服务器端 GetOverflowContainer 修复：为新增装备槽提供正确的物品堆叠容器识别
    -- 问题背景同客户端：原版 inventory:GetOverflowContainer() 只检查 BODY 槽
    -- 导致玩家捡物品时不会自动与背包/服装容器中的同类物品堆叠
    local function ServerInventoryPostInit(comp)
        local _GetOverflowContainer = comp.GetOverflowContainer
        function comp:GetOverflowContainer()
            -- 先尝试原版逻辑（仅 BODY 槽）
            local container = _GetOverflowContainer(self)
            if container then
                return container
            end

            -- 检查新增装备槽的打开容器
            for _, eslot in ipairs({ GLOBAL.EQUIPSLOTS.BACK, GLOBAL.EQUIPSLOTS.BELLY, GLOBAL.EQUIPSLOTS.NECK, GLOBAL.EQUIPSLOTS.WAIST }) do
                if eslot then
                    local item = self:GetEquippedItem(eslot)
                    if item and item.components.container and item.components.container:IsOpen() then
                        return item.components.container
                    end
                end
            end
        end
    end

    -- 服务器端：只要开启了任意新增槽位，就应用这个修复
    if IsServer and (GLOBAL.EQUIPSLOTS.NECK or GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BELLY or GLOBAL.EQUIPSLOTS.WAIST) then
        AddComponentPostInit("inventory", ServerInventoryPostInit)
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
