SMODS.Joker({
    key = 'squirrel',
    atlas = 'InscryptionJokers',
    pos = { x = 0, y = 2 },
    soul_pos = {
        x = 1,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, nil, nil, 0.1)
            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, nil)

            card.children.floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, rotate_mod, nil, 0.1)
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    config = { extra = { mult = 1 } },
    rarity = 1,
    cost = 1,
    no_collection = true,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    hpfx_priceless_compat = false,
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children.hpfx_floating_sprite =
                Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                    G.ASSET_ATLAS[card.config.center.atlas], {
                        x = 1,
                        y = 1
                    })
            card.children.hpfx_floating_sprite.role.draw_major = card
            card.children.hpfx_floating_sprite.states.hover.can = false
            card.children.hpfx_floating_sprite.states.click.can = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('hpfx_cabin'), G.C.BLACK, HEX("F97717"), 1.2)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = true }
    end

})
SMODS.Joker({
    key = 'blackgoat',
    atlas = 'InscryptionJokers',
    pos = { x = 0, y = 2 },
    soul_pos = {
        x = 2,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, nil, nil, 0.1)
            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, nil)

            card.children.floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, rotate_mod, nil, 0.1)
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    config = { extra = { deaths = 3 } },
    rarity = 1,
    cost = 1,
    no_collection = true,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    hpfx_priceless_compat = false,
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children.hpfx_floating_sprite =
                Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                    G.ASSET_ATLAS[card.config.center.atlas], {
                        x = 2,
                        y = 1
                    })
            card.children.hpfx_floating_sprite.role.draw_major = card
            card.children.hpfx_floating_sprite.states.hover.can = false
            card.children.hpfx_floating_sprite.states.click.can = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.deaths } }
    end,
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('hpfx_cabin'), G.C.BLACK, HEX("F97717"), 1.2)
    end,
    calculate = function(self, card, context)
        if context.check_eternal then
            if card.ability.extra.deaths > 1 then
                card.ability.extra.deaths = card.ability.extra.deaths - 1
                card:juice_up(0.8, 0.8)
                return { no_destroy = { override_compat = true } }
            else
                return { no_destroy = false }
            end
        end
        if card.getting_sliced then
            SMODS.calculate_context({ check_eternal = true }, card)
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = true }
    end

})
SMODS.Joker({
    key = 'frozenopossum',
    atlas = 'InscryptionJokers',
    pos = { x = 0, y = 2 },
    soul_pos = {
        x = 3,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, nil, nil, 0.1)
            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, nil)

            card.children.floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, rotate_mod, nil, 0.1)
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    rarity = 2,
    cost = 10,
    config = { trig = false },
    no_collection = true,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    hpfx_priceless_compat = false,
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children.hpfx_floating_sprite =
                Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                    G.ASSET_ATLAS[card.config.center.atlas], {
                        x = 3,
                        y = 1
                    })
            card.children.hpfx_floating_sprite.role.draw_major = card
            card.children.hpfx_floating_sprite.states.hover.can = false
            card.children.hpfx_floating_sprite.states.click.can = false
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('hpfx_cabin'), G.C.BLACK, HEX("F97717"), 1.2)
    end,
    add_to_deck = function(self, card, from_debuff)
        card:add_sticker('hpfx_priceless')
    end,
    calculate = function(self, card, context)
        if card.getting_sliced and card.ability.trig == false then
            card:juice_up(0.8, 0.8)
            SMODS.add_card {
                set = 'Joker',
                key = 'j_hpfx_opossum',
                key_append = 'hpfx_possumblock'
            }
            card.ability.trig = true
            return { no_destroy = false }
        end
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = true }
    end

})
SMODS.Joker({
    key = 'opossum',
    atlas = 'InscryptionJokers',
    pos = { x = 0, y = 2 },
    soul_pos = {
        x = 4,
        y = 0,
        draw = function(card, scale_mod, rotate_mod)
            scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) *
                    math.pi * 14) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, nil, nil, 0.1)
            card.children.hpfx_floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, nil)

            card.children.floating_sprite:draw_shader('dissolve',
                0, nil, nil, card.children.center, scale_mod, rotate_mod, nil, 0.1)
            card.children.floating_sprite:draw_shader('dissolve',
                nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    },
    config = { extra = { chips = 10, mult = 1 } },
    rarity = 1,
    cost = 0,
    no_collection = true,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    hpfx_priceless_compat = false,
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children.hpfx_floating_sprite =
                Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                    G.ASSET_ATLAS[card.config.center.atlas], {
                        x = 4,
                        y = 1
                    })
            card.children.hpfx_floating_sprite.role.draw_major = card
            card.children.hpfx_floating_sprite.states.hover.can = false
            card.children.hpfx_floating_sprite.states.click.can = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    in_pool = function(self, args)
        return false, { allow_duplicates = true }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end,
})
