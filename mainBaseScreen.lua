local monitors = {peripheral.find("monitor")}
local mainMonitor = monitors[1]
local mainX, mainY = mainMonitor.getSize()

local scrollPos = 1
local scrollingText = "scroll :)"

local function update()
    mainMonitor.clear()

    mainMonitor.setCursorPos(1, mainY-1)
    mainMonitor.write(tostring(scrollPos))
    mainMonitor.setCursorPos(1, mainY)
    local toWrite = ""
    for i = 1,mainX do
        local pos = math.fmod(scrollPos + i, string.len(scrollingText)) + 1
        toWrite = toWrite..string.sub(scrollingText, pos, pos)
    end
    mainMonitor.write(toWrite)
end

while true do
    update()
    os.sleep(0.5)
end
