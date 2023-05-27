local inputChest = "minecraft:barrel_2"

local junkChest = "minecraft:barrel_0"

-- MOST, LEAST

--NOT, IS, ALL
--ID, TAG
local sortFilters = {

    {
        ["id"] = "minecraft:barrel_1",
        ["name"] = "wood chest",
        ["filter"] = {

            {
                ["value"] = {"minecraft:planks"},
                ["type"] = "ID",
                ["arg"] = "IS",
            },

        },
        ["filterType"] = "TAG",
        ["filterExtra"] = 1,
        ["priority"] = 0
    },

    {
        ["id"] = "minecraft:barrel_3",
        ["name"] = "flesh chest",
        ["filter"] = {

            {
                ["value"] = {"minecraft:rotten_flesh"},
                ["type"] = "ID",
                ["arg"] = "IS",
            },

        },
        ["filterType"] = "MOST",
        ["filterExtra"] = 1,
        ["priority"] = 0
    },

    {
        ["id"] = "storagedrawers:standard_drawers_1_0",
        ["name"] = "flesh chest",
        ["filter"] = {

            {
                ["value"] = {"minecraft:granite"},
                ["type"] = "ID",
                ["arg"] = "IS",
            },

        },
        ["filterType"] = "MOST",
        ["filterExtra"] = 1,
        ["priority"] = 0
    }

}

local inOrderOfPriority = {}

local function startup()

    for index, value in pairs(sortFilters) do
        
        local prio = value["priority"]
        local toPutAt = 0

        for index2, value2 in pairs(inOrderOfPriority) do
            local tableOf = sortFilters[value2]

            if prio > tableOf["priority"] then
                
            elseif prio < tableOf["priority"] then
                toPutAt = toPutAt + 1
            end
        end

        table.insert(inOrderOfPriority, toPutAt, index)
    end

    for index, value in pairs(inOrderOfPriority) do
        print(index, value)
    end
end

local tickNumberAt = 0
local function tick()
    tickNumberAt = tickNumberAt + 1
end

startup()
