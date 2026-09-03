SMODS.Joker {
    key = "Curry",

    loc_txt = {
        name = "Steph Curry",
        text = {
            "Each scored card without a {C:attention}Seal{}",
            "has a {C:green}#1# in #2#{} chance to",
            "gain a {C:money}Gold Seal{}"
        }
    },

    atlas = "placeholder",
    pos = { x = 3, y = 2 },

    rarity = 3,
    cost = 9,

    config = {
        extra = {
            chance = 4,
            odds = 10
        }
    },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        -- Adds the Gold Seal explanation to the tooltip
        info_queue[#info_queue + 1] = G.P_SEALS.Gold

        return {
            vars = {
                G.GAME.probabilities.normal
                    * card.ability.extra.chance,
                card.ability.extra.odds
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual
            and context.cardarea == G.play
            and context.other_card
            and not context.other_card.seal then

            local chance =
                G.GAME.probabilities.normal
                * card.ability.extra.chance
                / card.ability.extra.odds

            if pseudorandom("curry_gold_seal") < chance then
                context.other_card:set_seal("Gold", nil, true)

                return {
                    message = "Gold!",
                    colour = G.C.GOLD,
                    message_card = context.other_card
                }
            end
        end
    end
}