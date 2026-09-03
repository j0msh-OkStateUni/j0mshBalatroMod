SMODS.Joker {
    key = "Jokic",

    loc_txt = {
        name = "Nikola Jokic",
        text = {
            "Earn {C:money}$#1#{} whenever",
            "another Joker triggers"
        }
    },

    atlas = "placeholder",
    pos = { x = 4, y = 3 },

    rarity = 3,
    cost = 9,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            dollars = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        local original_context = context.other_context or {}

        if context.post_trigger
            and context.other_card
            and context.other_card ~= card
            and context.other_ret
            and context.other_card.ability
            and context.other_card.ability.set == "Joker"
            and not original_context.post_trigger then

            return {
                dollars = card.ability.extra.dollars
            }
        end
    end
}