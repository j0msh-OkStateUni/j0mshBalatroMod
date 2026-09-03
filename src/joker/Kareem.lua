local function is_skyhook_hand(full_hand)
    local number_of_threes = 0
    local highest_rank = 0
    local has_jack = false

    for _, playing_card in ipairs(full_hand or {}) do
        local rank = playing_card:get_id()

        if rank == 3 then
            number_of_threes = number_of_threes + 1
        end

        if rank == 11 then
            has_jack = true
        end

        if rank and rank > highest_rank then
            highest_rank = rank
        end
    end

    return number_of_threes == 2
        and has_jack
        and highest_rank == 11
end


SMODS.Joker {
    key = "abdul-jabbar",

    loc_txt = {
        name = "Kareem Abdul-Jabbar",
        text = {
            "If exactly {C:attention}2 3s{} are played",
            "and a {C:attention}Jack{} is the highest rank,",
            "played {C:attention}Jacks{} are included in scoring",
            "and retrigger {C:attention}2{} additional times"
        }
    },

    atlas = "placeholder",
    pos = { x = 0, y = 0 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        -- Makes the Jack score even when it normally would not
        if context.modify_scoring_hand
            and context.other_card
            and context.other_card:get_id() == 11
            and is_skyhook_hand(context.full_hand) then

            return {
                add_to_hand = true
            }
        end

        -- Retriggers every scoring Jack twice
        if context.repetition
            and context.cardarea == G.play
            and context.other_card
            and context.other_card:get_id() == 11
            and is_skyhook_hand(context.full_hand) then

            return {
                repetitions = 2,
                message = "Skyhook!"
            }
        end
    end
}