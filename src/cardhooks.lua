--card drag custom context
local ref_card_update = Card.update
function Card:update(dt)
    local ret = ref_card_update(self, dt)

    if not self.area then
        self.hpfx_current_area = nil
        return
    elseif self.area and not self.hpfx_current_area then
        self.hpfx_current_area = self.area
        self.hpfx_current_cards = {}
    end

    local joker_idx = 1
    local size_changed = #self.area.cards ~= #self.hpfx_current_cards
    local order_changed = false

    for i, v in ipairs(self.area.cards) do
        if v == self then
            joker_idx = i
            if order_changed then
                break
            end
        end

        if not order_changed and v.ID ~= self.hpfx_current_cards[i] then
            order_changed = true
        end
    end

    -- don't do potentially expensive sprite creation if nothing has changed
    if not size_changed and not order_changed and self.hpfx_current_area == self.area and joker_idx == self.hpfx_last_index then
        return
    end

    local eval = eval_card(self,
        { card_pos_changed = true, new_pos = joker_idx, order_changed = true, size_changed = true })
    SMODS.trigger_effects({ eval }, self)

    self.hpfx_current_area = self.area
    self.hpfx_current_cards = {}
    for i = 1, #self.area.cards do
        self.hpfx_current_cards[i] = self.area.cards[i].ID
    end
    self.hpfx_last_index = joker_idx

    return ret
end

--jokester flip anim
local calc_Ref = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = calc_Ref(self, context)
    if ret and self.isIjiraq then
        self.isIjiraq = false
        G.E_MANAGER:add_event(Event({
            func = function()
                self:Transfodd(context)
                return true
            end
        }))
    end
    if context.setting_blind and self.isIjiraq then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                play_sound("card1")
                self:juice_up(0.3, 0.3)
                return true
            end,
        }))
    end
    return ret
end

--jokester auto descs
local stupidRef = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ihatethis = nil
    local changed = false
    if card and (card.config.center and card.config.center.key == _c.key) and card.visiblyIjiraq then
        ihatethis = G.localization.descriptions[_c.set][_c.key]['name']
        ihatethis = ihatethis .. '{C:hpfx_IjiGray}...?{}'
        G.localization.descriptions[_c.set][_c.key]['name'] = ihatethis
        desc = G.localization.descriptions[_c.set][_c.key]['text']
        desc[#desc] = desc[#desc] .. "{C:hpfx_IjiGray}...?{}"
        G.localization.descriptions[_c.set][_c.key]['text'] = desc
        changed = true
        init_localization()
    end
    local hatethisonethemost = stupidRef(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start,
        main_end, card)
    if changed then
        if type(ihatethis) == "string" and #ihatethis >= 22 then
            ihatethis = ihatethis:sub(1, #ihatethis - 22)
        end                                                      --22 is the exact length of the string "{C:hpfx_IjiGray}...?{}", change this only if you change the string's length
        G.localization.descriptions[_c.set][_c.key]['name'] = ihatethis
        desc[#desc] = desc[#desc]:sub(1, desc[#desc]:len() - 22) --same here but with "{C:hpfx_IjiGray,s:0.7}...?{}"
        G.localization.descriptions[_c.set][_c.key]['text'] = desc
        init_localization()
    end
    return hatethisonethemost
end

--astro? func/iji-astro func
local card_set_cost_ref = Card.set_cost
function Card:set_cost()
    card_set_cost_ref(self)
    if next(SMODS.find_card("j_hpfx_galilimbo")) then
        if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')) then self.cost = 0 end
        self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
    if G.GAME.raqeffects then
        for _, v in pairs(G.GAME.raqeffects) do
            local found = false
            if v == 'j_astronomer' then
                found = true
            end
            if next(SMODS.find_card("j_hpfx_ijiraq")) and found == true then
                if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')) then self.cost = 0 end
                self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
                self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
            end
        end
    end
end

--jokester sticker appl/isaac unlock
local add2deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    if self.isIjiraq then
        self.visiblyIjiraq = true
        self:add_sticker('hpfx_priceless')
    end
    if self.config.center_key == 'j_oops' then --surprise unlock condition lmao
        check_for_unlock({ type = 'hpfx_oops' })
    end
    add2deck_ref(self, from_debuff)
end

--SHED toggle logic
local highlightschmilight = Card.highlight
function Card:highlight(is_higlighted)
    local ret = highlightschmilight(self, is_higlighted)
    self.highlighted = is_higlighted
    local key = self.config.center.key
    local owned = self.area and self.area == G.jokers and self.ability.set == 'Joker'
    if owned and key == 'j_hpfx_perknado' and key ~= 'j_hpfx_ijiraq' then
        if self.highlighted then
            if self.children.toggle_button then
                self.children.toggle_button:remove()
                self.children.toggle_button = nil
            end
        else
            if not self.children.toggle_button then
                local perkpopper = {
                    n = G.UIT.ROOT,
                    config = {
                        ref_table = self,
                        align = 'bm',
                        padding = 0.05,
                        r = 0.08,
                        maxw = G.CARD_W,
                        hover = true,
                        shadow = true,
                        colour = G.C.DARK_EDITION,
                        one_press = false,
                        button = 'hpfx_Perktoggle',
                        func = 'hpfx_Perkcheck',
                        minh = 0.6,
                        instance_type = "UIBOX"
                    },
                    nodes = { {
                        n = G.UIT.T,
                        config = {
                            text = localize('hpfx_perknado'),
                            colour = G.C.WHITE,
                            scale = 0.45,
                            shadow = false
                        }
                    } }
                }
                self.children.toggle_button = UIBox {
                    definition = perkpopper,
                    config = {
                        align = 'bm', offset = { x = 0, y = -0.3 },
                        major = self, bond = 'Weak', parent = self,
                    }
                }
            end
        end
    elseif owned and key == 'j_hpfx_ijiraq' and not self.highlighted then
        if self.children.toggle_button then
            self.children.toggle_button:remove()
            self.children.toggle_button = nil
        end
    end

    return ret
end

-- priceless func/iji-lucha trolling
local nosell_hook = Card.can_sell_card
function Card:can_sell_card(context)
    local key = self.config.center.key
    nosell_hook(self, context)
    local found = false
    if G.GAME.raqeffects then
        for _, v in pairs(G.GAME.raqeffects) do
            if v == 'j_luchador' then found = true end
        end
    end
    if self.ability.hpfx_priceless then
        return false
    else
        if key == 'j_hpfx_ijiraq' and found == true then
            if G.GAME.blind and not G.GAME.blind.boss then
                return false
            end
        end
        return true
    end
end

--Perma-Boulder

local boulder_lock = Card.set_ability
function Card:set_ability(center, initial, delay_sprites, ...)
    if G.STAGE and G.STAGE == G.STAGES.RUN and self.config.center.key == 'm_hpfx_boulder' then
        center = 'm_hpfx_boulder'
    end
    return boulder_lock(self, center, initial, delay_sprites, ...)
end

--Decrease spawn rate of Jokesters