local survivor = {}

local nakama = require("nakama")

local op_codes = {
    update_position = 1,
    update_input = 2,
    update_state = 3,
    update_jump = 4,
    spawn = 5,
    initial_state = 6
}

local commands = {}

commands[op_codes.update_position] = function(data, state)
    local id = data.id
    local position = data.position
    if state.positions[id] ~= nil then
        state.positions[id] = position
    end
end

commands[op_codes.update_input] = function(data, state)
    local id = data.id
    local input = data.input
    if state.inputs[id] ~= nil then
        state.inputs[id].direction = input
    end
end

commands[op_codes.update_jump] = function(data, state)
    local id = data.id
    if state.inputs[id] ~= nil then
        state.inputs[id].jump = 1
    end
end



function survivor.match_init(_, _)
    local state = {
        presences = {},
        inputs = {},
        positions = {},
        jumps = {}
    }
    local tick_rate = 10
    local label = "Survivor"

    return state, tick_rate, label
end

function survivor.match_join_attempt(_, _, _, state, presence, _)
    if state.presences[presence.user_id] ~= nil then
        return state, false, "User already logged in."
    end
    return state, true
end

function survivor.match_join(_, dispatcher, _, state, presences)
    for _, presence in ipairs(presences) do
		state.presences[presence.user_id] = presence

        state.positions[presence.user_id] = {
            ["x"] = 0,
            ["y"] = 0
        }

        state.inputs[presence.user_id] = {
            ["dir"] = 0,
            ["jump"] = 0
        }
	end

    return state
end

function survivor.match_leave(_, _, _, state, presences)
    for _, presence in ipairs(presences) do
        state.presences[presence.user_id] = nil
        state.positions[presence.user_id] = nil
        state.inputs[presence.user_id] = nil
        state.jumps[presence.user_id] = nil
    end

    return state
end

function survivor.match_loop(_, dispatcher, _, state, messages)
    for _, message in ipairs(messages) do
        local op_code = message.op_code
        nk.logger_info(message)
        local decoded = nk.json_decode(message.data)
        local command = commands[op_code]

        if command ~= nil then
            commands[op_code](decoded, state)
        end

        if op_code == op_codes.spawn then
            state.positions[message.sender.user_id] = {
                ["x"] = 100,
                ["y"] = 100
            }

            local data = {
                ["position"] = state.positions,
                ["inputs"] = state.inputs,
            }

            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(op_codes.initial_state, encoded, {message.sender})
            dispatcher.broadcast_message(op_codes.spawn, message.data)
        end
    end

    --local data = {
    --    ["positions"] = state.positions,
    --    ["inputs"] = state.inputs
    --}
    --local encoded = nk.json_encode(data)
    --dispatcher.broadcast_message(op_codes.update_state, encoded)

    --for _, input in pairs(state.inputs) do
    --    input.jump = 0
    --end

    return state
end

function survivor.match_terminate(context, dispatcher, tick, state, grace_seconds)
  local message = "Server shutting down in " .. grace_seconds .. " seconds"
  dispatcher.broadcast_message(2, message)

  return nil
end

function survivor.match_signal(_, _, _, state, data)
    return state, data
end

return survivor
