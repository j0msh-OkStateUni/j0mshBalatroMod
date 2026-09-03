--#region Atlases

SMODS.Atlas{
    key = 'placeholder',
    path = 'placeholder.png',
    px = 71,
    py = 95,
}



SMODS.current_mod.optional_features = function()
    return {
        post_trigger = true
    }
end


local function load_joker_folder(directory)
    local items = SMODS.NFS.getDirectoryItems(
        SMODS.current_mod.path .. directory
    )

    for _, item in ipairs(items) do
        local relative_path = directory .. "/" .. item
        local absolute_path =
            SMODS.current_mod.path .. relative_path

        local info = SMODS.NFS.getInfo(absolute_path)

        if info and info.type == "directory" then
            load_joker_folder(relative_path)

        elseif item:lower():sub(-4) == ".lua" then
            assert(SMODS.load_file(relative_path))()
        end
    end
end

load_joker_folder("src/joker")