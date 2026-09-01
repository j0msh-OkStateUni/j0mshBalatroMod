local function triple_double(full_hand)
    local number_of_tens = 0

    for _, playing_card in ipairs(full_hand or {}) do
        local rank = playing_card:get_id()

        if rank == 10 then
            number_of_tens = number_of_tens + 1
        end

    end

    return number_of_tens == 3
end


SMODS.Joker{
    key = 'Russell Westbrook',
    loc_txt = {
        name = "Russell Westbrook",
        text = {
            "If exactly {C:attention}3 10s{} are played",
            "played {C:attention}10s{} are included in scoring",
            "and retrigger {C:attention}2{} additional times"
        }
    },

    atlas = "placeholder",
    pos = { x = 0, y = 2 },

    rarity = 1,
    cost = 3,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
}