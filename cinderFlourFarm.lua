local basins = {peripheral.find("create:basin")}
local cobbleChest = peripheral.find("minecraft:chest")
local cinderVault = peripheral.find("create:item_vault")
local lavaTank = peripheral.find("create:fluid_tank")

local monitor = peripheral.find("monitor")

local function updateMonitor()
    if monitor ~= nil then
        coroutine.wrap(function()
            monitor.clear()

            local cinderAmt = 0
            local cobbleAmt = 0
            local lavaMax = 288000
            local lavaCurrent = lavaTank.tanks()[1].amount
            local lavaPercent = lavaCurrent / lavaMax

            for _,v in pairs(cobbleChest.list()) do
                if v.name == "minecraft:cobblestone" then
                    cobbleAmt = cobbleAmt + v.count
                end
            end

            for _,v in pairs(cinderVault.list()) do
                if v.name == "create:cinder_flour" then
                    cinderAmt = cinderAmt + v.count
                end
            end

            monitor.setCursorPos(1,1)
            monitor.write("Cobblestone #:"..tostring(cobbleAmt))
            monitor.setCursorPos(1,2)
            monitor.write("Cinder Flour #:"..tostring(cinderAmt))
            monitor.setCursorPos(1,3)
            monitor.write("Lava %:"..tostring(math.ceil(lavaPercent*100)))
        end)()
    end
end
local function distribute()
    for index, basin in pairs(basins) do
        local limit = 32
        local cobbleAmt = 0
        local flourAmt = 0

        for itemIndex, item in pairs(basin.list()) do
            if item.name == "create:cinder_flour" then
                flourAmt = item.count
            elseif item.name == "minecraft:cobblestone" then
                cobbleAmt = item.count
            end
        end

        if cobbleAmt < limit then
            local remaining = limit - cobbleAmt

            for itemIndex, item in pairs(cobbleChest.list()) do
                if remaining > 0 then
                    local pulled = basin.pullItems(peripheral.getName(cobbleChest), itemIndex)
                    remaining = remaining - pulled
                end
            end
        end

        if flourAmt < limit then
            local remaining = limit - flourAmt

            for itemIndex, item in pairs(cinderVault.list()) do
                if remaining > 0 then
                    local pulled = basin.pullItems(peripheral.getName(cinderVault), itemIndex)
                    remaining = remaining - pulled
                end
            end
        end
    end
end

while true do 
    distribute()
    updateMonitor()
    os.sleep(1)
end
