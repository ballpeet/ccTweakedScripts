print("startup")

local inputChest = "minecraft:barrel_2"

local junkChest = "minecraft:barrel_0"

-- STRICT, LEAST

--NOT, IS, ALL
--ID, TAG
local sortFilters = {

    {
        ["id"] = "minecraft:barrel_1",
        ["name"] = "wood chest",
        ["filter"] = {

            {
                ["value"] = {"minecraft:planks"},
                ["type"] = "TAG",
                ["arg"] = "IS",
            },

        },
        ["filterType2"] = "STRICT",
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
        ["filterType2"] = "LEAST",
        ["filterExtra"] = 1,
        ["priority"] = 0
    },

    {
        ["id"] = "storagedrawers:standard_drawers_1_0",
        ["name"] = "granite drawer",
        ["filter"] = {

            {
                ["value"] = {"minecraft:granite"},
                ["type"] = "ID",
                ["arg"] = "IS",
            },

        },
        ["filterType2"] = "LEAST",
        ["filterExtra"] = 1,
        ["priority"] = 0
    }

}

local inOrderOfPriority = {}

local inputChestPeriph = peripheral.wrap(inputChest)
local junkCheckPeriph = peripheral.wrap(junkChest)

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
end

--NOT, IS, ALL
--ID, TAG
-- STRICT, LEAST
local tickNumberAt = 0
local function tick()
    tickNumberAt = tickNumberAt + 1

    print(tickNumberAt)

    local listOfItems = inputChestPeriph.list()
    if #listOfItems > 0 then
        
        for itemIndex, _ in pairs(listOfItems) do
            local itemDetails = inputChestPeriph.getItemDetail(itemIndex)

            print("Sorting... "..itemDetails.name)
            local tablesToThinkAbout = {}
            for _, tablIndex in pairs(inOrderOfPriority) do
                local currentTable = sortFilters[tablIndex]

                local currentTableScore = 0
                for filterIndex, filterValue in pairs(currentTable["filter"]) do
                    local filterToCompare = filterValue["value"]
                    local filterType = filterValue["type"]
                    local filterArgument = filterValue["arg"]

                    local passedAmt = 0

                    print("Filter type is "..filterType)
                    if filterType == "ID" then
                        for i,v in pairs(filterToCompare) do
                            print(v, itemDetails.name)
                            if v == itemDetails.name then
                                passedAmt = passedAmt + 1
                                print("Item has a similar id!")
                            end
                        end

                    elseif filterType == "TAG" then
                        for i,v in pairs(filterToCompare) do

                            for i2,v2 in pairs(itemDetails["tags"]) do
                                print(v, i2)
                                if v == i2 then
                                    passedAmt = passedAmt + 1
                                    print("Item has a similar tag!")
                                end
                            end
                        end

                    end

                    local passed = false

                    print("Argument is "..filterArgument)
                    if filterArgument == "NOT" then
                        if passedAmt == 0 then
                            passed = true
                        end
                    elseif filterArgument == "IS" then
                        if passedAmt > 0 then
                            passed = true
                        end
                    elseif filterArgument == "ALL" then
                        if passedAmt == #filterToCompare then
                            passed = true
                        end
                    end

                    if passed == true then
                        currentTableScore = currentTableScore + 1
                        print("Increasing score!")
                    end
                end

                local filterTypeOther = currentTable["filterType2"]
                local filterExtra = currentTable["filterExtra"]
                
                print("Filter type (2) is "..tostring(filterTypeOther))
                local addBool = false
                if filterTypeOther == "STRICT" then
                    if currentTableScore == #currentTable["filter"] then
                        print("STRICT Passed!")
                        addBool = true
                    end
                elseif filterTypeOther == "LEAST" then
                    if currentTableScore >= filterExtra then
                        print("LEAST Passed!")
                        addBool = true
                    end
                end
                if addBool == true then
                    print("Adding!")

                    table.insert(tablesToThinkAbout, {
                        ["tableIndex"] = tablIndex,
                        ["score"] = currentTableScore
                    })
                end
            end

            for i,v in pairs(tablesToThinkAbout) do
                print("Index: "..tostring(i))
                print("Table Index: "..tostring(v["tableIndex"]))
                print("Score: "..tostring(v["score"]))
            end
        end

    else

    end
end

startup()
tick()

-- download https://raw.githubusercontent.com/ballpeet/ccTweakedScripts/main/itemSorter.lua startup
