local saltbox = {
    type = "fixed",
    fixed = {-0.20, -0.5, -0.25, 0.25, 0, 0.2}
}

local function first(of)
    for _, i in pairs(of) do return i end
end

minetest.register_node("salt:salt_crystal", {
    description = "Generic Salt",
    drawtype = "mesh",
    mesh = "salt.obj",
    tiles = {"salt_salt.png"},
    stack_max = 1,
    collision_box = saltbox,
    selection_box = saltbox,
    groups = {oddly_breakable_by_hand = 1},
    paramtype = "light",
    after_place_node = function(pos, _, istack)
        local nmeta = minetest.get_meta(pos)
        local imeta = istack:get_meta()
        nmeta:set_string("infotext", imeta:get_string("description"))
    end,
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        local drop = first(drops)
        local meta = drop:get_meta()
        meta:set_string("description", oldmeta["infotext"])
    end
})

minetest.register_on_dieplayer(function(victim, reason)
    if reason.type == "punch" then
        local killer = reason.object
        if killer and killer:is_player() then
            local kname = killer:get_player_name()
            local vname = victim:get_player_name()
            local salt = ItemStack("salt:salt_crystal")
            local meta = salt:get_meta()
            meta:set_string("description", "The salt of " .. vname .. "\nKilled by " .. kname .. "\n" .. os.date("%m/%d/%y %H:%M:%S"))
            minetest.item_drop(salt, victim, victim:get_pos())
        end
    end
end)
