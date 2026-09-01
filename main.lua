--#region Atlases

SMODS.Atlas{
    key = 'placeholder',
    path = 'placeholder.png',
    px = 71,
    py = 95,
    force_pixel = true
}





local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/joker")

for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/joker/" .. file))()
end
