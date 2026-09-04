local function get_planet_for_hand(hand_name)
    if not G.P_CENTER_POOLS
        or not G.P_CENTER_POOLS.Planet then
        return nil
    end

    for _, planet in ipairs(G.P_CENTER_POOLS.Planet) do
        if planet.config
            and planet.config.hand_type == hand_name then
            return planet.key
        end
    end

    return nil
end

local function hand_failed_to_defeat_blind(card)
    if not G.GAME
        or not G.GAME.blind
        or not G.GAME.blind.chips then
        return false
    end

    local score_before_hand =
        card.ability.extra.score_before_hand or 0

    local hand_score =
        SMODS.last_hand_score or 0

    local blind_requirement =
        G.GAME.blind.chips

    -- Prevents Talisman from crashing when scores
    -- are represented using large-number tables.
    if type(to_big) == "function" then
        return to_big(score_before_hand)
            + to_big(hand_score)
            < to_big(blind_requirement)
    end

    return score_before_hand
        + hand_score
        < blind_requirement
end

SMODS.Joker {
    key = "bryant",

    loc_txt = {
        name = "Kobe Bryant",
        text = {
            "The first time each Blind that",
            "a played hand fails to defeat",
            "the Blind, create a",
            "{C:dark_edition}Negative{} copy of its",
            "corresponding {C:planet}Planet{} card"
        }
    },

    config = {
        extra = {
            created_this_blind = false,
            score_before_hand = 0
        }
    },

    atlas = "placeholder",
    pos = { x = 4, y = 1 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] =
            G.P_CENTERS.e_negative

        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        -- Kobe becomes available again whenever
        -- a new Blind begins.
        if context.setting_blind
            and not context.blueprint then

            card.ability.extra.created_this_blind = false
            card.ability.extra.score_before_hand = 0
        end

        -- Save the accumulated Blind score before
        -- the current hand is added to it.
        if context.before
            and not context.blueprint then

            card.ability.extra.score_before_hand =
                G.GAME.chips or 0
        end

        if context.after
            and not context.blueprint
            and not card.ability.extra.created_this_blind
            and hand_failed_to_defeat_blind(card) then

            local planet_key =
                get_planet_for_hand(context.scoring_name)

            if planet_key then
                card.ability.extra.created_this_blind = true

                return {
                    message = "Mamba Mentality!",
                    colour = G.C.SECONDARY_SET.Planet,

                    func = function()
                        SMODS.add_card({
                            set = "Planet",
                            key = planet_key,
                            area = G.consumeables,
                            edition = "e_negative",
                            key_append = "j0msh_bryant"
                        })
                    end
                }
            end
        end
    end
}