local workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local localFileName = "song.mp3"
local githubRawUrl = "https://githubusercontent.com"

local fileExists = false
pcall(function()
    if readfile and readfile(localFileName) and #readfile(localFileName) > 100000 then
        fileExists = true
    end
end)

if not fileExists then
    local bindable = Instance.new("BindableFunction")
    bindable.OnInvoke = function(buttonPressed)
        if buttonPressed == "Download" then
            pcall(function()
                local audioData = game:HttpGet(githubRawUrl)
                if audioData and #audioData > 100000 and not audioData:find("404") then
                    writefile(localFileName, audioData)
                    StarterGui:SetCore("SendNotification", {
                        Title = "System",
                        Text = "yo execute script again and it going to work",
                        Duration = 10,
                        Button1 = "OK"
                    })
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "System",
                        Text = "GitHub file link invalid or not raw. Double check your URL!",
                        Duration = 5,
                        Button1 = "OK"
                    })
                end
            end)
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "System",
        Text = "its not a bad virus just click to download the song.mp3",
        Duration = 15,
        Button1 = "Download",
        Callback = bindable
    })
    return
end

local currentLiveTime = 7.7
local scriptIsChangingTime = false
local heartbeatConnection = nil

local function setupSeek(seekMusic, seekModel)
    seekMusic.SoundId = getcustomasset(localFileName)
    seekMusic.TimePosition = 7.7
    currentLiveTime = 7.7

    StarterGui:SetCore("SendNotification", {
        Title = "System",
        Text = "yo dont start the chase for a some sec lemme add some things to seek",
        Duration = 5,
        Button1 = "OK"
    })

    for _, child in pairs(seekModel:GetChildren()) do
        if child.Name:find("Puddle") or child.Name == "SeekPuddle" then
            child:Destroy()
        end
    end
    
    for _, part in pairs(seekModel:GetDescendants()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            if part.Name:find("Puddle") or part.Name == "SeekPuddle" then
                part:Destroy()
            end
        end
    end

    for _, part in pairs(seekModel:GetDescendants()) do
        if part:IsA("MeshPart") then
            part.Material = Enum.Material.SmoothPlastic
            
            local name = part.Name
            if name == "UpperTorso" or name == "LowerTorso" then
                part.Color = Color3.fromRGB(0, 120, 255)
            elseif (name:find("Arm") and name ~= "RightLowerArm" and name ~= "LeftLowerArm") then
                part.Color = Color3.fromRGB(255, 235, 0)
            elseif name:find("Leg") then
                part.Color = Color3.fromRGB(230, 90, 0)
            end
        end
    end

    StarterGui:SetCore("SendNotification", {
        Title = "System",
        Text = "dont mind that it dont uses hello neightbor things because i wont add them to seek, enjoy",
        Duration = 5,
        Button1 = "OK"
    })

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end

    heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not seekMusic or not seekMusic.Parent or not seekMusic.IsPlaying then
            if not seekMusic or not seekMusic.Parent then
                if heartbeatConnection then
                    heartbeatConnection:Disconnect()
                    heartbeatConnection = nil
                end
            end
            return
        end
        
        if scriptIsChangingTime then return end
        
        if math.abs(seekMusic.TimePosition - currentLiveTime) > 0.3 then
            scriptIsChangingTime = true
            seekMusic.TimePosition = currentLiveTime
            scriptIsChangingTime = false
        else
            currentLiveTime = currentLiveTime + deltaTime
        end
    end)
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "SeekMusic" and descendant:IsA("Sound") then
        local seekModel = descendant:FindFirstAncestor("SeekMovingNewClone")
        if seekModel then
            task.wait(0.1)
            setupSeek(descendant, seekModel)
        end
    end
end)

local existingMusic = workspace:FindFirstChild("SeekMusic", true)
if existingMusic then
    local seekModel = existingMusic:FindFirstAncestor("SeekMovingNewClone")
    if seekModel then
        setupSeek(existingMusic, seekModel)
    end
end

print("now it work")
