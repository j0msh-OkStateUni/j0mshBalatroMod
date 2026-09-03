local function is_dame_time(context)
    if not context.full_hand or #context.full_hand ~= 3 then
        return false
    end

    local current_round = G.GAME and G.GAME.current_round

    if not current_round then
        return false
    end

    -- While selecting cards, Balatro still displays 1 hand remaining.
    if context.modify_scoring_hand and not context.in_scoring then
        return current_round.hands_left == 1
    end

    -- Once the final hand begins scoring, hands_left becomes 0.
    return current_round.hands_left == 0
end

SMODS.Joker {
    key = "Lillard",

    loc_txt = {
        name = "Damian Lillard",
        text = {
            "On the {C:attention}final hand{} of round,",
            "if exactly {C:attention}3{} cards are played,",
            "all played cards score and",
            "retrigger {C:attention}2{} additional times"
        }
    },

    atlas = "placeholder",
    pos = { x = 4, y = 2 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        -- Makes all three played cards count as scoring cards.
        if context.modify_scoring_hand
            and context.other_card
            and is_dame_time(context) then

            return {
                add_to_hand = true
            }
        end

        -- Each card scores once normally and twice more from this effect.
        if context.repetition
            and context.cardarea == G.play
            and context.other_card
            and is_dame_time(context) then

            return {
                repetitions = 2,
                message = "Dame Time!",
                colour = G.C.RED
            }
        end
    end
}