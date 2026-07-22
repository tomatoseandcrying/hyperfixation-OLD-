--Boulder in a Bottle
SMODS.Consumable({
    key = 'act1_boulderbottle',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 1,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    config = { extra = { boulders = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.boulders } }
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.boulders do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Base', enhancement = 'm_hpfx_boulder' })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return G.hand and is_in_blind
    end
})

--Squirrel in a Bottle
SMODS.Consumable({
    key = 'act1_squirrelbottle',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 2,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    config = { extra = { squirrels = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.squirrels } }
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.squirrels do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', key = 'j_hpfx_squirrel' })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards >= 0
    end
})

--Special Dagger
SMODS.Consumable({
    key = 'act1_specialdagger',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 3,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('timpani')
        G.GAME.chips = G.GAME.chips + math.floor(0.4 * G.GAME.blind.chips)
        G.GAME.chips_text = number_format(G.GAME.chips_text)
        delay(0.6)
        local function wrightworthJokers()
            local jpool = (G.jokers and G.jokers.cards) or {}
            local jn = #jpool
            local jcount = math.floor(jn / 2)
            --Shouldn't happen since can_use checks for >=0, but just in case yk?
            if jcount <= 0 then return {} end
            local selected = {}
            for i = jn - jcount + 1, jn do
                table.insert(selected, jpool[i])
            end
            return selected
        end
        local victims = wrightworthJokers()
        for _, j in pairs(victims) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    j:juice_up(0.3, 0.5)
                    SMODS.debuff_card(j, true, 'hpfx_daggered')
                    return true
                end
            }))
        end
        table.insert(Hyperfixation.daggercheck, 'cookie_clicker')
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return G.jokers and is_in_blind and #G.jokers.cards > 0
    end,
    in_pool = function(self)
        local no_pliers = true
        if next(SMODS.find_card('c_hpfx_act1_pliers', true)) then no_pliers = false end
        return no_pliers
    end
})

--Scissors
SMODS.Consumable({
    key = 'act1_scissors',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 4,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('slice1', 0.96 + math.random() * 0.08)
        G.GAME.blind.chips = math.floor(G.GAME.blind.chips - G.GAME.blind.chips * 0.5)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        delay(0.6)
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return is_in_blind and not G.GAME.blind.boss and G.GAME.blind.chips > 0
    end,
})

--Pliers
SMODS.Consumable({
    key = 'act1_pliers',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 5,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('timpani')
        G.GAME.chips = G.GAME.chips + math.floor(0.1 * G.GAME.blind.chips)
        G.GAME.chips_text = number_format(G.GAME.chips_text)
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(-10, true)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return is_in_blind
    end,
    in_pool = function(self)
        local no_dagger = true
        if next(SMODS.find_card('c_hpfx_act1_specialdagger', true)) then no_dagger = false end
        return no_dagger
    end
})

--Hoggy Bank
--[[ SMODS.Consumable({
    key = 'act1_hoggybank',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 6,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('timpani')
        SMODS.set_scoring_calculation('hpfx_hog_multiply')
        Hyperfixation.usedHoggy = true
        delay(0.6)
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return is_in_blind
    end,
})
SMODS.Scoring_Parameter({
    key = 'hoggy_bank',
    default_value = 4,
    colour = G.C.BLUE,
    calculation_keys = { 'hoggy' },
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
        if not SMODS.Calculation_Controls.chips then return end
        if amount then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(self.current * amount)
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize {
                    type = 'variable',
                    key = amount > 0 and 'a_chips' or 'a_chips_minus',
                    vars = { 'X' .. amount }
                },
                colour = self.colour
            })
            return true
        end
    end
})
SMODS.Scoring_Calculation({
    key = 'hog_multiply',
    func = function(self, chips, mult, flames)
        return chips * SMODS.get_scoring_parameter('hpfx_hoggy_bank')
    end,
    parameters = { 'chips', 'mult', 'hpfx_hoggy_bank' },
    replace_ui = function(self)
        local scale = 0.3
        return
        {
            n = G.UIT.R,
            config = { align = "cm", minh = 1, padding = 0.1 },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = 'cm', id = 'hand_chips' },
                    nodes = {
                        SMODS.GUI.score_container({
                            type = 'chips',
                            text = 'chip_text',
                            align = 'cr',
                            w = 1.1,
                            scale = scale
                        })
                    }
                },
                SMODS.GUI.operator(scale * 0.75),
                {
                    n = G.UIT.C,
                    config = { align = 'cm', id = 'hand_hpfx_hoggy_bank' },
                    nodes = {
                        SMODS.GUI.score_container({
                            type = 'hpfx_hoggy_bank',
                            align = 'cm',
                            w = 1.1,
                            scale = scale
                        })
                    }
                },
                SMODS.GUI.operator(scale * 0.75),
                {
                    n = G.UIT.C,
                    config = { align = 'cm', id = 'hand_mult' },
                    nodes = {
                        SMODS.GUI.score_container({
                            type = 'mult',
                            align = 'cl',
                            w = 1.1,
                            scale = scale
                        })
                    }
                },
            }
        }
    end
}) ]]

--Hourglass
SMODS.Consumable({
    key = 'act1_hourglass',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 7,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('timpani')
        ease_hands_played(1)
        delay(0.6)
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return is_in_blind
    end,
})

--Goobert
SMODS.Consumable({
    key = 'act1_goobert',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 8,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    use = function(self, card, area, copier)
        play_sound('timpani')
        delay(0.6)
    end,
    can_use = function(self, card)
        return false
    end,
})

--Black Goat in a Bottle
SMODS.Consumable({
    key = 'act1_blackgoatbottle',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 9,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    config = { extra = { goats = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.goats } }
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.goats do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', key = 'j_hpfx_blackgoat' })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards >= 0
    end
})

--Frozen Opossum in a Bottle
SMODS.Consumable({
    key = 'act1_frozenopossumbottle',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 10,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.05 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1Items',
    config = { extra = { possums = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.possums } }
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.possums do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', key = 'j_hpfx_frozenopossum' })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards >= 0
    end
})

--Harpie's Birdleg Fan
SMODS.Consumable({
    key = 'act1_harpiebirdlegfan',
    set = 'hpfx_inscr_act1_items',
    pos = { x = 0, y = 0 },
    soul_pos = {
        x = 1,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.005 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    atlas = 'InscryptionAct1ItemsBL',
    use = function(self, card, area, copier)
        play_sound('timpani')
        local currentjokers = {}
        if G.jokers then
            for _, j in pairs(G.jokers.cards) do
                currentjokers[#currentjokers + 1] = j
            end
        end
        for _, j in pairs(currentjokers) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    SMODS.debuff_card(j, "prevent_debuff", 'hpfx_airborne')
                    SMODS.recalc_debuff(j)
                    j:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        local is_in_blind = G.GAME.blind.in_blind
        return is_in_blind
    end,
})
