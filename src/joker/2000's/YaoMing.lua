local Yao = SMODS.Joker {
    key = "Yao",

    loc_txt = {
        name = "Yao Ming",
        text = {
            "May play up to {C:attention}6{} cards",
            "If {C:attention}6{} are played, all score",
            "{C:inactive}(Flush Five + 1: all 6 score){}",
            "{C:inactive}(Two 3OAKs: Full House; all 6 score){}"
        }
    },

    atlas = "placeholder",
    pos = { x = 3, y = 1 },

    rarity = 2,
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,

    calculate = function(self, card, context)
        -- If six cards were played, every card becomes a scoring card.
        if context.modify_scoring_hand
            and context.other_card
            and context.full_hand
            and #context.full_hand == 6 then

            return {
                add_to_hand = true
            }
        end
    end
}

-- Checks whether an active, non-debuffed Yao is owned.
local function yao_is_active()
    if not G.jokers or not G.jokers.cards then
        return false
    end

    for _, joker in ipairs(G.jokers.cards) do
        local center = joker.config and joker.config.center

        if center
            and (center == Yao or center.key == Yao.key)
            and not joker.debuff then

            return true
        end
    end

    return false
end

-- Balatro normally stops highlighting cards after the fifth card.
-- This wrapper permits a sixth card while Yao is active.
local original_add_to_highlighted = CardArea.add_to_highlighted

function CardArea:add_to_highlighted(highlighted_card, silent)
    if self == G.hand
        and yao_is_active()
        and #self.highlighted == 5 then

        self.highlighted[#self.highlighted + 1] = highlighted_card
        highlighted_card:highlight(true)

        if not silent then
            play_sound("cardSlide1", 0.85, 1)
        end

        if G.STATE == G.STATES.SELECTING_HAND then
            self:parse_highlighted()
        end

        return
    end

    return original_add_to_highlighted(
        self,
        highlighted_card,
        silent
    )
end

-- Balatro's Play button normally rejects more than five cards.
-- The sixth card is temporarily hidden from that limit check.
local original_can_play = G.FUNCS.can_play

G.FUNCS.can_play = function(e)
    if yao_is_active()
        and G.hand
        and #G.hand.highlighted == 6 then

        local sixth_card = table.remove(G.hand.highlighted, 6)
        local result = original_can_play(e)

        table.insert(G.hand.highlighted, sixth_card)

        return result
    end

    return original_can_play(e)
end