return{
  goMenu = function() 
    if States.options:getState() ~= "main" then 
      States.options:setState("main")
    else
      Gamestate:set("menu")
    end
  end
}