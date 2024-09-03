local monitors = {peripheral.find("monitor")}
local mainMonitor = monitors[1]
local mainX, mainY = mainMonitor.getSize()

local scrollPos = 1
local scrollingText = "skibidi toilet   "
local motd = "the only mother i will be fucking is toriel from undertale. she's a fucking milf and im not gonna deny it."

local weekdays = {
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
}

mainMonitor.setPaletteColor(colors.red, 0xFF0083)
mainMonitor.setPaletteColor(colors.purple, 0xad00ff)
mainMonitor.setPaletteColor(colors.blue, 0x2a00ff)
local function update()
    mainMonitor.clear()
    mainMonitor.setTextColor(colors.black)
    mainMonitor.setCursorPos(1, 1)
    mainMonitor.blit("i just really", "fffffffffffff", "eeeeeeeeeeeee")
    mainMonitor.setCursorPos(1, 2)
    mainMonitor.blit("really really", "fffffffffffff", "eeeeeeeeeeeee")
    mainMonitor.setBackgroundColor(colors.purple)
    mainMonitor.setCursorPos(1, 3)
    mainMonitor.blit("like tatsuki ", "fffffffffffff", "aaaaaaaaaaaaa")
    mainMonitor.setBackgroundColor(colors.blue)
    mainMonitor.setCursorPos(1, 4)
    mainMonitor.blit("fujimoto's   ", "fffffffffffff", "bbbbbbbbbbbbb")
    mainMonitor.setCursorPos(1, 5)
    mainMonitor.blit("manga        ", "fffffffffffff", "bbbbbbbbbbbbb")

    mainMonitor.setBackgroundColor(colors.black)
    local day = os.day()
    local dayOfTheWeek = math.fmod(day, 7)
    mainMonitor.setTextColor(colors.white)
    mainMonitor.setCursorPos(1, mainY - 4)
    mainMonitor.write(os.date())
    mainMonitor.setCursorPos(1, mainY - 3)
    mainMonitor.write("Today is "..weekdays[dayOfTheWeek].." (Day "..tostring(day)..")")
    mainMonitor.setCursorPos(1, mainY - 2)
    local timeMarker = "AM"
    local osTime = os.time()
    local hour = math.fmod(math.floor(osTime), 12) + 1
    if osTime > 12 then
        timeMarker = "PM"
    end
    local remainder = osTime - math.floor(osTime)
    local minute = math.floor(60 * remainder)
    minute = tostring(minute)
    if string.len(minute) == 1 then
        minute = "0"..minute
    end
    mainMonitor.write(tostring(hour)..":"..minute.." "..timeMarker)
    
    mainMonitor.setCursorPos(1, mainY)
    local toWrite = ""
    for i = 1,mainX do
        local pos = math.fmod(scrollPos + i, string.len(scrollingText)) + 1
        toWrite = toWrite..string.sub(scrollingText, pos, pos)
    end
    mainMonitor.write(toWrite)
    scrollPos = math.fmod(scrollPos, string.len(scrollingText)) + 1
end

while true do
    update()
    os.sleep(0.5)
end
