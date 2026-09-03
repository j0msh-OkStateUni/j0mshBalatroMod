local function make_big(value)
    if type(to_big) == "function" then
        return to_big(value)
    end

    return value
end


SMODS.Joker {
    key = "gilgeous-alexander",

    loc_txt = {
        name = "Shai Gilgeous-Alexander",
        text = {
            "Gains {C:mult}+#2#{} Mult after a hand",
            "scores at least {C:attention}#3#%{} of the Blind",
            "Resets if it scores less",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },

    atlas = "placeholder",
    pos = { x = 0, y = 3 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            current_mult = 0,
            mult_gain = 2,
            required_percent = 20
        }
    },

    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra

        return {
            vars = {
                extra.current_mult,
                extra.mult_gain,
                extra.required_percent
            }
        }
    end,

    calculate = function(self, card, context)
        local extra = card.ability.extra

        -- Provide the Mult accumulated from previous hands
        if context.joker_main and extra.current_mult > 0 then
            return {
                mult = extra.current_mult
            }
        end

        -- Check the score after the current hand finishes
        if context.after
            and context.main_eval
            and not context.blueprint then

            local hand_score =
                make_big(SMODS.last_hand_score or 0)

            local required_score =
                make_big(G.GAME.blind.chips)
                * make_big(extra.required_percent / 100)

            if hand_score >= required_score then
                extra.current_mult =
                    extra.current_mult + extra.mult_gain

                return {
                    message = "+" .. extra.mult_gain .. " Mult",
                    colour = G.C.MULT
                }
            elseif extra.current_mult > 0 then
                extra.current_mult = 0

                return {
                    message = "Reset!",
                    colour = G.C.RED
                }
            end
        end
    end
}