local furnaces = {peripheral.find("minecraft:furnace")}
local monitors = {peripheral.find("monitor")}
local outputChest = peripheral.wrap("minecraft:chest_0")
local inputChest = peripheral.wrap("minecraft:chest_1")
local fuelChest = peripheral.wrap("minecraft:chest_2")
 
local maxDistributeTo = 4
local function distributeFuel()
    print("fuel dist.")
    local itemList = fuelChest.list()

    local canDistributeTo = {}
    local slotToCheck = 2
    local freeFurnaces = 0
    for index, inventory in pairs(furnaces) do
        local got = inventory.getItemDetail(slotToCheck)
        if got == nil then
            freeFurnaces = freeFurnaces + 1
            table.insert(canDistributeTo, inventory)
        else
            if got.name == item.name then
                freeFurnaces = freeFurnaces + 1
                table.insert(canDistributeTo, inventory)
            end
        end 
     end
    
    if freeFurnaces == 0 then
        return
    end

    for slotIndex, item in pairs(itemList) do
        local amount = item.count
        
        local distributeAmount = math.ceil(amount / math.min(maxDistributeTo, freeFurnaces))
        
        for index, inventory in pairs(canDistributeTo) do
            
            local inSlot = inventory.getItemDetail(slotToCheck)
            if inSlot == nil then
                inventory.pullItems(peripheral.getName(fuelChest), slotIndex, distributeAmount, slotToCheck) 
            else
                if inSlot.name == item.name then
                    inventory.pullItems(peripheral.getName(fuelChest), slotIndex, distributeAmount, slotToCheck) 
                end
            end
        end 
    end 
    print("fuel dist. end")
end
local function distributeItems()
    print("item dist.")
    local itemList = inputChest.list()

    local canDistributeTo = {}
    local slotToCheck = 1
    local freeFurnaces = 0
    for index, inventory in pairs(furnaces) do
       local got = inventory.getItemDetail(slotToCheck)
       if got == nil then
           freeFurnaces = freeFurnaces + 1
           table.insert(canDistributeTo, inventory)
       else
           if got.name == item.name then
               freeFurnaces = freeFurnaces + 1
               table.insert(canDistributeTo, inventory)
           end
       end 
    end
    
    if freeFurnaces == 0 then
        return
    end

    local distributed = false
    for slotIndex, item in pairs(itemList) do
        if distributed == true then
            return
        end
        distributed = true
        local amount = item.count
        
        local distributeAmount = math.ceil(amount / math.min(maxDistributeTo, freeFurnaces))
        
        for index, inventory in pairs(canDistributeTo) do
            
            local inSlot = inventory.getItemDetail(slotToCheck)
            if inSlot == nil then
                inventory.pullItems(peripheral.getName(inputChest), slotIndex, distributeAmount, slotToCheck) 
            else
                if inSlot.name == item.name then
                    inventory.pullItems(peripheral.getName(inputChest), slotIndex, distributeAmount, slotToCheck) 
                end
            end
        end 
    end 
    print("item dist. end")
end
local function collectOutput()
    print('collecting outputs!')

    for index, furnace in pairs(furnaces) do
        local slotToCheck = 3
        local got = furnace.getItemDetail(slotToCheck)
        if got ~= nil then
            furnace.pushItems(peripheral.getName(outputChest), slotToCheck, got.count)
        end
    end
    print("output collection end")
end
local function updateMonitors()
 
end
 
local waitTime = 4
local mainLoop = function()
        
    while true do
        distributeItems()
        os.sleep(waitTime/3)
        distributeFuel()
        os.sleep(waitTime/3)
        collectOutput()
        updateMonitors()
        os.sleep(waitTime/3)
    end
    
end
 
mainLoop()
