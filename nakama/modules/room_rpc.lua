local nakama = require("nakama")

local function _get_first_room()
    local matches = nakama.match_list()
    local current_match = matches[1]

    if current_match == nil then
        return nakama.match_create("survivor", {})
    else
        return current_match.match_id
    end
end

local function get_room_id(_, _)
    return _get_first_room()
end

nakama.register_rpc(get_room_id, "get_room_id")
