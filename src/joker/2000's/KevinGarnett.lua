SMODS.Joker {
    key = "garnett",

    loc_txt = {
        name = "Kevin Garnett",
        text = {
            "{C:attention}Glass Cards{} cannot break",
            "{C:inactive}\"Anything is possible!\"{}"
        }
    },

    atlas = "placeholder",
    pos = { x = 1, y = 1 },

    rarity = 3,
    cost = 8,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.fix_probability
            and context.trigger_obj
            and SMODS.has_enhancement(
                context.trigger_obj,
                "m_glass"
            ) then

            return {
                numerator = 0
            }
        end
    end
}