--#region Atlases

SMODS.Atlas{
    key = 'placeholder',
    path = 'placeholder.png',
    px = 71,
    py = 95,
}





local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/joker")

SMODS.current_mod.optional_features = function()
    return {
        post_trigger = true
    }
end

for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/joker/" .. file))()
end

