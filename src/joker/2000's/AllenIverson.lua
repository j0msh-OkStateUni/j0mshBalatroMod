local function all_scoring_cards_have_editions(scoring_hand)
    if not scoring_hand or #scoring_hand == 0 then
        return false
    end

    for _, scored_card in ipairs(scoring_hand) do
        if not scored_card.edition then
            return false
        end
    end

    return true
end

SMODS.Joker {
    key = "iverson",

    loc_txt = {
        name = "Allen Iverson",
        text = {
            "If {C:attention}all scoring cards{}",
            "have an {C:dark_edition}Edition{},",
            "retrigger the {C:attention}first",
            "scoring card{} once"
        }
    },

    atlas = "placeholder",
    pos = { x = 0, y = 1 },

    rarity = 2,
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.repetition
            and context.cardarea == G.play
            and context.scoring_hand
            and context.other_card == context.scoring_hand[1]
            and all_scoring_cards_have_editions(context.scoring_hand) then

            return {
                repetitions = 1,
                message = "Step Over!",
                colour = G.C.FILTER,
                card = card
            }
        end
    end
}