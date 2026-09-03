SMODS.Joker {
    key = "tatum",

    loc_txt = {
        name = "Jayson Tatum",
        text = {
            "Every {C:attention}7th{} hand played",
            "gives {C:mult}+#1#{} Mult",
            "{C:attention}#2#{}"
        }
    },

    atlas = "placeholder",
    pos = { x = 1, y = 3 },

    rarity = 2,
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            mult = 51,
            hands_remaining = 6,
            active = false
        }
    },

    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra
        local status

        if extra.active then
            status = "Active!"
        elseif extra.hands_remaining == 1 then
            status = "1 hand remaining"
        else
            status = extra.hands_remaining .. " hands remaining"
        end

        return {
            vars = {
                extra.mult,
                status
            }
        }
    end,

    calculate = function(self, card, context)
        local extra = card.ability.extra

        -- Apply +51 Mult when the countdown is complete
        if context.joker_main and extra.active then
            return {
                mult = extra.mult
            }
        end

        -- Update the countdown after each hand
        if context.after and not context.blueprint then
            if extra.active then
                -- The active hand was just used
                extra.active = false
                extra.hands_remaining = 6
            else
                extra.hands_remaining =
                    extra.hands_remaining - 1

                if extra.hands_remaining <= 0 then
                    extra.hands_remaining = 0
                    extra.active = true

                    return {
                        message = "Active!",
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end
}