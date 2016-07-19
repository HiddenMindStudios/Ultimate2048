return{
  goBack = function() States.game:setState("select","none",false)Gamestate:set("menu")end,
  moveLeft = function() States.game:move("left") end,
  moveRight = function() States.game:move("right") end,
  moveUp = function() States.game:move("up") end,
  moveDown = function() States.game:move("down") end,
  reset = function() States.game:reset() Gamestate:cycle() end,
  pause = function() States.game:pause() end
}