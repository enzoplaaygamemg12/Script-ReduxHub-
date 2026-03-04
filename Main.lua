local url = "https://raw.githubusercontent.com/enzoplaaygamemg12/Script-ReduxHub-/refs/heads/main/Main.lua"

local ok, result = pcall(function()
    return loadstring(game:HttpGet(url, true))()
end)

if not ok then
    warn("[Redux Hub] Erro ao carregar: " .. tostring(result))
end