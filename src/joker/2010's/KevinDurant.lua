local WRAPPED_STRAIGHTS = {
    ["2,11,12,13,14"] = true, -- J-Q-K-A-2
    ["2,3,12,13,14"] = true,  -- Q-K-A-2-3
    ["2,3,4,13,14"] = true    -- K-A-2-3-4
}

local function is_wrapped_straight(cards)
    if not cards or #cards ~= 5 then
        return false
    end

    local ranks = {}
    local seen_ranks = {}

    for _, playing_card in ipairs(cards) do
        -- Stone Cards and other rankless cards cannot form a Straight
        if SMODS.has_no_rank(playing_card) then
            return false
        end

        local rank = playing_card:get_id()

        -- A Straight cannot contain duplicate ranks
        if not rank or seen_ranks[rank] then
            return false
        end

        seen_ranks[rank] = true
        ranks[#ranks + 1] = rank
    end

    table.sort(ranks)

    local rank_key = table.concat(ranks, ",")
    return WRAPPED_STRAIGHTS[rank_key] == true
end

local function is_five_card_flush(poker_hands)
    local flushes = poker_hands
        and poker_hands["Flush"]

    return flushes
        and flushes[1]
        and #flushes[1] == 5
end

SMODS.Joker {
    key = "Durant",

    loc_txt = {
        name = "Kevin Durant",
        text = {
            "Straights can {C:attention}wrap around{}",
            "between {C:attention}Ace{} and {C:attention}2{}"
        }
    },

    atlas = "placeholder",
    pos = { x = 1, y = 2 },

    rarity = 2,
    cost = 7,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,

    calculate = function(self, card, context)
        -- Changes a wrapped sequence into a Straight or Straight Flush
        if context.evaluate_poker_hand
            and is_wrapped_straight(context.full_hand) then

            local hand_name = "Straight"

            if is_five_card_flush(context.poker_hands) then
                hand_name = "Straight Flush"
            end

            return {
                replace_scoring_name = hand_name,
                replace_display_name = hand_name
            }
        end

        -- Ensures all five cards contribute their Chips
        if context.modify_scoring_hand
            and context.other_card
            and is_wrapped_straight(context.full_hand) then

            return {
                add_to_hand = true
            }
        end
    end
}