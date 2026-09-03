SMODS.Joker {
    key = "shaq",

    loc_txt = {
        name = "Shaquille O'Neal",
        text = {
            "{C:attention}Boss Blinds{} require",
            "{C:chips}50% fewer Chips{}"
        }
    },

    atlas = "placeholder",

    pos = { x = 4, y = 0 },

    config = {
        extra = {
            blind_multiplier = 0.5
        }
    },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,

    -- Prevents Blueprint from halving it again
    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.setting_blind
            and context.blind
            and context.blind.boss then

            return {
                xblindsize = card.ability.extra.blind_multiplier,
                message = "Dunked!"
            }
        end
    end
}