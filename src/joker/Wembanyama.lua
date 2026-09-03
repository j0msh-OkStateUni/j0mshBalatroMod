local function make_big(value)
    if type(to_big) == "function" then
        return to_big(value)
    end

    return value
end

local function make_number(value)
    if type(to_number) == "function" then
        return to_number(value)
    end

    return value
end


SMODS.Joker {
    key = "wembanyama",

    loc_txt = {
        name = "Victor Wembanyama",
        text = {
            "If played hand scores over",
            "{C:attention}Blind requirement / hands remaining{},",
            "reduce it to that amount",
            "{C:inactive}(rounded to the nearest whole number)"
        }
    },

    atlas = "placeholder",
    pos = { x = 3, y = 3 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            hands_for_ceiling = 1
        }
    },

    calculate = function(self, card, context)

        -- Save how many hands are available before playing the next hand
        if context.hand_drawn then
            card.ability.extra.hands_for_ceiling =
                math.max(G.GAME.current_round.hands_left, 1)
        end

        -- Runs after all cards and Jokers have finished scoring
        if context.final_scoring_step then
            local hands_available =
                card.ability.extra.hands_for_ceiling or 1

            local blind_requirement =
                make_big(G.GAME.blind.chips)

            local raw_hand_score =
                make_big(hand_chips) * make_big(mult)

            -- Blind requirement divided by hands available,
            -- rounded to the nearest whole number
            local maximum_hand_score = math.floor(
                (blind_requirement / make_big(hands_available))
                + make_big(0.5)
            )

            -- Leave scores below the limit completely unchanged
            if raw_hand_score > maximum_hand_score then
                local reduction =
                    make_number(maximum_hand_score / raw_hand_score)

                -- Reduce only the current hand before it is
                -- added to the accumulated Blind score
                return {
                    xchips = reduction,
                    remove_default_message = true,
                    message = "Blocked!",
                    colour = G.C.CHIPS
                }
            end
        end
    end
}