SMODS.Joker {
    key = "adebayo",

    loc_txt = {
        name = "Bam Adebayo",
        text = {
            "Gives {C:chips}+#1#{} Chips"
        }
    },

    atlas = "placeholder",
    pos = { x = 2, y = 3 },

    rarity = 2,
    cost = 6,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            chips = 83
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}