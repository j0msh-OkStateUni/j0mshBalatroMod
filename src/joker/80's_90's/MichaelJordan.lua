SMODS.Joker {
    key = "jordan",

    loc_txt = {
        name = "Michael Jordan",
        text = {
            "If ranks of all scored cards",
            "total exactly {C:attention}#1#{},",
            "gives {X:mult,C:white}X#2#{} Mult"
        }
    },

    atlas = "placeholder",
    pos = { x = 3, y = 0 },

    rarity = 3,
    cost = 10,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            target_total = 23,
            xmult = 6
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.target_total,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local rank_total = 0

            for _, played_card in ipairs(context.full_hand or {}) do
                -- Stone Cards and other rankless cards cannot qualify
                if SMODS.has_no_rank(played_card) then
                    return
                end

                rank_total = rank_total + played_card:get_id()
            end

            if rank_total == card.ability.extra.target_total then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}