SMODS.Joker {
    key = "Bird",

    loc_txt = {
        name = "Larry Bird",
        text = {
            "Scored {C:attention}5s{} give {C:chips}+#1#{} Chips,",
            "scored {C:attention}4s{} give {C:mult}+#2#{} Mult,",
            "scored {C:attention}9s{} give",
            "{X:mult,C:white}X#3#{} Mult"
        }
    },

    atlas = "placeholder",
    pos = { x = 1, y = 0 },

    config = {
        extra = {
            chips = 5,
            mult = 4,
            xmult = 1.9
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
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual
            and context.cardarea == G.play
            and context.other_card then

            local rank = context.other_card:get_id()

            if rank == 5 then
                return {
                    chips = card.ability.extra.chips
                }
            end

            if rank == 4 then
                return {
                    mult = card.ability.extra.mult
                }
            end

            if rank == 9 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}