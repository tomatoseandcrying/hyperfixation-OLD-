--new run vars
local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.fodder_card = { jkey = 'j_joker' }
    ret.wheel_fails = 0
    ret.hpfx_nothingEverHappens = true
    return ret
end

--set_card_rate() storing
local cardRateStoring = Game.start_run
function Game:start_run(args)
    local ret = cardRateStoring(self, args)
    Hyperfixation.og_cardrate = Hyperfixation.og_cardrate or {}
    Hyperfixation.daggercheck = Hyperfixation.daggercheck or {}
    return ret
end

--funny image shit i stole from Yahimod
local upd = Game.update
function Game:update(dt)
    upd(self, dt)

    -- tick based events
    if Hyperfixation.ticks == nil then Hyperfixation.ticks = 0 end
    if Hyperfixation.dtcounter == nil then Hyperfixation.dtcounter = 0 end
    Hyperfixation.dtcounter = Hyperfixation.dtcounter + dt
    Hyperfixation.dt = dt

    while Hyperfixation.dtcounter >= 0.010 do
        Hyperfixation.ticks = Hyperfixation.ticks + 1
        Hyperfixation.dtcounter = Hyperfixation.dtcounter - 0.010
        if G.shobitches and G.shobitches > 0 then G.shobitches = G.shobitches - 1 end
    end
end

--win unlocks
local needleUnlockCon = win_game
function win_game()
    local ret = needleUnlockCon()
    local _handname, _played = 'High Card', -1
    for hand_key, hand in pairs(G.GAME.hands) do
        if hand.played > _played then
            _played = hand.played
            _handname = hand_key
        end
    end
    local most_played = _handname
    local handd = G.GAME.hands[most_played]
    if handd.level == 1 and most_played ~= 'None' then
        if handd.played ~= nil and handd.played >= 1 then
            check_for_unlock({ type = 'hpfx_needle' })
        end
    end
    return ret
end

local bitchlessUnlockCon = win_game
function win_game()
    local ret = bitchlessUnlockCon()
    if G.PROFILES[G.SETTINGS.profile].hpfx_bitch == false then
        check_for_unlock({ type = 'hpfx_no_bitches' })
    end
    return ret
end

--jokester translogic
function SMODS.current_mod.reset_game_globals(run_start)
    for _, card in ipairs(G.jokers.cards) do
        if card.isIjiraq or
            Hyperfixation.exceptions[G.GAME.current_round.fodder_card.jkey] and
            not card.config.center.key == 'j_hpfx_ijiraq' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.P_CENTERS.j_hpfx_costume:set_ability(card)
                    play_sound("card1")
                    card:juice_up(0.3, 0.3)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    return true
                end
            }))
        end
    end
end

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start or G.GAME.round_resets.blind_states.Boss == "Defeated" then
        -- Joker pool logic
        local ijiraq_pool = get_current_pool("Joker")
        local filtered_pool = {}
        for _, key in ipairs(ijiraq_pool) do
            if not Hyperfixation.brokejokes[key] then
                table.insert(filtered_pool, key)
            end
        end
        local jokester = pseudorandom_element(filtered_pool, pseudoseed('ijiraq'))
        ---@diagnostic disable-next-line: cast-local-type
        if jokester and jokester == 'UNAVAILABLE' then jokester = 'j_joker' end
        G.GAME.current_round.fodder_card.jkey = jokester or 'j_joker'
        --Double Trouble
        local forbidden_keys = { "bl_hpfx_double_trouble", "bl_big", "bl_small" }

        local function is_forbidden(blind)
            return blind.key and Hyperfixation.table.contains(forbidden_keys, blind.key)
        end

        local idx1, idx2
        repeat
            idx1 = pseudorandom_element(G.P_BLINDS, "hpfx_double_trouble")
        until idx1 and not is_forbidden(idx1)

        repeat
            idx2 = pseudorandom_element(G.P_BLINDS, "hpfx_double_trouble_2")
        until idx2 and idx2 ~= idx1 and not is_forbidden(idx2)

        Hyperfixation.hpfxDT_idx1 = idx1
        Hyperfixation.hpfxDT_idx2 = idx2
        if run_start then
            -- Ijiraq
            G.GAME.raqeffects = {}
            Hyperfixation.trig = {}
            -- Egg?
            local chick = pseudorandom('hpfxchicken', 3, 123456789)
            Hyperfixation.nugget = roundmyshitprettyplease(chick, 3)
            -- No Bitches
            local bitchxl = 0
            G.PROFILES[G.SETTINGS.profile].hpfx_bitch = false
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 12 then
                    bitchxl = bitchxl + 1
                end
            end
            Hyperfixation.bitchXM = bitchxl
        end
    end
end

--custom logo i definitely did not steal from Maximus :eyes:
local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
    local ret = oldfunc(change_context)

    if Hyperfixation.current_mod.config.menu then
        local SC_scale = 1.1 * (G.debug_splash_size_toggle and 0.8 or 1)
        G.SPLASH_HPFX_LOGO = Sprite(0, 0,
            6 * SC_scale,
            6 * SC_scale * (G.ASSET_ATLAS["hpfx_logo"].py / G.ASSET_ATLAS["hpfx_logo"].px),
            G.ASSET_ATLAS["hpfx_logo"], { x = 0, y = 0 }
        )
        G.SPLASH_HPFX_LOGO:set_alignment({
            major = G.title_top,
            type = 'cm',
            bond = 'Strong',
            offset = { x = 0, y = 3 }
        })
        G.SPLASH_HPFX_LOGO:define_draw_steps({ {
            shader = 'dissolve',
        } })

        G.SPLASH_HPFX_LOGO.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }

        G.SPLASH_HPFX_LOGO.dissolve_colours = { Hyperfixation.C.HPFX_PRIMARY, Hyperfixation.C.HPFX_SECONDARY }
        G.SPLASH_HPFX_LOGO.dissolve = 1

        G.SPLASH_HPFX_LOGO.states.collide.can = true

        function G.SPLASH_HPFX_LOGO:click()
            play_sound('button', 1, 0.3)
            play_sound('hpfx_faaaah', 1, 0.8)
        end

        function G.SPLASH_HPFX_LOGO:hover()
            G.SPLASH_HPFX_LOGO:juice_up(0.05, 0.03)
            play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)
            Node.hover(self)
        end

        function G.SPLASH_HPFX_LOGO:stop_hover() Node.stop_hover(self) end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = change_context == 'splash' and 3.6 or change_context == 'game' and 4 or 1,
            blockable = false,
            blocking = false,
            func = (function()
                play_sound('magic_crumple' .. (change_context == 'splash' and 2 or 3),
                    (change_context == 'splash' and 1 or 1.3), 0.9)
                play_sound('whoosh1', 0.2, 0.8)
                ease_value(G.SPLASH_HPFX_LOGO, 'dissolve', -1, nil, nil, nil,
                    change_context == 'splash' and 2.3 or 0.9)
                G.VIBRATION = G.VIBRATION + 1.5
                return true
            end)
        }))

        local newcard = create_card('Joker', G.title_top, nil, nil, nil, nil, 'j_hpfx_jolyne', 'toma')

        G.title_top.T.w = G.title_top.T.w * 1.7675
        G.title_top.T.x = G.title_top.T.x - 0.8
        G.title_top:emplace(newcard)

        newcard.T.w = newcard.T.w * 1.1 * 1.2
        newcard.T.h = newcard.T.h * 1.1 * 1.2
        newcard.no_ui = true
        newcard.states.visible = false

        G.SPLASH_BACK:define_draw_steps({ {
            shader = 'splash',
            send = {
                { name = 'time',       ref_table = G.TIMERS,        ref_value = 'REAL_SHADER' },
                { name = 'vort_speed', val = 0.4 },
                { name = 'colour_1',   ref_table = Hyperfixation.C, ref_value = 'HPFX_PRIMARY' },
                { name = 'colour_2',   ref_table = Hyperfixation.C, ref_value = 'HPFX_SECONDARY' },
            }
        } })

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0,
            blockable = false,
            blocking = false,
            func = function()
                if change_context == "splash" then
                    newcard.states.visible = true
                    newcard:start_materialize({ G.C.WHITE, Hyperfixation.C.HPFX_SECONDARY }, true, 2.5)
                else
                    newcard.states.visible = true
                    newcard:start_materialize({ G.C.WHITE, Hyperfixation.C.HPFX_SECONDARY }, nil, 1.2)
                end
                return true
            end,
        }))
    end
    return ret
end
local update_hook = Game.update
function Game:update(dt)
    update_hook(self, dt)
    if Hyperfixation and Hyperfixation.masdet then
        Hyperfixation.updatecollectionitems()
    end
    for _, card in pairs(G.I.CARD) do
        if card.config and card.config.center and card.config.center.hpfx_old_art_pos and card.children and card.children.center and card.config.center.discovered == true then
            local center = card.config.center
            local c_pos = Hyperfixation.current_mod.config.rebirth and center.pos or center.hpfx_old_art_pos
            card.children.center:set_sprite_pos(c_pos)
            if card.children.front and center.soul_pos and center.hpfx_old_art_soul_pos and card.config.center.discovered == true then
                local s_pos = Hyperfixation.current_mod.config.rebirth and center.soul_pos or
                    center.hpfx_old_art_soul_pos
                card.children.front:set_sprite_pos(s_pos)
            end
        end
    end
end

local masdet = Game.splash_screen
function Game:splash_screen()
    masdet(self)
    Hyperfixation.masdet = true
    if Hyperfixation then
        for _, v in ipairs(G.P_CENTER_POOLS.Joker) do
            Hyperfixation.no_collection[v.key] = v.no_collection
        end
    end
    Hyperfixation.updatecollectionitems()
end
