SMODS.Joker {
    key = "johnson",

    loc_txt = {
        name = "Magic Johnson",
        text = {
            "Each scoring card assists the next",
            "Scoring cards after the first",
            "give {X:mult,C:white}X#1#{} Mult"
        }
    },

    atlas = "placeholder",
    pos = { x = 2, y = 0 },

    rarity = 3,
    cost = 9,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 1.32
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual
            and context.cardarea == G.play
            and context.other_card then

            local scoring_position = nil

            -- Find this card's position within the scoring hand
            for position, scoring_card in ipairs(
                context.scoring_hand or {}
            ) do
                if scoring_card == context.other_card then
                    scoring_position = position
                    break
                end
            end

            -- The first card starts the passing chain.
            -- Every card after it receives the assist.
            if scoring_position and scoring_position > 1 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}