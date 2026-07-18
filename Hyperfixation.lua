--#region File Loading
mod_path = "" .. SMODS.current_mod.path
---Loads all files in a folder (Will likely load unordered.)
---@param folder string The filepath to the folder you want to load. (ex: "Ijiraq/Exceptions")
---@param opts table? Filepath or table of filepaths to skip during the folder loading. Filetype not required
function HPFX_load_folder(folder, opts)
    opts = opts or {}
    local except_map = {}
    if opts.except then
        if type(opts.except) == "string" then
            except_map[opts.except] = true
        elseif type(opts.except) == "table" then
            for _, v in ipairs(opts.except) do except_map[v] = true end
        end
    end

    local files = SMODS.NFS.getDirectoryItems(mod_path .. folder) or {}
    for i, file in ipairs(files) do
        local name_no_ext = file:match("(.+)%..+$") or file
        if not except_map[file] and not except_map[name_no_ext] then
            local path = folder .. "/" .. file
            local HPFX_foad_lolder = SMODS.load_file(path)
            if type(HPFX_foad_lolder) == "function" then
                HPFX_foad_lolder()
            else
                -- directory recursion
                local sub = SMODS.NFS.getDirectoryItems(mod_path .. path)
                if sub and #sub > 0 then
                    HPFX_load_folder(path, opts)
                else
                    print("hpfx - skip for recursion:", path)
                end
            end
        else
            print("hpfx - skipped:", file)
        end
    end
end

--ordered loading for aesthetic reasons
SMODS.load_file('items/Isaac/IsaacCenter.lua')()
HPFX_load_folder('items/Isaac', { except = { 'IsaacCenter' } })
HPFX_load_folder('items/4Fun')
HPFX_load_folder('items/Inscryption', {
    except = {
        'Unloaded',
        'Acts',
        'IncognitoJokers',
        'IncognitoVouchers',
    }
})

--order doesn't matter here
HPFX_load_folder('src')
HPFX_load_folder('lib', { except = { 'joker-display_defs' } })
SMODS.load_file('items/Stickers.lua')()
--#endregion
--#region Mod Compat Stuff
to_big = to_big or function(x) return x end --talisman conversion function
if JokerDisplay then
    SMODS.load_file('lib/joker-display_defs.lua')()
end
if Incognito then
    HPFX_load_folder('items/Inscryption/IncognitoJokers')
    HPFX_load_folder('items/Inscryption/IncognitoVouchers')
end
--#endregion
--#region Profile Settings Initialization
G.PROFILES[G.SETTINGS.profile].hpfx_crimsonCount = G.PROFILES[G.SETTINGS.profile].hpfx_crimsonCount or 0
G.PROFILES[G.SETTINGS.profile].hpfx_devilCount = G.PROFILES[G.SETTINGS.profile].hpfx_devilCount or 0
G.PROFILES[G.SETTINGS.profile].hpfx_queenCount = G.PROFILES[G.SETTINGS.profile].hpfx_queenCount or 0
G.PROFILES[G.SETTINGS.profile].hpfx_bitch = G.PROFILES[G.SETTINGS.profile].hpfx_bitch or false
--#endregion
--#region Global Features
Hyperfixation = {
    path = mod_path,
    masdet = false,
    current_mod = SMODS.current_mod,
    --usedHoggy = false,
    wheel_fails = 0,
    raqeffects = {},
    trig = {},
    --Double Trouble defaults
    hpfxDT_idx1 = G.P_BLINDS and G.P_BLINDS[1] or {},
    hpfxDT_idx2 = G.P_BLINDS and G.P_BLINDS[2] or {},
    ---Used to store the original weights of boosters.
    og_boostweight = og_boostweight or {},
    --[[
    keys Ijiraq will skip when deciding disguises
    Jokers that don't use hand calc or have custom conditions should be included here.
    Jokers that do use hand calc and do not have custom logic transform after a hand.
    ]]
    ---Jokesters that overwrite the automatic behavior Costume would use
    exceptions = exceptions or {
        j_misprint = 'j_hpfx_reprint',
        j_raised_fist = 'j_hpfx_braised',
        j_mystic_summit = 'j_hpfx_twistit',
        j_loyalty_card = 'j_hpfx_redeemed',
        j_steel_joker = 'j_hpfx_iron',
        j_acrobat = 'j_hpfx_trapezoid',
        j_banner = 'j_hpfx_flag',
        j_merry_andy = 'j_hpfx_scaryandy',
        j_troubadour = 'j_hpfx_bard',
        j_hack = 'j_hpfx_whack',
        j_marble = 'j_hpfx_porcelain',
        j_golden = 'j_hpfx_pyramid',
        j_credit_card = 'j_hpfx_expired',
        j_blueprint = 'j_hpfx_bluebell',
        j_chaos = 'j_hpfx_chaoz',
        j_juggler = 'j_hpfx_jiggler',
        j_drunkard = 'j_hpfx_scrumpy',
        j_glass = 'j_hpfx_fiberglass',
        j_abstract = 'j_hpfx_pomni',
        j_delayed_grat = 'j_hpfx_belated_grat',
        j_ticket = 'j_hpfx_tocket',
        j_pareidolia = 'j_hpfx_apophenia',
        j_cartomancer = 'j_hpfx_not_fortune_teller',
        j_even_steven = 'j_hpfx_odd_steven',
        j_odd_todd = 'j_hpfx_even_todd',
        j_scholar = 'j_hpfx_flunkie',
        j_mr_bones = 'j_hpfx_ribtickler',
        j_seeing_double = 'j_hpfx_peeking_twice',
        j_duo = 'j_hpfx_dupla',
        j_trio = 'j_hpfx_triada',
        j_family = 'j_hpfx_familia',
        j_order = 'j_hpfx_orden',
        j_tribe = 'j_hpfx_tribu',
        j_8_ball = 'j_hpfx_7_ball',
        j_fibonacci = 'j_hpfx_golden_ratio',
        j_stencil = 'j_hpfx_cutout',
        j_space = 'j_hpfx_time',
        j_matador = 'j_hpfx_manolo',
        j_ceremonial = 'j_hpfx_ritual',
        j_ring_master = 'j_hpfx_showman',
        j_sixth_sense = 'j_hpfx_nix_sense',
        j_fortune_teller = 'j_hpfx_not_cartomancer',
        j_hit_the_road = 'j_hpfx_dont_come_back',
        j_flower_pot = 'j_hpfx_daisy_vase',
        j_ride_the_bus = 'j_hpfx_get_an_uber',
        j_shoot_the_moon = 'j_hpfx_take_the_sun',
        j_smeared = 'j_hpfx_smudged',
        j_oops = 'j_hpfx_whoops',
        j_four_fingers = 'j_hpfx_and_thumb',
        j_gros_michel = 'j_hpfx_close_michelle',
        j_stuntman = 'j_hpfx_buttowski',
        j_hanging_chad = 'j_hpfx_hung_chad',
        j_drivers_license = 'j_hpfx_learners_permit',
        j_invisible = 'j_hpfx_invincible',
        j_astronomer = 'j_hpfx_galilimbo',
        j_burnt = 'j_hpfx_charred',
        j_dusk = 'j_hpfx_dawn',
        j_throwback = 'j_hpfx_flashforward',
        j_brainstorm = 'j_hpfx_stormcloud',
        j_satellite = 'j_hpfx_apollo',
        j_rough_gem = 'j_hpfx_snowgrave',
        j_bloodstone = 'j_hpfx_sanguinerock',
        j_arrowhead = 'j_hpfx_ahead',
        j_onyx_agate = 'j_hpfx_obsidian',
        j_caino = 'j_hpfx_canio',
        j_triboulet = 'j_hpfx_dribblinit',
        j_yorick = 'j_hpfx_yomorty',
        j_chicot = 'j_hpfx_anglerais',
        j_perkeo = 'j_hpfx_perknado',
        j_certificate = 'j_hpfx_sirtificate',
        j_bootstraps = 'j_hpfx_shoebuckles',
        j_egg = 'j_hpfx_chicken',
        j_burglar = 'j_hpfx_robber',
        j_splash = 'j_hpfx_splatter',
        j_constellation = 'j_hpfx_sagittarius',
        j_hiker = 'j_hpfx_hitchhiker',
        j_faceless = 'j_hpfx_noface',
        j_square = 'j_hpfx_rectangle',
        --j_joker = 'j_hpfx_jumbo',
        j_shortcut = 'j_hpfx_secretway',
        j_cloud_9 = 'j_hpfx_earthbound',
        j_rocket = 'j_hpfx_blastoff',
        j_luchador = 'j_hpfx_wrestler',
        j_gift = 'j_hpfx_card',
        j_turtle_bean = 'j_hpfx_lima_bean',
        j_to_the_moon = 'j_hpfx_take_the_moon',
        j_hallucination = 'j_hpfx_illusion',
        j_baseball = 'j_hpfx_softball',
        j_diet_cola = 'j_hpfx_cola',
        j_trading = 'j_hpfx_collecting',
        j_selzer = 'j_hpfx_seltzer',
        j_smiley = 'j_hpfx_frowny',
        j_walkie_talkie = 'j_hpfx_talkie_walkie',
    },
    --needle contexts
    allcalcs = allcalcs or {
        "main_eval",
        "beat_boss",
        "hook",
        "before",
        "after",
        "main_scoring",
        "individual",
        "repetition",
        "edition",
        "pre_joker",
        "post_joker",
        "joker_main",
        "final_scoring_step",
        "remove_playing_cards",
        "debuffed_hand",
        "end_of_round",
        "setting_blind",
        "pre_discard",
        "discard",
        "open_booster",
        "skipping_booster",
        "buying_card",
        "selling_card",
        "reroll_shop",
        "ending_shop",
        "first_hand_drawn",
        "hand_drawn",
        "using_consumeable",
        "skip_blind",
        "playing_card_added",
        "card_added",
        "check_enhancement",
        "post_trigger",
        "modify_scoring_hand",
        "ending_booster",
        "starting_shop",
        "blind_disabled",
        "blind_defeated",
        "press_play",
        "ignore_debuff",
        "debuff_hand",
        "check",
        "stay_flipped",
        "modify_hand",
        "drawing_cards",
        "pseudorandom_result",
        "from_roll",
        "result",
        "initial_scoring_step",
        "joker_type_destroyed",
        "check_eternal",
        "trigger",
        "change_rank",
        "change_suit",
        "rank_increase",
        "round_eval",
        "money_altered",
    },
    --iji make sure you dont pretend to be these
    brokejokes = brokejokes or {
        --basegame
        ['j_constellation'] = next(SMODS.find_mod('Overflow')) or false,
        ['j_hologram'] = true,
        ['j_madness'] = true,
        ['j_faceless'] = true,
        ['j_yorick'] = true,
        ['j_vampire'] = true,
        ['j_obelisk'] = true,
        ['j_lucky_cat'] = true,
        ['j_ramen'] = true,
        ['j_campfire'] = true,
        ['j_todo_list'] = true,
        --hpfx
        ['j_hpfx_ijiraq'] = true,
        ['j_hpfx_moriah'] = true,
        ['j_hpfx_mary'] = true,
        ['j_hpfx_iscariot'] = true,
        ['j_hpfx_cyanosis'] = true,
        ['j_hpfx_marie'] = true,
        ['j_hpfx_space_needle'] = true,
        ['j_hpfx_no_bitches'] = true,
        --incognito
        ['j_nic_crazydave'] = true,
        ['j_nic_peashooter'] = true,
        ['j_nic_sunflower'] = true,
        ['j_nic_cherrybomb'] = true,
        ['j_nic_wallnut'] = true,
        ['j_nic_potatomine'] = true,
        ['j_nic_snowpea'] = true,
        ['j_nic_chomper'] = true,
        ['j_nic_repeater'] = true,
        ['j_nic_puffshroom'] = true,
        ['j_nic_sunshroom'] = true,
        ['j_nic_fumeshroom'] = true,
        ['j_nic_gravebuster'] = true,
        ['j_nic_hypnoshroom'] = true,
        ['j_nic_scaredyshroom'] = true,
        ['j_nic_iceshroom'] = true,
        ['j_nic_doomshroom'] = true,

        ['j_nic_mysteto'] = true,
        ['j_nic_tetoxko'] = true,
        ['j_nic_tetoraq'] = true,
        ['j_nic_triteto'] = true,
        ['j_nic_tetorobo'] = true
    },
    ---Jokesters that calculate dollar bonuses. Jokester is k, Joker is v
    calcdollarjokesters = calcdollarjokesters or {
        j_hpfx_pyramid = 'j_golden',
        j_hpfx_earthbound = 'j_cloud_9',
        j_hpfx_blastoff = 'j_rocket',
        j_hpfx_take_the_moon = 'j_to_the_moon',
        j_hpfx_apollo = 'j_satellite',
    },
    --Isaac joker keys
    isaac_jokers = isaac_jokers or {
        'j_hpfx_moriah',
        'j_hpfx_mary',
        'j_hpfx_iscariot',
        'j_hpfx_farmer',
        'j_hpfx_cyanosis',
        'j_hpfx_favorite',
    },
    C = {
        HPFX_PRIMARY = HEX('fcb3ea'),
        HPFX_SECONDARY = HEX('ad1515')
    },

    ---If certain mods are installed, add their crossmodded jokers to the exceptions table. Make sure to check if Hyperfixation exists and is a table.
    ---@param mod_id any The ID of the mod to check. Can be found in `metadata.json`.
    ---@param joker_key any The key of the Joker the Ijiraq will be mimicking.
    ---@param ijiraq_joker_key any The key of the Joker the Ijiraq will transform from. Make sure it calls `hpfx_Transform(card, context)`
    ---@param onpayout boolean Jokers in this table will transform after payout. Set to `false` to disable this.
    hypercross = function(mod_id, joker_key, ijiraq_joker_key, onpayout)
        if not next(SMODS.find_mod(mod_id)) then
            print("Hyperfixation: hypercross: Mod not found: " .. tostring(mod_id))
            return
        else
            local k, v = joker_key, ijiraq_joker_key
            -- Adds the joker to the exceptions table
            Hyperfixation.exceptions[k] = tostring(v)

            -- Check if the table has a calc_dollar_bonus function
            local obj = SMODS.Centers[v]
            if not obj then
                print("SMODS.Centers does not contain key: ", v)
                -- Optionally: return or skip further logic
            elseif obj and obj.calc_dollar_bonus and type(obj.calc_dollar_bonus) == 'function' then
                if onpayout == true then
                    Hyperfixation.calcdollarjokesters[v] = tostring(k)
                end
            else
                -- If the function does not exist, print a message to the console
                print("calc_dollar_bonus does not exist.")
                print("obj: " .. tostring(obj))
                print('key: ' .. tostring(k))
                print('value: ' .. tostring(v))
            end
        end
    end,
    ---Value storing for Ijiraq's abilities that I stole from Somecom (kidding ty somecom)
    ---@param self any The card object with the values that you want to save. (ex: `card`, `self`, etc.)
    ---@param center any The center where values are being set. (ex: `G.P_CENTERS`, `SMODS.Centers`, etc.)
    safe_set_ability = function(self, center)
        if not self or not center then return nil end
        local oldcenter = self.config.center
        G.GAME.hpfx_ijiraq_savedvalues = G.GAME.hpfx_ijiraq_savedvalues or {}
        G.GAME.hpfx_ijiraq_savedvalues[self.sort_id] = G.GAME.hpfx_ijiraq_savedvalues[self.sort_id] or {}
        G.GAME.hpfx_ijiraq_savedvalues[self.sort_id][oldcenter.key] = copy_table(self.ability)
        configSAVE = G.GAME.hpfx_ijiraq_savedvalues[self.sort_id][center.key]
        config = {}
        for k, v in pairs(center.config) do config[k] = v end
        if configSAVE then
            for k, v in pairs(configSAVE) do config[k] = v end
        end
        self.config.center = center
        for k, v in pairs(G.P_CENTERS) do
            if center == v then self.config.center_key = k end
        end
        if self.ability and oldcenter and oldcenter.config.bonus then
            self.ability.bonus = self.ability.bonus - oldcenter.config.bonus
        end
        local new_ability = {
            name = center.name,
            effect = center.effect,
            set = center.set,
            mult = config.mult or 0,
            h_mult = config.h_mult or 0,
            h_x_mult = config.h_x_mult or 0,
            h_dollars = config.h_dollars or 0,
            p_dollars = config.p_dollars or 0,
            t_mult = config.t_mult or 0,
            t_chips = config.t_chips or 0,
            x_mult = config.Xmult or config.x_mult or 1,
            h_chips = config.h_chips or 0,
            x_chips = config.x_chips or 1,
            h_x_chips = config.h_x_chips or 1,
        }
        self.ability = self.ability or {}
        for k, v in pairs({ new_ability, config }) do
            for l, u in pairs(v) do
                self.ability[l] = copy_table(u)
            end
        end
        if self.ability.name == "Invisible Joker" then
            self.ability.invis_rounds = self.ability.invis_rounds or 0
        end
        if self.ability.name == 'To Do List' then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands + 1] = k end
            end
            local old_hand = self.ability.to_do_poker_hand
            self.ability.to_do_poker_hand = nil
            while not self.ability.to_do_poker_hand do
                self.ability.to_do_poker_hand = pseudorandom_element(_poker_hands,
                    pseudoseed((self.area and self.area.config.type == 'title') and 'false_to_do' or 'to_do'))
                if self.ability.to_do_poker_hand == old_hand then self.ability.to_do_poker_hand = nil end
            end
        end
        if self.ability.name == 'Caino' then
            self.ability.caino_xmult = self.ability.caino_xmult or 1
        end
        if self.ability.name == 'Yorick' then
            self.ability.yorick_discards = self.ability.extra.discards or 23
        end
        if self.ability.name == 'Loyalty Card' then
            self.ability.burnt_hand = 0
            self.ability.loyalty_remaining = self.ability.extra.every
        end
    end,
    --Double Trouble function that pulls the names of blinds
    blind_has_name = function(self, target)
        if type(self.names) == "table" then
            for _, n in ipairs(self.names) do
                if n == target then return true end
            end
        end
        return self.name == target
    end,
    -- table checker
    table = {
        contains = function(tbl, val)
            for _, v in ipairs(tbl) do
                if v == val then return true end
            end
            return false
        end,
    },
    --thanks n'
    no_collection = {},
    --thanks toga
    updatecollectionitems = function()
        local ijiraq_pool = G.P_CENTER_POOLS.Joker
        local filtered_pool = {}
        for _, cen in ipairs(ijiraq_pool) do
            if not Hyperfixation.brokejokes[cen.key] then
                table.insert(filtered_pool, cen.key)
            end
        end
        for k, v in pairs(G.P_CENTERS) do
            if Hyperfixation.table.contains(filtered_pool, v.key) then
                if Hyperfixation.current_mod.config.masterdetective then
                    v.no_collection = true
                else
                    v.no_collection = Hyperfixation.no_collection[v.key]
                end
            end
        end
    end,
}

Hyperfixation.current_mod.optional_features = function() --more features
    return {
        post_trigger = true,
        retrigger_joker = true,
        cardareas = { discard = true, deck = true }
    }
end
Hyperfixation.current_mod.calculate = function(self, context) --calcbased unlocks
    --Iscariot
    if context.using_consumeable and context.consumeable.config.center.key == "c_devil" then
        if type(G.PROFILES[G.SETTINGS.profile].hpfx_devilCount) ~= "number" then
            G.PROFILES[G.SETTINGS.profile].hpfx_devilCount = 0
        end
        G.PROFILES[G.SETTINGS.profile].hpfx_devilCount = G.PROFILES[G.SETTINGS.profile].hpfx_devilCount + 1
        --print("Devil Count: " .. tostring(G.PROFILES[G.SETTINGS.profile].hpfx_devilCount))
        if G.PROFILES[G.SETTINGS.profile].hpfx_devilCount >= 3 then
            check_for_unlock({ type = 'hpfx_devil' })
            G.PROFILES[G.SETTINGS.profile].hpfx_devilCount = 0
        end
    end
    --Marie Antoinette
    if context.remove_playing_cards then
        if type(G.PROFILES[G.SETTINGS.profile].hpfx_queenCount) ~= "number" then
            G.PROFILES[G.SETTINGS.profile].hpfx_queenCount = 0
        end
        for _, i in ipairs(context.removed) do
            if i:get_id() == 12 then
                G.PROFILES[G.SETTINGS.profile].hpfx_queenCount = G.PROFILES[G.SETTINGS.profile].hpfx_queenCount + 1
            end
        end
        if G.PROFILES[G.SETTINGS.profile].hpfx_queenCount >= 37 then
            check_for_unlock({ type = 'hpfx_head' })
            G.PROFILES[G.SETTINGS.profile].hpfx_queenCount = 0
        end
    end
    --No Bitches
    if context.before then
        for i = 1, #context.scoring_hand do
            if context.scoring_hand[i]:get_id() == 12 then
                G.PROFILES[G.SETTINGS.profile].hpfx_bitch = true
            end
        end
    end
    --Chud
    if context.post_trigger then
        Hyperfixation.nothingEverHappens = false
    end
    if context.end_of_round and context.beat_boss and G.GAME.round_resets.ante >= 3 then
        if Hyperfixation.nothingEverHappens then
            check_for_unlock({ type = 'hpfx_chud' })
        else
            Hyperfixation.nothingEverHappens = true
        end
    end
    --Boulder
    if context.end_of_round and context.game_over == false and context.main_eval then
        for _, playing_card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(playing_card, 'm_hpfx_boulder') then
                SMODS.destroy_cards(playing_card, true, true, true)
            end
        end
    end
    --The Jester of Justice
    if context.game_over then
        for _, v in ipairs(SMODS.find_card('j_joker', true)) do
            if v.ability.eternal then
                check_for_unlock({ type = 'hpfx_old' })
            end
        end
    end
end
Hyperfixation.current_mod.ui_config = { --Configuration
    colour = { G.C.SET.Tarot[2], G.C.SECONDARY_SET.Planet[1], G.C.SO_2.Hearts[3], 1 },
    -- Color of the mod menu BG
    author_colour = HEX("FCB3EA"),
    -- Color of the text displaying the mod authors
    bg_colour = { G.C.SET.Tarot[2], G.C.SECONDARY_SET.Planet[1], G.C.SO_2.Hearts[3], 0.5 },
    -- Color of the area behind the mod menu.
    back_colour = HEX("FCB3EA"),
    -- Color of the "Back" button
    tab_button_colour = HEX("FCB3EA"),
    -- Color of the tab buttons
    --back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or "your_collection",
}
Hyperfixation.current_mod.config_tab = function() --Also Configuration
    return {
        n = G.UIT.ROOT,
        config = {
            align = "c",
            minw = 9,
            minh = 6,
            padding = 0.2,
            r = 0.1,
            colour = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.4 },
            outline = 3,
            outline_colour = G.C.WHITE,
            hover = true,
            shadow = true
        },
        nodes = { {
            n = G.UIT.C,
            config = {
                align = "tl",
                minw = 4,
                minh = 6,
                padding = 0.2
            },
            nodes = {
                {
                    n = G.UIT.R,
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { padding = 0 },
                            nodes = { create_toggle({
                                label = localize('hpfx_rebirth_title'),
                                info = localize('hpfx_rebirth_option'),
                                active_colour = G.C.GREEN,
                                col = true,
                                ref_table = Hyperfixation.current_mod.config,
                                ref_value = "rebirth",
                            }) }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { padding = 0 },
                            nodes = { create_toggle({
                                label = localize('hpfx_md_title'),
                                info = localize('hpfx_md_option'),
                                active_colour = G.C.GREEN,
                                col = true,
                                ref_table = Hyperfixation.current_mod.config,
                                ref_value = "masterdetective",
                            }) }
                        }
                    },
                }
            }
        } }
    }
end

function Hyperfixation.fortune_cookie_ui() --Fortune Cookie
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            r = 0.1,
            padding = 0.1,
            colour = G.C.BLACK,
            align = "cm",
            minw = 6,
            minh = 4
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    text = localize('hpfx_fortune_cookie_teaser'),
                    colour = G.C.UI.TEXT_LIGHT,
                    scale = 0.8,
                }
            }
        }
    }
end

function G.FUNCS.astra()
    local url = "https://github.com/the-Astra/Maximus"
    love.system.openURL(url)
end

function G.FUNCS.bkb()
    local url = "https://gdane.net"
    love.system.openURL(url)
end

function G.FUNCS.incog()
    local url = "https://github.com/incogniton71/Incognito"
    love.system.openURL(url)
end

function Hyperfixation.credits_ui()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, minw = 16, minh = 8, align = "tm", padding = 0.2, colour = G.C.BLACK },
        nodes = {
            create_tabs({
                snap_to_nav = true,
                colour = Hyperfixation.C.HPFX_PRIMARY,
                scale = 0.8,
                tabs = {
                    {
                        label = "Isaac",
                        chosen = true,
                        tab_definition_function = Hyperfixation.isaac_ui,
                    },
                    {
                        label = "Inscryption",
                        chosen = false,
                        tab_definition_function = Hyperfixation.inscryption_ui,
                    },
                    {
                        label = "4Fun",
                        chosen = false,
                        tab_definition_function = Hyperfixation.fourfun_ui,
                    },
                    {
                        label = "Other Help",
                        chosen = false,
                        tab_definition_function = Hyperfixation.other_help_ui,
                    },
                    {
                        label = "bwuh",
                        chosen = false,
                        tab_definition_function = Hyperfixation.bwuh_ui,
                    },
                }
            }),
        }
    }
end

function Hyperfixation.generate_credits_desc_nodes(entry)
    local name = {}

    name[#name + 1] = {}
    local loc_vars = { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.8 }
    localize { type = 'descriptions', key = "hpfx_" .. entry.name .. "_credits", set = 'Other', nodes = name[#name], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
    name[#name] = desc_from_rows(name[#name])
    name[#name].config.colour = loc_vars.background_colour or name[#name].config.colour

    local desc_nodes = {}
    localize({
        type = "other",
        key = "hpfx_" .. entry.name .. "_credits_" .. entry.category .. "_descriptions",
        nodes = desc_nodes,
        scale = 2
    })
    credits_rows = {}
    for _, v in ipairs(desc_nodes) do
        credits_rows[#credits_rows + 1] = { n = G.UIT.R, config = { align = "cl" }, nodes = v }
    end

    -- Joker of Choice
    local area = CardArea(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W, G.CARD_H,
        { card_limit = 1, type = 'title', highlight_limit = 0, collection = true })                      -- Card Area
    local card = Card(area.T.x, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[entry.joker]) -- Card Importing

    area:emplace(card)

    card.no_ui = true
    if entry.joker == "j_hpfx_jolyne" then
        function card:click()
            play_sound("hpfx_vineboom")
            self:start_dissolve({ G.C.RED })
            self:juice_up(10, 10)
        end
    end

    return {
        n = G.UIT.R,
        config = { emboss = 0.05, r = 0.1, align = "tl", padding = 0.2, colour = G.C.UI.TEXT_INACTIVE },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cl", padding = 0.05 },
                nodes = {

                    -- Name
                    {
                        n = G.UIT.R,
                        config = { emboss = 0.05, r = 0.1, align = "tl", padding = 0.05, colour = G.C.WHITE },
                        nodes = name
                    },
                    -- Sentence
                    { 
                        n = G.UIT.R, 
                        config = { align = "tl", padding = 0.05, }, 
                        nodes = credits_rows
                    },

                }
            },

            -- Card Area
            {
                n = G.UIT.C,
                config = { align = "tr", padding = 0.05 },
                nodes = {
                    { n = G.UIT.O, config = { object = area } }
                }
            }
        }
    }
end

--#region Isaac Credits
Hyperfixation.isaac_credits_table = {
    { name = "astra", category = "isaac", joker = "j_hpfx_mary", },
    { name = "bagersdozenbagels", category = "isaac", joker = "j_hpfx_cyanosis", }, 
    { name = "delirium", category = "isaac", joker = "j_hpfx_jolyne", },
    { name = "ejwu", category = "isaac", joker = "j_hpfx_cyanosis", },
    { name = "eremel", category = "isaac", joker = "j_hpfx_jolyne", },
    { name = "foxdeploy", category = "isaac", joker = "j_hpfx_jolyne", },
    { name = "lars", category = "isaac", joker = "j_hpfx_farmer", },
    { name = "n", category = "isaac", joker = "j_hpfx_iscariot", },
    { name = "somecom", category = "isaac", joker = "j_hpfx_jolyne", },
    { name = "srock", category = "isaac", joker = "j_hpfx_mary", },
    { name = "winter", category = "isaac", joker = "j_hpfx_mary", },
    { name = "youh", category = "isaac", joker = "j_hpfx_jolyne", },
}

function Hyperfixation.isaac_ui()
    rows = {}

    for _, entry in ipairs(Hyperfixation.isaac_credits_table) do
        rows[#rows + 1] = Hyperfixation.generate_credits_desc_nodes(entry)
    end

    local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.BLACK },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				maxh = 6,
				r = 0.1,
			},
		},
		sync_mode = "progress",
	})

    return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", colour = G.C.L_BLACK, padding = 0.1, r = 0.1, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = scrollbox,
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					SMODS.GUI.scrollbar({
						h = 6,
						w = 0.3,
						max = 1,
						min = 0,
						colour = HEX("FCB3EA"),
						bg_colour = { 0, 0, 0, 0.15 },
						scroll_collision_obj = scrollbox,
					}),
				},
			},
		},
	}
end

--#endregion
--#region Inscryption Credits
Hyperfixation.inscryption_credits_table = {
    { name = "carrot", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "carrymehome", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "cheekyrotter", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "corobo", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "delirium", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "dex", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "dilly", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "eremel", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "eris", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "fey", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "finity", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "hamester", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "huey", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "johndebugplus", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "misen", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "n", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "nxkoo", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "ruby", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "somecom", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "sleepy", category = "inscryption", joker = "j_hpfx_ijiraq", },
    { name = "srock", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "thedge", category = "inscryption", joker = "j_hpfx_ijiraq", },
    { name = "victin", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "winter", category = "inscryption", joker = "j_hpfx_chud", },
    -- Mod
    { name = "morefluff", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "ortalab", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "squidguset", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "steamodded", category = "inscryption", joker = "j_hpfx_chud", },
    { name = "vanillaremade", category = "inscryption", joker = "j_hpfx_chud", },
}

function Hyperfixation.inscryption_ui()
    rows = {}

    for _, entry in ipairs(Hyperfixation.inscryption_credits_table) do
        rows[#rows + 1] = Hyperfixation.generate_credits_desc_nodes(entry)
    end

    local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.BLACK },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				maxh = 6,
				r = 0.1,
			},
		},
		sync_mode = "progress",
	})

    return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", colour = G.C.L_BLACK, padding = 0.1, r = 0.1, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = scrollbox,
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					SMODS.GUI.scrollbar({
						h = 6,
						w = 0.3,
						max = 1,
						min = 0,
						colour = HEX("FCB3EA"),
						bg_colour = { 0, 0, 0, 0.15 },
						scroll_collision_obj = scrollbox,
					}),
				},
			},
		},
	}
end

--#endregion
--#region 4Fun Credits
function Hyperfixation.fourfun_ui()
    local modNodes = {}

    modNodes[#modNodes + 1] = {}
    local loc_vars = { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.4 }
    localize { type = 'descriptions', key = "hpfx_fourfun_credits", set = 'Other', nodes = modNodes[#modNodes], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
    modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
    modNodes[#modNodes].config.colour = loc_vars.background_colour or modNodes[#modNodes].config.colour

    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 6,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = modNodes
    }
end

--#endregion
--#region Other Help Credits
Hyperfixation.other_help_credits_table = {
    { name = "thedge", category = "other_help", joker = "j_hpfx_jolyne", },
    { name = "sweetiebabyhoneygravy", category = "other_help", joker = next(SMODS.find_mod("Incognito")) and "j_nic_tetoraq" or "j_hpfx_jolyne", },
}

function Hyperfixation.other_help_ui()
    rows = {}

    for _, entry in ipairs(Hyperfixation.other_help_credits_table) do
        rows[#rows + 1] = Hyperfixation.generate_credits_desc_nodes(entry)
    end

    local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.BLACK },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				maxh = 6,
				r = 0.1,
			},
		},
		sync_mode = "progress",
	})

    return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", colour = G.C.L_BLACK, padding = 0.1, r = 0.1, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = scrollbox,
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					SMODS.GUI.scrollbar({
						h = 6,
						w = 0.3,
						max = 1,
						min = 0,
						colour = HEX("FCB3EA"),
						bg_colour = { 0, 0, 0, 0.15 },
						scroll_collision_obj = scrollbox,
					}),
				},
			},
		},
	}
end

--#endregion
--#region bwuh Credits
function Hyperfixation.bwuh_ui()
    local modNodes = {}

    modNodes[#modNodes + 1] = {}
    local loc_vars = { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.4 }
    localize { type = 'descriptions', key = "hpfx_bwuh_credits", set = 'Other', nodes = modNodes[#modNodes], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
    modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
    modNodes[#modNodes].config.colour = loc_vars.background_colour or modNodes[#modNodes].config.colour

    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 6,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = modNodes
    }
end

--#endregion
SMODS.current_mod.extra_tabs = function() --Mod Tabs
    return {
        {
            label = 'Fortune',
            tab_definition_function = Hyperfixation.fortune_cookie_ui,
        },
        {
            label = 'Credits',
            tab_definition_function = Hyperfixation.credits_ui,
        },
    }
end
--#endregion
