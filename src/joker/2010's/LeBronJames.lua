local function is_hand_scoring_context(scoring_context)
    if not scoring_context then
        return false
    end

    return scoring_context.before
        or scoring_context.initial_scoring_step
        or scoring_context.main_scoring
        or scoring_context.individual
        or scoring_context.repetition
        or scoring_context.joker_main
        or scoring_context.final_scoring_step
        or scoring_context.after
end

SMODS.Joker {
    key = "james",

    loc_txt = {
        name = "LeBron James",
        text = {
            "Retrigger every {C:attention}scoring card{} once",
            "During scoring, retrigger every",
            "other {C:attention}Joker{} once when it activates"
        }
    },

    atlas = "placeholder",
    pos = { x = 2, y = 2 },

    rarity = 4,
    cost = 20,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,

    calculate = function(self, card, context)
        -- Retrigger every card that scores
        if context.repetition
            and context.cardarea == G.play then

            return {
                repetitions = 1,
                message = "Again!",
                colour = G.C.RED,
                card = card
            }
        end

        -- Retrigger other Jokers when they activate during scoring
        if context.retrigger_joker_check
            and context.other_card
            and context.other_card ~= card
            and context.other_card.config
            and context.other_card.config.center
            and context.other_card.config.center ~= self
            and context.other_context
            and not context.other_context.retrigger_joker
            and is_hand_scoring_context(context.other_context)
            and context.other_ret then

            return {
                repetitions = 1,
                message = "King's Court!",
                colour = G.C.RED,
                card = card
            }
        end
    end
}