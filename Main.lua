local url = "https://raw.githubusercontent.com/enzoplaaygamemg12/GUI123/refs/heads/main/BLOX_FRUITS_REDUX.lua"

local ok, result = pcall(function()
    return loadstring(game:HttpGet(url, true))()
end)

if not ok then
    warn("[Redux Hub] Erro ao carregar: " .. tostring(result))
end