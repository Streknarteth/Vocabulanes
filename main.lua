--[[
    Vocabulary game: Vocabulanes

    -- Main Program --

    Author: Eric Bertschy

    
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Slide class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Slide'

require 'Obstacle'
-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
FONT_HEIGHT = 16

-- player movement speed
PADDLE_SPEED = 200

TRANSLATION_TBL = {
    ["week"] = "vecka",
    ["year"] = "år",
    ["today"] = "idag",
    ["tomorrow"] ="imorgon",
    ["yesterday"] = "igår",
    ["calendar"] = "Kalender",
    ["second"] = "sekund",
    ["hour"] = "timme",
    ["minute"] = "minut",
    ["clock"] = "klocka",
    ["one hour"] = "en timme",
    ["can"] = "kan",
    ["use"] = "använda",
    ["do"] = "göra",
    ["go"] = "gå",
    ["come"] = "komma",
    ["laugh"] = "skratta",
    ["yes"] = "ja",
    ["no"] = "nej",
    ["good"] = "bra",
    ["hello"] = "hej",
    ["morning"] = "morgan",
    ["night"] = "natt",
    ["please"] = "snalla",
    ["goodbye"] = "hej da",
    ["please"] = "snalla du",
    ["train"] = "taget",
    ["bus"] = "bussen",
    ["tram"] = "sparvagn",
    ["train station"] = "Tagstationen",
    ["my"] = "mitt",
    ["restrooms"] = "toalett",
    ["men"] = "herrar",
    ["women"] = "damer",
    ["open"] = "oppen",
    ["closed"] = "stangd",
    ["cheers"] = "skal",
    ["chill"] = "tagga ned",
    ["I"] = "jag",
    ["his"] = "hans",
    ["that"] = "att",
    ["as"] = "som",
    ["he"] = "han",
    ["was"] = "var",
    ["on"] = "på",
    ["with"] = "med",
    ["they"] = "de",
    ["be"] = "vara",
    ["at"] = "vid",
    ["one"] = "ett",
    ["have"] = "ha",
    ["this"] = "detta",
    ["from"] = "från",
    ["by"] = "genom",
    ["hot"] = "het",
    ["word"] = "ord",

    ["for"] = "för",
    ["are"] = "är",
    ["with"] = "med",
    ["they"] = "de",
    ["by"] = "genom",
    ["what"] = "vad",
    ["some"] = "några",
    ["is"] = "är",
    ["it"] = "den",
    ["you"] = "du",
    ["or"] = "eller",
    ["had"] = "hade",
    ["the"] = "den",
    ["of"] = "av",
    ["to"] = "till",
    ["and"] = "och",
    ["a"] = "en",
    ["in"] = "i",
    ["we"] = "vi",
    ["can"] = "kan",
    ["out"] = "ut",
    ["other"] = "andra",
    ["were"] = "var",
    ["which"] = "vilken",
    ["do"] = "göra",
    ["their"] = "deras",
    ["time"] = "tid",
    ["if"] = "om",
    ["will"] = "kommer",
    ["how"] = "hur",
    ["said"] = "sa",
    ["an"] = "ett",
    ["each"] = "varje",
    ["tell"] = "berätta",
    ["does"] = "gör",
    ["set"] = "uppsättning",
    ["three"] = "tre",
    ["want"] = "vill",
    ["air"] = "luft",
    ["well"] = "väl",
    ["also"] = "också",
    ["play"] = "spela",
    ["small"] = "liten",
    ["end"] = "ände",
    ["put"] = "sätta",
    ["home"] = "hem",
    ["read"] = "läsa",
    ["hand"] = "sidan",
    ["port"] = "port",
    ["large"] = "stor",
    ["spell"] = "stava",
    ["add"] = "lägg",
    ["even"] = "även",
    ["land"] = "mark",
    ["here"] = "här",
    ["must"] = "must",
    ["big"] = "stor",
    ["high"] = "hög",
    ["such"] = "sådan",
    ["follow"] = "följ",
    ["act"] = "handling",
    ["why"] = "varför",
    ["ask"] = "be",
    ["men"] = "män",
    ["change"] = "förändring",
    ["went"] = "gick",
    ["light"] = "ljus",
    ["kind"] = "slag",
    ["off"] = "off",
    ["need"] = "behöver",
    ["house"] = "hus",
    ["picture"] = "bilden",
    ["try"] = "försök",
    ["us"] = "oss",
    ["again"] = "igen",
    ["animal"] = "djur",
    ["point"] = "punkt",
    ["mother"] = "mor",
    ["world"] = "världen",
    ["near"] = "nära",
    ["build"] = "bygga",
    ["self"] = "själv",
    ["earth"] = "jord",
    ["father"] = "far",
    ["any"] = "någon",
    ["new"] = "ny",
    ["work"] = "arbete",
    ["part"] = "delen",
    ["take"] = "ta",
    ["get"] = "få",
    ["place"] = "plats",
    ["made"] = "gjort",
    ["live"] = "lever",
    ["where"] = "där",
    ["after"] = "efter",
    ["back"] = "tillbaka",
    ["little"] = "liten",
    ["only"] = "endast",
    ["round"] = "rund",
    ["man"] = "människa",
    ["year"] = "år",
    ["came"] = "kom",
    ["show"] = "visar",
    ["every"] = "varje",
    ["good"] = "bra",
    ["me"] = "mig",
    ["give"] = "ge",
    ["our"] = "vår",
    ["under"] = "enligt",
    ["name"] = "namn",
    ["very"] = "mycket",
    ["through"] = "genom",
    ["just"] = "bara",
    ["form"] = "formulär",
    ["sentence"] = "meningen",
    ["great"] = "bra",
    ["think"] = "tro",
    ["say"] = "säga",
    ["help"] = "hjälpa",
    ["low"] = "låg",
    ["line"] = "linje",
    ["differ"] = "skiljer",
    ["turn"] = "tur",
    ["cause"] = "orsak",
    ["much"] = "mycket",
    ["mean"] = "betyda",
    ["before"] = "före",
    ["move"] = "drag",
    ["right"] = "höger",
    ["boy"] = "pojke",
    ["old"] = "gammal",
    ["too"] = "alltför",
    ["same"] = "samma",
    ["she"] = "hon",
    ["all"] = "alla",
    ["there"] = "där",
    ["when"] = "när",
    ["up"] = "upp",
    ["use"] = "använda",
    ["your"] = "din",
    ["way"] = "sätt",
    ["about"] = "ca",
    ["many"] = "många",
    ["bicycle shop"] = "cykelverkstad",
    ["them"] = "dem",
    ["write"] = "skriva",
    ["would"] = "skulle",
    ["like"] = "liknande",
    ["so"] = "så",
    ["these"] = "dessa",
    ["her"] = "hennes",
    ["long"] = "lång",
    ["make"] = "göra",
    ["thing"] = "sak",
    ["see"] = "se",
    ["him"] = "honom",
    ["two"] = "två",
    ["has"] = "har",
    ["look"] = "ser",
    ["more"] = "mer",
    ["day"] = "dag",
    ["could"] = "kunde",
    ["go"] = "gå",
    ["come"] = "komma",
    ["did"] = "gjorde",
    ["number"] = "antal",
    ["sound"] = "sund",
    ["no"] = "nej",
    ["most"] = "mest",
    ["people"] = "människor",
    ["my"] = "min",
    ["over"] = "över",
    ["know"] = "vet",
    ["water"] = "vatten",
    ["than"] = "än",
    ["call"] = "samtal",
    ["first"] = "först",
    ["who"] = "som",
    ["may"] = "får",
    ["down"] = "ner",
    ["side"] = "sida",
    ["been"] = "varit",
    ["now"] = "nu",
    ["find"] = "hitta",
    ["head"] = "huvud",
    ["stand"] = "stå",
    ["own"] = "egen",
    ["page"] = "sida",
    ["should"] = "bör",
    ["country"] = "land",
    ["found"] = "funnen",
    ["answer"] = "svar",
    ["school"] = "skola",
    ["grow"] = "växa",
    ["study"] = "studie",
    ["still"] = "fortfarande",
    ["learn"] = "lära",
    ["plant"] = "växt",
    ["cover"] = "lock",
    ["food"] = "mat",
    ["sun"] = "sol",
    ["four"] = "fyra",
    ["between"] = "mellan",
    ["state"] = "tillstånd",
    ["keep"] = "hålla",
    ["eye"] = "öga",
    ["never"] = "aldrig",
    ["last"] = "sista",
    ["let"] = "låt",
    ["thought"] = "trodde",
    ["city"] = "ort",
    ["tree"] = "träd",
    ["cross"] = "korsa",
    ["farm"] = "gård",
    ["hard"] = "hård",
    ["start"] = "start",
    ["might"] = "kanske",
    ["story"] = "berättelse",
    ["saw"] = "sågen",
    ["far"] = "långt",
    ["sea"] = "hav",
    ["draw"] = "rita",
    ["left"] = "vänster",
    ["late"] = "sen",
    ["run"] = "köra",
    ["donâ€™t"] = "inte",
    ["while"] = "medan",
    ["press"] = "tryck",
    ["close"] = "nära",
    ["night"] = "natt",
    ["real"] = "verklig",
    ["life"] = "liv",
    ["few"] = "några",
    ["north"] = "norr",
    ["book"] = "boken",
    ["carry"] = "bära",
    ["took"] = "tog",
    ["science"] = "vetenskap",
    ["eat"] = "äta",
    ["room"] = "rum",
    ["friend"] = "vän",
    ["began"] = "började",
    ["idea"] = "idÃ©",
    ["fish"] = "fisk",
    ["mountain"] = "berg",
    ["stop"] = "stoppa",
    ["once"] = "en gång",
    ["base"] = "bas",
    ["hear"] = "höra",
    ["horse"] = "häst",
    ["cut"] = "snitt",
    ["sure"] = "säker",
    ["watch"] = "klocka",
    ["color"] = "färg",
    ["face"] = "ansikte",
    ["wood"] = "trä",
    ["main"] = "huvud",
    ["open"] = "öppen",
    ["seem"] = "tyckas",
    ["together"] = "tillsammans",
    ["next"] = "nästa",
    ["white"] = "vit",
    ["children"] = "barn",
    ["begin"] = "börja",
    ["got"] = "fick",
    ["walk"] = "gå",
    ["example"] = "exempel",
    ["ease"] = "lindra",
    ["paper"] = "papper",
    ["group"] = "grupp",
    ["always"] = "alltid",
    ["music"] = "musik",
    ["those"] = "de som",
    ["both"] = "båda",
    ["mark"] = "märke",
    ["often"] = "ofta",
    ["letter"] = "bokstav",
    ["until"] = "tills",
    ["mile"] = "mil",
    ["river"] = "flod",
    ["car"] = "bil",
    ["feet"] = "fot",
    ["care"] = "vård",
    ["second"] = "andra",
    ["enough"] = "tillräckligt",
    ["plain"] = "vanlig",
    ["girl"] = "flicka",
    ["usual"] = "vanligt",
    ["young"] = "ung",
    ["ready"] = "klar",
    ["above"] = "ovan",
    ["ever"] = "någonsin",
    ["red"] = "röd",
    ["list"] = "lista",
    ["though"] = "though",
    ["feel"] = "känna",
    ["talk"] = "diskussion",
    ["bird"] = "fågel",
    ["soon"] = "snart",
    ["body"] = "kropp",
    ["dog"] = "hund",
    ["family"] = "familj",
    ["direct"] = "direkt",
    ["pose"] = "pose",
    ["leave"] = "lämna",
    ["song"] = "sång",
    ["measure"] = "mäta",
    ["door"] = "dörr",
    ["product"] = "produkt",
    ["black"] = "svart",
    ["short"] = "kort",
    ["numeral"] = "siffran",
    ["class"] = "klass",
    ["wind"] = "vind",
    ["question"] = "fråga",
    ["happen"] = "hända",
    ["complete"] = "fullständig",
    ["ship"] = "skepp",
    ["area"] = "område",
    ["half"] = "halv",
    ["rock"] = "vagga",
    ["order"] = "för",
    ["fire"] = "eld",
    ["south"] = "söder",
    ["problem"] = "problemet",
    ["piece"] = "stycke",
    ["told"] = "sa",
    ["knew"] = "visste",
    ["pass"] = "passera",
    ["since"] = "sedan",
    ["top"] = "topp",
    ["whole"] = "hela",
    ["king"] = "kung",
    ["street"] = "gata",
    ["inch"] = "tum",
    ["multiply"] = "multiplicera",
    ["nothing"] = "ingenting",
    ["course"] = "Naturligtvis",
    ["stay"] = "bo",
    ["wheel"] = "hjul",
    ["full"] = "fullständig",
    ["force"] = "kraft",
    ["blue"] = "blå",
    ["object"] = "objektet",
    ["decide"] = "besluta",
    ["surface"] = "yta",
    ["deep"] = "djup",
    ["moon"] = "månen",
    ["island"] = "ö",
    ["foot"] = "fot",
    ["system"] = "systemet",
    ["busy"] = "upptagen",
    ["test"] = "testet",
    ["record"] = "register",
    ["boat"] = "båt",
    ["common"] = "gemensam",
    ["gold"] = "guld",
    ["possible"] = "möjlig",
    ["plane"] = "plan",
    ["stead"] = "stead",
    ["dry"] = "torka",
    ["wonder"] = "undra",
    ["laugh"] = "skratt",
    ["thousand"] = "tusen",
    ["ago"] = "sedan",
    ["ran"] = "ran",
    ["check"] = "ta",
    ["game"] = "spel",
    ["shape"] = "form",
    ["equate"] = "likställa",
    ["hot"] = "het",
    ["miss"] = "miss",
    ["brought"] = "bringas",
    ["heat"] = "hetta",
    ["snow"] = "snö",
    ["tire"] = "däcket",
    ["bring"] = "bringa",
    ["yes"] = "ja",
    ["distant"] = "avlägsen",
    ["fill"] = "fylla",
    ["east"] = "öst",
    ["paint"] = "måla",
    ["language"] = "språk",
    ["among"] = "bland",
    ["unit"] = "enhet",
    ["power"] = "kraft",
    ["town"] = "stad",
    ["fine"] = "fin",
    ["certain"] = "viss",
    ["fly"] = "flyga",
    ["fall"] = "falla",
    ["lead"] = "bly",
    ["cry"] = "rop",
    ["dark"] = "mörk",
    ["machine"] = "maskin",
    ["note"] = "anteckning",
    ["wait"] = "vänta",
    ["plan"] = "planen",
    ["figure"] = "figur",
    ["star"] = "stjärna",
    ["box"] = "låda",
    ["noun"] = "subst",
    ["field"] = "fält",
    ["rest"] = "resten",
    ["correct"] = "korrekt",
    ["able"] = "kunna",
    ["pound"] = "pund",
    ["done"] = "klar",
    ["beauty"] = "skönhet",
    ["drive"] = "enhet",
    ["stood"] = "stod",
    ["contain"] = "innehålla",
    ["front"] = "främre",
    ["teach"] = "undervisa",
    ["week"] = "vecka",
    ["final"] = "slutlig",
    ["gave"] = "gav",
    ["green"] = "grön",
    ["oh"] = "ack",
    ["quick"] = "sammanfattning",
    ["develop"] = "utveckla",
    ["ocean"] = "ocean",
    ["warm"] = "varm",
    ["free"] = "fri",
    ["minute"] = "minut",
    ["strong"] = "stark",
    ["special"] = "speciell",
    ["mind"] = "sinne",
    ["behind"] = "bakom",
    ["clear"] = "klar",
    ["tail"] = "svans",
    ["produce"] = "producera",
    ["fact"] = "faktum",
    ["space"] = "space",
    ["heard"] = "hört",
    ["best"] = "bäst",
    ["hour"] = "timme",
    ["better"] = "bättre",
    ["true"] = "SANT",
    ["during"] = "under",
    ["hundred"] = "hundra",
    ["five"] = "fem",
    ["remember"] = "minnas",
    ["step"] = "steg",
    ["early"] = "tidig",
    ["hold"] = "håll",
    ["west"] = "väster",
    ["ground"] = "jord",
    ["interest"] = "intresse",
    ["reach"] = "nå",
    ["fast"] = "snabb",
    ["verb"] = "verb",
    ["sing"] = "sjunger",
    ["listen"] = "lyssna",
    ["six"] = "sex",
    ["table"] = "tabell",
    ["travel"] = "resor",
    ["less"] = "mindre",
    ["morning"] = "morgon",
    ["ten"] = "tio",
    ["simple"] = "enkel",
    ["several"] = "flera",
    ["vowel"] = "vokal",
    ["toward"] = "mot",
    ["war"] = "krig",
    ["lay"] = "låg",
    ["against"] = "mot",
    ["pattern"] = "mönster",
    ["slow"] = "långsam",
    ["center"] = "centrum",
    ["love"] = "kärlek",
    ["person"] = "personen",
    ["money"] = "pengar",
    ["serve"] = "tjäna",
    ["appear"] = "synas",
    ["road"] = "väg",
    ["map"] = "karta",
    ["rain"] = "regn",
    ["rule"] = "regel",
    ["govern"] = "regera",
    ["pull"] = "dra",
    ["cold"] = "förkylning",
    ["notice"] = "meddelande",
    ["voice"] = "röst",
    ["energy"] = "energi",
    ["hunt"] = "jakt",
    ["probable"] = "trolig",
    ["bed"] = "bädd",
    ["brother"] = "bror",
    ["egg"] = "ägg",
    ["ride"] = "ritt",
    ["cell"] = "cell",
    ["believe"] = "tro",
    ["perhaps"] = "kanske",
    ["pick"] = "plocka",
    ["sudden"] = "plötslig",
    ["count"] = "räkna",
    ["square"] = "kvadrat",
    ["reason"] = "anledningen",
    ["length"] = "längd",
    ["represent"] = "representerar",
    ["art"] = "teknikområdet",
    ["subject"] = "ämne",
    ["region"] = "region",
    ["size"] = "storlek",
    ["vary"] = "varierar",
    ["settle"] = "sedimentera",
    ["speak"] = "tala",
    ["weight"] = "vikt",
    ["general"] = "allmän",
    ["ice"] = "is",
    ["matter"] = "materia",
    ["circle"] = "cirkel",
    ["pair"] = "par",
    ["include"] = "inkluderar",
    ["divide"] = "divide",
    ["syllable"] = "stavelse",
    ["felt"] = "kände",
    ["grand"] = "stors",
    ["ball"] = "boll",
    ["yet"] = "ännu",
    ["wave"] = "våg",
    ["drop"] = "släpp",
    ["heart"] = "hjärta",
    ["am"] = "jag",
    ["present"] = "föreliggande",
    ["heavy"] = "tung",
    ["dance"] = "dans",
    ["engine"] = "motor",
    ["position"] = "ställning",
    ["arm"] = "beväpnar",
    ["wide"] = "bred",
    ["sail"] = "segel",
    ["material"] = "materialet",
    ["fraction"] = "fraktion",
    ["forest"] = "skog",
    ["sit"] = "sitta",
    ["race"] = "ras",
    ["window"] = "fönster",
    ["store"] = "lagra",
    ["summer"] = "sommar",
    ["train"] = "tåg",
    ["sleep"] = "sömn",
    ["prove"] = "bevisa",
    ["lone"] = "ensam",
    ["leg"] = "ben",
    ["exercise"] = "övning",
    ["wall"] = "vägg",
    ["catch"] = "fångst",
    ["mount"] = "fäste",
    ["wish"] = "vill",
    ["sky"] = "himmelsblå",
    ["board"] = "ombord",
    ["joy"] = "glädje",
    ["winter"] = "vinter",
    ["sat"] = "satellit",
    ["written"] = "skriven",
    ["wild"] = "vild",
    ["instrument"] = "instrumentet",
    ["kept"] = "hålls",
    ["glass"] = "glas",
    ["grass"] = "gräs",
    ["cow"] = "ko",
    ["job"] = "jobb",
    ["edge"] = "kanten",
    ["sign"] = "tecken",
    ["visit"] = "besök",
    ["past"] = "förbi",
    ["soft"] = "mjuk",
    ["fun"] = "kul",
    ["bright"] = "ljust",
    ["gas"] = "gas",
    ["weather"] = "väder",
    ["month"] = "månad",
    ["million"] = "miljoner",
    ["bear"] = "bära",
    ["finish"] = "yta",
    ["happy"] = "lycklig",
    ["hope"] = "hoppas",
    ["flower"] = "blomma",
    ["clothe"] = "kläder",
    ["strange"] = "främmande",
    ["gone"] = "borta",
    ["trade"] = "handel",
    ["melody"] = "melodi",
    ["trip"] = "resa",
    ["office"] = "kontor",
    ["receive"] = "motta",
    ["row"] = "rad",
    ["mouth"] = "mun",
    ["exact"] = "exakta",
    ["symbol"] = "symbol",
    ["die"] = "dö",
    ["least"] = "minst",
    ["trouble"] = "besvär",
    ["shout"] = "rop",
    ["except"] = "utom",
    ["wrote"] = "skrev",
    ["seed"] = "frö",
    ["tone"] = "ton",
    ["join"] = "ansluta",
    ["suggest"] = "föreslår",
    ["clean"] = "ren",
    ["break"] = "paus",
    ["lady"] = "damen",
    ["yard"] = "gård",
    ["rise"] = "stiga",
    ["bad"] = "dålig",
    ["blow"] = "smäll",
    ["oil"] = "olja",
    ["blood"] = "blod",
    ["touch"] = "Rör",
    ["grew"] = "växte",
    ["cent"] = "cent",
    ["mix"] = "blanda",
    ["team"] = "lag",
    ["wire"] = "tråd",
    ["cost"] = "kostnad",
    ["lost"] = "förlorat",
    ["brown"] = "brun",
    ["wear"] = "slitage",
    ["garden"] = "trädgård",
    ["equal"] = "lika",
    ["sent"] = "skickat",
    ["choose"] = "välja",
    ["fell"] = "föll",
    ["fit"] = "passa",
    ["flow"] = "flöde",
    ["fair"] = "verkligt",
    ["bank"] = "bank",
    ["collect"] = "samla",
    ["save"] = "spara",
    ["control"] = "kontroll",
    ["decimal"] = "decimala",
    ["ear"] = "örat",
    ["else"] = "annars",
    ["quite"] = "ganska",
    ["broke"] = "bröt",
    ["case"] = "fall",
    ["middle"] = "mitten",
    ["kill"] = "döda",
    ["son"] = "son",
    ["lake"] = "sjö",
    ["moment"] = "ögonblick",
    ["scale"] = "skala",
    ["loud"] = "högt",
    ["spring"] = "fjäder",
    ["observe"] = "observera",
    ["child"] = "barn",
    ["straight"] = "rak",
    ["consonant"] = "konsonant",
    ["nation"] = "nation",
    ["dictionary"] = "ordbok",
    ["milk"] = "mjölk",
    ["speed"] = "hastighet",
    ["method"] = "metod",
    ["organ"] = "organ",
    ["pay"] = "betala",
    ["age"] = "okänd",
    ["section"] = "sektion",
    ["dress"] = "klänning",
    ["cloud"] = "moln",
    ["surprise"] = "överraskning",
    ["quiet"] = "ro",
    ["stone"] = "sten",
    ["tiny"] = "liten",
    ["climb"] = "klättra",
    ["cool"] = "sval",
    ["design"] = "konstruktion",
    ["poor"] = "dålig",
    ["lot"] = "mycket",
    ["experiment"] = "experiment",
    ["bottom"] = "botten",
    ["key"] = "nyckel",
    ["iron"] = "järn",
    ["single"] = "singel",
    ["stick"] = "pinne",
    ["flat"] = "platt",
    ["twenty"] = "tjugo",
    ["skin"] = "hud",
    ["smile"] = "le",
    ["crease"] = "veck",
    ["hole"] = "hål",
    ["jump"] = "hoppa",
    ["baby"] = "barn",
    ["eight"] = "åtta",
    ["village"] = "by",
    ["meet"] = "möts",
    ["root"] = "rot",
    ["buy"] = "köpa",
    ["raise"] = "höja",
    ["solve"] = "lösa",
    ["metal"] = "metall",
    ["whether"] = "huruvida",
    ["push"] = "tryck",
    ["seven"] = "sju",
    ["paragraph"] = "punkt",
    ["third"] = "tredje",
    ["shall"] = "skall",
    ["held"] = "vänt",
    ["hair"] = "hår",
    ["describe"] = "beskriva",
    ["cook"] = "kock",
    ["floor"] = "våningen",
    ["either"] = "antingen",
    ["result"] = "resultat",
    ["burn"] = "bränna",
    ["hill"] = "kulle",
    ["safe"] = "säker",
    ["cat"] = "cat",
    ["century"] = "talet",
    ["consider"] = "överväga",
    ["type"] = "typ",
    ["law"] = "lag",
    ["bit"] = "bitars",
    ["coast"] = "kust",
    ["copy"] = "kopia",
    ["phrase"] = "fras",
    ["silent"] = "tyst",
    ["tall"] = "tall",
    ["sand"] = "sand",
    ["soil"] = "jord",
    ["roll"] = "rulle",
    ["temperature"] = "temperatur",
    ["finger"] = "finger",
    ["industry"] = "industrin",
    ["value"] = "värde",
    ["fight"] = "slagsmål",
    ["lie"] = "lie",
    ["beat"] = "slå",
    ["excite"] = "excitera",
    ["natural"] = "naturlig",
    ["view"] = "vy",
    ["sense"] = "känsla",
    ["capital"] = "kapital",
    ["wonâ€™t"] = "kommer inte",
    ["chair"] = "stol",
    ["danger"] = "fara",
    ["fruit"] = "frukt",
    ["rich"] = "rik",
    ["thick"] = "tjock",
    ["soldier"] = "soldat",
    ["process"] = "processen",
    ["operate"] = "fungera",
    ["practice"] = "praktiken",
    ["separate"] = "separat",
    ["difficult"] = "svårt",
    ["doctor"] = "läkare",
    ["please"] = "vänligen",
    ["protect"] = "skydda",
    ["noon"] = "middagstid",
    ["crop"] = "gröda",
    ["modern"] = "moderna",
    ["element"] = "elementet",
    ["hit"] = "hit",
    ["student"] = "studenten",
    ["corner"] = "hörn",
    ["party"] = "parti",
    ["supply"] = "försörjning",
    ["whose"] = "vars",
    ["locate"] = "lokalisera",
    ["ring"] = "ring",
    ["character"] = "karaktär",
    ["insect"] = "insekt",
    ["caught"] = "fångad",
    ["period"] = "period",
    ["indicate"] = "indikerar",
    ["radio"] = "radio",
    ["spoke"] = "talade",
    ["atom"] = "atomen",
    ["human"] = "humant",
    ["history"] = "historia",
    ["effect"] = "effekt",
    ["electric"] = "elektrisk",
    ["expect"] = "förvänta",
    ["bone"] = "ben",
    ["rail"] = "skena",
    ["imagine"] = "föreställa sig",
    ["provide"] = "tillhandahålla",
    ["agree"] = "enas",
    ["thus"] = "sålunda",
    ["gentle"] = "mild",
    ["woman"] = "kvinna",
    ["captain"] = "kapten",
    ["guess"] = "gissa",
    ["necessary"] = "nödvändig",
    ["sharp"] = "skarp",
    ["wing"] = "vinge",
    ["create"] = "skapa",
    ["neighbor"] = "granne",
    ["wash"] = "tvätt",
    ["bat"] = "slagträ",
    ["rather"] = "snarare",
    ["crowd"] = "publiken",
    ["corn"] = "majs",
    ["compare"] = "jämföra",
    ["poem"] = "dikt",
    ["string"] = "sträng",
    ["bell"] = "klocka",
    ["depend"] = "bero",
    ["meat"] = "kött",
    ["rub"] = "gnida",
    ["tube"] = "röret",
    ["famous"] = "känd",
    ["dollar"] = "dollarn",
    ["stream"] = "ström",
    ["fear"] = "rädsla",
    ["sight"] = "syn",
    ["thin"] = "tunn",
    ["triangle"] = "triangel",
    ["planet"] = "planet",
    ["hurry"] = "skynda",
    ["chief"] = "chef",
    ["colony"] = "koloni",
    ["clock"] = "klocka",
    ["mine"] = "gruva",
    ["tie"] = "slips",
    ["enter"] = "ange",
    ["major"] = "större",
    ["fresh"] = "färsk",
    ["search"] = "sök",
    ["send"] = "skicka",
    ["yellow"] = "gul",
    ["gun"] = "pistol",
    ["allow"] = "tillåta",
    ["print"] = "tryck",
    ["dead"] = "död",
    ["spot"] = "fläck",
    ["desert"] = "öken",
    ["suit"] = "kostym",
    ["current"] = "ström",
    ["lift"] = "lift",
    ["rose"] = "ros",
    ["arrive"] = "anländer",
    ["master"] = "mästare",
    ["track"] = "spår",
    ["parent"] = "förälder",
    ["shore"] = "stranden",
    ["division"] = "delning",
    ["sheet"] = "ark",
    ["substance"] = "substans",
    ["favor"] = "gynna",
    ["connect"] = "ansluta",
    ["post"] = "inlägg",
    ["spend"] = "spendera",
    ["chord"] = "ackord",
    ["fat"] = "fett",
    ["glad"] = "glad",
    ["original"] = "original",
    ["share"] = "andel",
    ["station"] = "station",
    ["dad"] = "pappa",
    ["bread"] = "bröd",
    ["charge"] = "debitera",
    ["proper"] = "ordentlig",
    ["bar"] = "baren",
    ["offer"] = "erbjudandet",
    ["segment"] = "segment",
    ["slave"] = "slav",
    ["duck"] = "anka",
    ["instant"] = "omedelbar",
    ["market"] = "marknad",
    ["degree"] = "grad",
    ["populate"] = "befolka",
    ["chick"] = "fågelunge",
    ["dear"] = "kära",
    ["enemy"] = "fiende",
    ["reply"] = "svara",
    ["drink"] = "dryck",
    ["occur"] = "inträffa",
    ["support"] = "stöd",
    ["speech"] = "tal",
    ["nature"] = "natur",
    ["range"] = "intervall",
    ["steam"] = "ånga",
    ["motion"] = "rörelse",
    ["path"] = "bana",
    ["liquid"] = "vätska",
    ["log"] = "logga",
    ["meant"] = "innebar",
    ["quotient"] = "kvoten",
    ["teeth"] = "tänder",
    ["shell"] = "skal",
    ["neck"] = "hals",
    ["oxygen"] = "syre",
    ["sugar"] = "socker",
    ["death"] = "död",
    ["pretty"] = "ganska",
    ["skill"] = "Förmåga",
    ["women"] = "kvinnor",
    ["season"] = "säsong",
    ["solution"] = "lösning",
    ["magnet"] = "magnet",
    ["silver"] = "silver",
    ["thank"] = "tack",
    ["branch"] = "gren",
    ["match"] = "matchen",
    ["suffix"] = "suffixet",
    ["especially"] = "speciellt",
    ["fig"] = "fig",
    ["afraid"] = "rädd",
    ["huge"] = "enormt",
    ["sister"] = "syster",
    ["steel"] = "stål",
    ["discuss"] = "diskutera",
    ["forward"] = "framåt",
    ["similar"] = "liknande",
    ["guide"] = "guide",
    ["experience"] = "erfarenhet",
    ["score"] = "poäng",
    ["apple"] = "äpple",
    ["bought"] = "köpt",
    ["led"] = "ledde",
    ["pitch"] = "tonhöjd",
    ["coat"] = "kappa",
    ["mass"] = "massa",
    ["card"] = "kort",
    ["band"] = "band",
    ["rope"] = "rep",
    ["slip"] = "halka",
    ["win"] = "win",
    ["dream"] = "dröm",
    ["evening"] = "kväll",
    ["condition"] = "tillstånd",
    ["feed"] = "foder",
    ["tool"] = "verktyg",
    ["total"] = "totalt",
    ["basic"] = "grundläggande",
    ["smell"] = "lukt",
    ["valley"] = "dal",
    ["nor"] = "eller",
    ["double"] = "dubbel",
    ["seat"] = "säte",
    ["continue"] = "fortsätta",
    ["block"] = "blocket",
    ["chart"] = "diagram",
    ["hat"] = "keps",
    ["sell"] = "sälja",
    ["success"] = "framgång",
    ["company"] = "företaget",
    ["subtract"] = "subtrahera",
    ["event"] = "händelse",
    ["particular"] = "särskilt",
    ["deal"] = "affär",
    ["swim"] = "simma",
    ["term"] = "term",
    ["opposite"] = "motsatt",
    ["wife"] = "fru",
    ["shoe"] = "sko",
    ["innovation"] = "innovation",
    ["spread"] = "spridning",
    ["arrange"] = "ordna",
    ["camp"] = "läger",
    ["invent"] = "uppfinna",
    ["cotton"] = "bomull",
    ["born"] = "Född",
    ["determine"] = "bestämma",
    ["quart"] = "quart",
    ["nine"] = "nio",
    ["truck"] = "lastbil",
    ["noise"] = "buller",
    ["level"] = "nivå",
    ["chance"] = "chans",
    ["gather"] = "samla",
    ["shop"] = "butik",
    ["stretch"] = "sträcka",
    ["throw"] = "kasta",
    ["shine"] = "glans",
    ["property"] = "egenskap",
    ["column"] = "kolonn",
    ["molecule"] = "molekyl",
    ["select"] = "välj",
    ["wrong"] = "fel",
    ["gray"] = "grå",
    ["repeat"] = "upprepning",
    ["require"] = "kräva",
    ["broad"] = "bred",
    ["prepare"] = "förbereda",
    ["salt"] = "salt",
    ["nose"] = "näsa",
    ["plural"] = "plural",
    ["anger"] = "ilska",
    ["claim"] = "krav",
    ["continent"] = "kontinent"    
}

englishWord = ""

OBSTACLE_TBL = {}

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]

function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Vocabulanes')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('ARLRDBD.ttf', 8, 'normal', 2)
    largeFont = love.graphics.newFont('ARLRDBD.ttf', 16, 'normal', 2)
    scoreFont = love.graphics.newFont('ARLRDBD.ttf', 32, 'normal', 2)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['correct'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['speed_up'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules

    player1 = Paddle(10, VIRTUAL_HEIGHT-70, 10, 10)

    -- place a ball in the middle of the screen
    slide = Slide(2, 0, -60, VIRTUAL_WIDTH, 60,25)

    -- initialize score variables
    player1Score = 0

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first slide)
    -- 2. 'play' (the slide is in play, bouncing between paddles)
    -- 3. 'done' (the game is over, with a victor, ready for restart)
    gameState = 'start'
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

function randomkey(tbl)
    choice = "F"
    n = 0
    for i, o in pairs(tbl) do
        n = n + 1
        if math.random() < (1/n) then 
            choice = i
        end
    end
    return choice
end

function distractors(tbl, englishWord)
    n = 0
    temptbl = {}
    temptbl2 = {}
    
    for k, v in pairs(tbl) do
        if k ~= englishWord then
            n = n + 1
            temptbl[n] = v
        end
    end
    for i = 1,slide.num_options,1 do
        randval = math.random(1,#temptbl)
        temptbl2[i] = table.remove(temptbl,randval)
    end
    return temptbl2
end

function love.update(dt)
    if gameState == 'start' then
        englishWord = randomkey(TRANSLATION_TBL)
        swedishWords = distractors(TRANSLATION_TBL,englishWord)   
    end 
    if gameState == 'play' then
        if slide:collides(player1) then
            if slide.x+(slide.width/slide.num_options)*(slide.correct-1) < player1.x+player1.width/2 and
            slide.x+(slide.width/slide.num_options)*(slide.correct) > player1.x+player1.width/2 then
                player1Score = player1Score + 1
                if player1Score % 3 == 0 and #OBSTACLE_TBL < 6 then
                    OBSTACLE_TBL[player1Score/3] = Obstacle(math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15))), math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15))), math.random(30,slide.dy))
                end
                if player1Score % 5 == 0 and slide.num_options < 5 then
                    FONT_HEIGHT = FONT_HEIGHT - 2
                    largeFont = love.graphics.newFont('ARLRDBD.ttf', FONT_HEIGHT, 'normal', 2)
                    slide = Slide(slide.num_options+1, 0, -60, VIRTUAL_WIDTH, 60, math.min(80, slide.dy*1.05))
                else
                    slide = Slide(slide.num_options, 0, -60, VIRTUAL_WIDTH, 60, math.min(80, slide.dy*1.05))
                end
                sounds['correct']:play()
                englishWord = randomkey(TRANSLATION_TBL)
                swedishWords = distractors(TRANSLATION_TBL,englishWord)
            else
                sounds['death']:play()
                gameState = 'death'
                for i = 1, #OBSTACLE_TBL,1 do
                    OBSTACLE_TBL[i]:reset()
                end
                OBSTACLE_TBL = {}
                slide:reset()
                FONT_HEIGHT = 16
            end
        end
        for i = 1, #OBSTACLE_TBL,1 do
            if OBSTACLE_TBL[i].x < 0 or OBSTACLE_TBL[i].x > VIRTUAL_WIDTH-OBSTACLE_TBL[i].width or OBSTACLE_TBL[i].y > VIRTUAL_HEIGHT then
                OBSTACLE_TBL[i]:reset()
                OBSTACLE_TBL[i].width = math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15)))
                OBSTACLE_TBL[i].width = math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15)))
            end
            if OBSTACLE_TBL[i]:collides(player1) then
                sounds['death']:play()
                gameState = 'death'
                slide:reset()
                for i = 1, #OBSTACLE_TBL,1 do
                    OBSTACLE_TBL[i]:reset()
                end
                OBSTACLE_TBL = {}
                break
            end
        end
        if player1Score == 100 then
            gameState = 'done'
            slide:reset()
            for i = 1, #OBSTACLE_TBL,1 do
                OBSTACLE_TBL[i]:reset()
            end
            OBSTACLE_TBL = {}
            FONT_HEIGHT = 16
        end
    end

    --
    -- paddles can move no matter what state we're in
    --
    -- player 1
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        player1.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        player1.dx = PADDLE_SPEED
    else
        player1.dx = 0
    end

    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        slide:update(dt)
        for i = 1, #OBSTACLE_TBL,1 do
            OBSTACLE_TBL[i]:update(dt)
        end
    end

    player1:update(dt)
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    elseif key == 'space' then
        gameState = 'start'
        slide:reset()
        -- reset scores to 0
        player1Score = 0

    elseif key == 'enter' or key == 'return' then
        if gameState == 'done' or gameState == 'death' or gameState == 'start' then
            englishWord = randomkey(TRANSLATION_TBL)
            swedishWords = distractors(TRANSLATION_TBL,englishWord)
            FONT_HEIGHT = 16
            gameState = 'play'
            -- reset scores to 0
            player1Score = 0
        end
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    -- render different things depending on which part of the game we're in
    if gameState == 'start' then
        -- UI messages
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Vocabulanes!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press space to return to this menu at any time.', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf(englishWord, 0, VIRTUAL_HEIGHT-50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'death' then
        love.graphics.setFont(scoreFont)
        love.graphics.setColor(255/255, 0, 0, 255/255)
        love.graphics.printf(englishWord, 0, VIRTUAL_HEIGHT/2-40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(TRANSLATION_TBL[englishWord], 0, VIRTUAL_HEIGHT/2+10, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to begin!', 0, VIRTUAL_HEIGHT-30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('You win!',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- show the score before ball is rendered so it can move over the text
    displayScore()
    
    player1:render()

    love.graphics.setFont(largeFont)
    slide:render(TRANSLATION_TBL, englishWord, swedishWords)

    if gameState == 'play' then
        for i = 1, #OBSTACLE_TBL,1 do
            OBSTACLE_TBL[i]:render()
        end
    end

    -- end our drawing to push
    push:finish()
end
--[[
    Renders the current score.
]]
function displayScore()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('Score: ' .. tostring(player1Score), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
