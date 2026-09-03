local function count_scoring_tens(scoring_hand)
    local number_of_tens = 0

    for _, playing_card in ipairs(scoring_hand or {}) do
        if playing_card:get_id() == 10 then
            number_of_tens = number_of_tens + 1
        end
    end

    return number_of_tens
end


SMODS.Joker {
    key = "westbrook",

    loc_txt = {
        name = "Russell Westbrook",
        text = {
            "If scoring hand contains at least",
            "{C:attention}#1# 10s{}, each scored {C:attention}10{}",
            "gives {X:mult,C:white}X#2#{} Mult"
        }
    },

    atlas = "placeholder",

    -- Row 3, column 1 of your spreadsheet
    pos = { x = 0, y = 2 },

    config = {
        extra = {
            tens_required = 3,
            xmult = 2
        }
    },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.tens_required,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual
            and context.cardarea == G.play
            and context.other_card
            and context.other_card:get_id() == 10
            and count_scoring_tens(context.scoring_hand)
                >= card.ability.extra.tens_required then

            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}