local s = "src/";local d = "data/";local a = "Assets/";
require(s.."button")require(s.."container")require(s.."font")require(s.."gamestate")require(s.."label")require(s.."vector")require(s.."keybindings") require(d .. "data") States.start= require(s.."start") require(s.."image") States.menu=require(s.."menu") States.options=require(s.."options") require(s.."common")States.game=require(s.."game")require(s.."Tile") _Assets_audio_click = a .. "click.ogg"