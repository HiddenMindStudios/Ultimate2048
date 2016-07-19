--Keybinding.lua
--%Complete: 85
--Missing: Multi-Key input, i.e. SHIFT + <key>

Keybindings = {}
Keybindings.system = {}

function Keybindings.init(bind, internalBindFXN, keyNames)
  Keybindings.keys = bind
  Keybindings.fxn = internalBindFXN
  Keybindings.keyNames = keyNames
end

function Keybindings.changeKey(key, fxncode)
  if key == nil then
    Keybindings.keys[key] = nil
    return
  end
  for bind, fxn in pairs(Keybindings.keys) do
    if(key == bind and fxn ~= fxncode) then
      fxn = fxncode
    end    
  end
end

function Keybindings.getKeyByFxn(fxncode)
  local keys = {}
  keys.i = 1
  for key, fxn in pairs(Keybindings.keys) do
    if(fxn == fxncode) then
      keys[key] = true
      keys.i = keys.i + 1
    end
  end
  if keys.i > 1 then
    return keys
  end
  return nil
end

function Keybindings.reset()
  Keybindings.keys = require(dH.Kbnd .. "initBindings")
end

function Keybindings.getKeyName(fxncode)
  return Keybindings.keyNames[fxncode]
end

function Keybindings.onKeyPress(key)
  for k, fxncode in pairs(Keybindings.keys) do
    if(k == key) then
      Keybindings.fxn[fxncode]()
    end
  end
end

function Keybindings.onKeyRelease(key)
end