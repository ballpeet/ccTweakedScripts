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

local tickNumberAt = 0

local totalItemsInSession = 0
local listOfRecent = {}
local listItemDecayTick = 200

local function addToList(id, amt, to, toDisplay)

    if listOfRecent[id] then
        listOfRecent[id]["tick"] = tickNumberAt
        listOfRecent[id]["amt"] = listOfRecent[id]["amt"] + amt
    else
        listOfRecent[id] = {
            ["tick"] = tickNumberAt,
            ["sentTo"] = to,
            ["sentToDisplay"] = toDisplay,
            ["amt"] = amt
        }
    end
end

local function tick()
    tickNumberAt = tickNumberAt + 1

    local listOfItems = inputChestPeriph.list()
    if #listOfItems > 0 then
        
        for itemIndex, _ in pairs(listOfItems) do
            local itemDetails = inputChestPeriph.getItemDetail(itemIndex)
            local tablesToThinkAbout = {}
            for _, tablIndex in pairs(inOrderOfPriority) do
                local currentTable = sortFilters[tablIndex]

                local currentTableScore = 0
                for filterIndex, filterValue in pairs(currentTable["filter"]) do
                    local filterToCompare = filterValue["value"]
                    local filterType = filterValue["type"]
                    local filterArgument = filterValue["arg"]

                    local passedAmt = 0
                    if filterType == "ID" then
                        for i,v in pairs(filterToCompare) do
                            print(v, itemDetails.name)
                            if v == itemDetails.name then
                                passedAmt = passedAmt + 1
                            end
                        end

                    elseif filterType == "TAG" then
                        for i,v in pairs(filterToCompare) do

                            for i2,v2 in pairs(itemDetails["tags"]) do
                                print(v, i2)
                                if v == i2 then
                                    passedAmt = passedAmt + 1
                                end
                            end
                        end

                    end

                    local passed = false
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
                    end
                end

                local filterTypeOther = currentTable["filterType2"]
                local filterExtra = currentTable["filterExtra"]
                local addBool = false
                if filterTypeOther == "STRICT" then
                    if currentTableScore == #currentTable["filter"] then
                        addBool = true
                    end
                elseif filterTypeOther == "LEAST" then
                    if currentTableScore >= filterExtra then
                        addBool = true
                    end
                end
                if addBool == true then
                    table.insert(tablesToThinkAbout, {
                        ["tableIndex"] = tablIndex,
                        ["score"] = currentTableScore
                    })
                end
            end

            local tableIndexGoTo = 0
            local tableIndexGoToScore = 0

            for i,v in pairs(tablesToThinkAbout) do
                if v["score"] > tableIndexGoToScore then
                    
                    tableIndexGoToScore = v["score"]
                    tableIndexGoTo = v["tableIndex"]
                end
            end

            if tableIndexGoTo ~= 0 and tableIndexGoToScore > 0 then
                local tableGot = sortFilters[tableIndexGoTo]
                local periphGot = peripheral.wrap(tableGot["id"])
                totalItemsInSession = totalItemsInSession + itemDetails.count
                addToList(itemDetails.name, itemDetails.count, tableGot["id"], tableGot["name"])
                periphGot.pullItems(inputChest, itemIndex)
            else
                totalItemsInSession = totalItemsInSession + itemDetails.count
                addToList(itemDetails.name, itemDetails.count, junkChest, "Junk")
                junkCheckPeriph.pullItems(inputChest, itemIndex)
            end
        end

    else

    end
end

local function updateMonitor()
    local monitorsGot = { peripheral.find("monitor") }

    for index, periph in pairs(monitorsGot) do
        periph.setTextScale(0.5)
        local sizeX, sizeY = periph.getSize()
        periph.setBackgroundColor(colors.black)
        periph.setTextColor(colors.white)
        periph.clear()

        local currentX = 1
        local currentY = 1

        local function write(txt)
            periph.setCursorPos(currentX, currentY)
            periph.write(txt)
        end
        write("Total amount of items gained since startup: "..tostring(totalItemsInSession))
        currentY = 2
        write("Current tick: "..tostring(tickNumberAt))
        currentY = 4

        local offset = 0
        for id ,valueTable in pairs(listOfRecent) do
            local ticksExisted = tickNumberAt - valueTable["tick"]
            if ticksExisted > listItemDecayTick then
                listOfRecent[id] = nil
            else

                local sentTo = valueTable["sentTo"]
                local sentToDisplay = valueTable["sentToDisplay"]
                local amountOfItems = valueTable["amt"]
                write("Item: "..tostring(id).." Amount: "..tostring(amountOfItems).." Sent to: "..tostring(sentTo).."("..tostring(sentToDisplay)..")")
                currentY = currentY + 1
            end
        end
    end
end

startup()
tick()
updateMonitor()

local tickTime = 0.1
while true do
    tick()
    updateMonitor()

    os.sleep(tickTime)
end
