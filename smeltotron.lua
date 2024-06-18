local furnaces = {peripheral.find("minecraft:furnace")}
local monitors = {peripheral.find("monitor")}
local outputChest = peripheral.wrap("minecraft:chest_0")
local inputChest = peripheral.wrap("minecraft:chest_1")
local fuelChest = peripheral.wrap("minecraft:chest_2")
 
local maxDistributeTo = 4
local function distributeFuel()
    local itemList = fuelChest.list()
    for slotIndex, item in pairs(itemList) do
        local amount = item.count
        
        local slotToCheck = 2
        local freeFurnaces = 0
        for index, inventory in pairs(furnaces) do
           local got = inventory.getItemDetail(slotToCheck)
           if got == nil then
               freeFurnaces = freeFurnaces + 1
           else
               if got.name == item.name then
                   freeFurnaces = freeFurnaces + 1
               end
           end 
        end
        
        if freeFurnaces == 0 then
            return
        end
        
        local distributeAmount = amount / math.min(maxDistributeTo, freeFurnaces)
        
        for index, inventory in pairs(furnaces) do
            
            local inSlot = inventory.getItemDetail(slotToCheck)
            if inSlot == nil then
                furnace.pullItems(peripheral.getName(fuelChest), slotIndex, distributeAmount, slotToCheck) 
            else
                if inSlot.name == item.name then
                    furnace.pullItems(peripheral.getName(fuelChest), slotIndex, distributeAmount, slotToCheck) 
                end
            end
        end 
    end 
end
local function distributeItems()
    local itemList = inputChest.list()
    for slotIndex, item in pairs(itemList) do
        local amount = item.count
        
        local slotToCheck = 1
        local freeFurnaces = 0
        for index, inventory in pairs(furnaces) do
           local got = inventory.getItemDetail(slotToCheck)
           if got == nil then
               freeFurnaces = freeFurnaces + 1
           else
               if got.name == item.name then
                   freeFurnaces = freeFurnaces + 1
               end
           end 
        end
        
        if freeFurnaces == 0 then
            return
        end
        
        local distributeAmount = amount / math.min(maxDistributeTo, freeFurnaces)
        
        for index, inventory in pairs(furnaces) do
            
            local inSlot = inventory.getItemDetail(slotToCheck)
            if inSlot == nil then
                furnace.pullItems(peripheral.getName(inputChest), slotIndex, distributeAmount, slotToCheck) 
            else
                if inSlot.name == item.name then
                    furnace.pullItems(peripheral.getName(inputChest), slotIndex, distributeAmount, slotToCheck) 
                end
            end
        end 
    end 
end
local function collectOutput()
 
end
local function updateMonitors()
 
end
 
local waitTime = 2
local mainLoop = function()
        
    while true do
        distributeItems()
        distributeFuel()
        collectOutput()
        updateMonitors()
        os.sleep(waitTime)
    end
    
end
 
mainLoop()
