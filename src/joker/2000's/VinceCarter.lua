local function find_voucher_upgrade(base_voucher_key)
    if not G.P_CENTER_POOLS
        or not G.P_CENTER_POOLS.Voucher then
        return nil
    end

    for _, voucher in ipairs(G.P_CENTER_POOLS.Voucher) do
        if voucher.requires then
            for _, required_key in ipairs(voucher.requires) do
                if required_key == base_voucher_key then
                    return voucher.key
                end
            end
        end
    end

    return nil
end

local function contains_value(list, target)
    for _, value in ipairs(list or {}) do
        if value == target then
            return true
        end
    end

    return false
end

SMODS.Joker {
    key = "carter",

    loc_txt = {
        name = "Vince Carter",
        text = {
            "After redeeming a base-tier",
            "{C:attention}Voucher{}, its upgraded version",
            "is guaranteed to appear",
            "in the {C:attention}next shop{}"
        }
    },

    config = {
        extra = {
            pending_upgrades = {}
        }
    },

    atlas = "placeholder",
    pos = { x = 2, y = 1 },

    rarity = 3,
    cost = 8,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,

    calculate = function(self, card, context)
        -- Detect a Voucher being redeemed.
        if context.buying_card
            and context.card
            and context.card.ability
            and context.card.ability.set == "Voucher" then

            local voucher_key =
                context.card.config
                and context.card.config.center_key

            local upgrade_key =
                voucher_key
                and find_voucher_upgrade(voucher_key)

            if upgrade_key
                and not G.GAME.used_vouchers[upgrade_key] then

                local pending =
                    card.ability.extra.pending_upgrades

                if not contains_value(pending, upgrade_key) then
                    pending[#pending + 1] = upgrade_key

                    return {
                        message = "Taking flight!",
                        colour = G.C.MONEY
                    }
                end
            end
        end

        -- Add queued upgrades after the next shop has been created.
        if context.starting_shop then
            local pending =
                card.ability.extra.pending_upgrades or {}

            if #pending == 0 then
                return
            end

            local current_vouchers =
                G.GAME.current_round.voucher

            if not current_vouchers
                or not current_vouchers.spawn
                or not G.shop_vouchers then
                return
            end

            local appeared = false

            for _, upgrade_key in ipairs(pending) do
                if not G.GAME.used_vouchers[upgrade_key] then
                    -- Avoid creating a duplicate if the shop
                    -- naturally selected the same upgrade.
                    if not current_vouchers.spawn[upgrade_key] then
                        if not contains_value(
                            current_vouchers,
                            upgrade_key
                        ) then
                            current_vouchers[
                                #current_vouchers + 1
                            ] = upgrade_key
                        end

                        current_vouchers.spawn[upgrade_key] = true

                        SMODS.add_voucher_to_shop(upgrade_key)
                    end

                    appeared = true
                end
            end

            -- Every queued upgrade has now been handled.
            card.ability.extra.pending_upgrades = {}

            if appeared then
                return {
                    message = "Air Canada!",
                    colour = G.C.MONEY
                }
            end
        end
    end
}