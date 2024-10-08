--- STEAMODDED HEADER
--- MOD_NAME: Mor jokers
--- MOD_ID: morjkrs
--- PREFIX: mor
--- MOD_AUTHOR: [Morpline, elbe]
--- MOD_DESCRIPTION: Adds mor jokers. Thanks to Blizzow for the joker code. Idk if he was the original author, but I stole it from him. 
--- BADGE_COLOR: 055db5

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas({
    key = "MorJokers",
    atlas_table = "ASSET_ATLAS",
    path = "MorJokers.png",
    px = 71,
    py = 95
  })

  SMODS.Atlas({
    key = "CopyMachine",
    atlas_table = "ASSET_ATLAS",
    path = "copymachine.png",
    px = 71,
    py = 95
  })

  SMODS.Atlas({
    key = "ExtraBattery",
    atlas_table = "ASSET_ATLAS",
    path = "extra-battery.png",
    px = 71,
    py = 95
  })

local j_copymachine = SMODS.Joker{
	name = "Copy Machine",
	key = "copymachine",
    config = {extra={ name = "Copy Machine" }},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Copy Machine",
        text = {
            "Randomly copies the effects of your",
            "other {C:attention}Jokers{}"
		},
	},
	rarity = 1,
	cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = false,
	perishable_compat = true,
	atlas = "CopyMachine",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.name } }
	end,
	calculate = function(self, card, context)
        if G.STATE == G.STATES.DRAW_TO_HAND then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    other_joker = G.jokers.cards[math.random(1,#G.jokers.cards)]
                end
            end
            if other_joker and other_joker ~= card then
                card.ability.extra.name = other_joker.ability.name
            end
        end
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == card.ability.extra.name then
                other_joker = G.jokers.cards[i]
            end
        end
        if other_joker then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card
            if context.blueprint > #G.jokers.cards + 1 then return end
            local other_joker_ret, trig = other_joker:calculate_joker(context)
            if other_joker_ret or trig then
                if not other_joker_ret then
                    other_joker_ret = {}
                end
                other_joker_ret.no_callback = true
                other_joker_ret.card = context.blueprint_card or self
                other_joker_ret.colour = G.C.BLUE
                return other_joker_ret
            end
        end
	end,
}

if JokerDisplay then
    JokerDisplay.Definitions["j_copymachine"] = {
        calc_function = function(card)
            local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
            card.joker_display_values.blueprint_compat = localize('k_incompatible')
            JokerDisplay.copy_display(card, copied_joker, copied_debuff)
        end,
        get_blueprint_joker = function (card)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == card.ability.extra.name then
                    return G.jokers.cards[i]
                end
            end
        end
    }
end

-- local j_mysteryportal = SMODS.Joker{
-- 	name = "Mystery Portal",
-- 	key = "mysteryportal",
--     config = {extra={ name = "Mystery Portal" }},
--     pos = { x = 0, y = 0 },
-- 	loc_txt = {
--         name = "Mystery Portal",
--         text = {
--             "Does something random based on other",
--             "{C:attention}Jokers{}",
--             "Prepare for a lot of clicking..."
-- 		},
-- 	},
-- 	rarity = 1,
-- 	cost = 4,
--     unlocked = true,
--     discovered = false,
-- 	blueprint_compat = true,
-- 	perishable_compat = true,
-- 	atlas = "MorJokers",
-- 	loc_vars = function(self, info_queue, center)
-- 		return { vars = { center.ability.extra.name } }
-- 	end,
-- 	calculate = function(self, card, context)
--         if G.STATE == G.STATES.DRAW_TO_HAND then
--             local other_joker =G.P_CENTERS[mpjokers[math.random(1,#mpjokers)]]
--             if other_joker and other_joker ~= card then
--                 card.ability.extra.name = other_joker.key
--             end
--         end
--         local other_joker = G.Centers[card.ability.extra.name]
--         if other_joker then
--             print("joker: " .. other_joker.name)
--             context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
--             context.blueprint_card = context.blueprint_card or card
--             if context.blueprint > #G.jokers.cards + 1 or not other_joker.calculate_joker then return end
--             local other_joker_ret, trig = other_joker:calculate_joker(context)
--             print("ability: " .. other_joker.ability.name)
--             if other_joker_ret or trig then
--                 if not other_joker_ret then
--                     other_joker_ret = {}
--                 end
--                 other_joker_ret.no_callback = true
--                 other_joker_ret.card = context.blueprint_card or self
--                 other_joker_ret.colour = G.C.BLUE
--                 return other_joker_ret
--             end
--         end

--     end
-- }

--[[
if JokerDisplay then
    JokerDisplay.Definitions["j_mysteryportal"] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
            { text = ")" }
        },
        calc_function = function(card)
            local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
            --card.joker_display_values.blueprint_compat = localize('k_incompatible')
            --JokerDisplay.copy_display(card, copied_joker, copied_debuff)
        end,
        get_blueprint_joker = function (card)
            return G.P_CENTERS[card.ability.extra.name]
        end
    }
end
]]

local j_betterboots = SMODS.Joker{
	name = "Better Boots",
	key = "betterboots",
    config = {extra={name = "Better Boots",chips = 25}},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Better Boots",
        text = {
            "Upgrades already upgraded cards by #1#",
		},
	},
	rarity = 3,
	cost = 7,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "MorJokers",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if not (context.other_card.ability.perma_bonus == 0) then
                    context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
                    fakemessage("Upgrade!",context.other_card,G.C.ORANGE)
                    delay(0.6)
                end
            end
        end
	end,
}

local j_everythingjoker = SMODS.Joker{
	name = "Everything Joker",
	key = "everythingjoker",
    config = { extra={ mult=4 }},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Everything Joker",
        text = {
            "Played cards give {C:mult}+#1# Mult{}",
		},
	},
	rarity = 3,
	cost = 7,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "MorJokers",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
	end,
}

if JokerDisplay then
    JokerDisplay.Definitions["j_everythingjoker"] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    mult = mult +
                        card.ability.extra.mult *
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
            card.joker_display_values.mult = mult
        end
    }
end

local j_sevenoclocknews = SMODS.Joker{
	name = "Seven O'Clock News",
	key = "sevenoclocknews",
    config = { extra={ name = "sevenoclocknews", chance = 2}},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Seven O'Clock News",
        text = {
            "Scored {C:attention}7s{} without",
            "a seal have a {C:green}#1# in #2#{}",
            "chance to recieve a {C:purple}random seal{}.",
            "{C:inactive}Idea by {C:green}NEWTU{C:inactive} on the Balatro Discord"
		},
	},
	rarity = 2,
	cost = 5,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "MorJokers",
	loc_vars = function(self, info_queue, center)
		return { vars = { ''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.chance } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 7)
         and (context.other_card:get_seal() == nil) and not (context.other_card.debuff)
         and (math.random((G.GAME and G.GAME.probabilities.normal or 1),2)==2) then
            local random_seal = pseudorandom_element(G.P_CENTER_POOLS.Seal, pseudoseed('stdsealtype'))
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_card:juice_up()
                    context.other_card:set_seal(random_seal.key, true)
                    return true
                end
            }))
            fakemessage("Breaking!",card,G.C.ORANGE)
            delay(0.6)
        end
	end,
}

local j_extrabattery = SMODS.Joker{
	name = "Extra Battery",
	key = "extrabattery",
    config = {extra={ repeats=1 }},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Extra Battery",
        text = {
            "{C:attention}Retrigger all played cards #1# time{}",
		},
	},
	rarity = 4,
	cost = 10,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "ExtraBattery",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.repeats } }
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repeats,
                card = context.other_card
            }
        end
	end,
}


function fakemessage(_message,_card,_colour)
    G.E_MANAGER:add_event(Event({ trigger = 'after',delay = 0.15,       
        func = function() card_eval_status_text(_card, 'extra', nil, nil, nil, {message = _message, colour = _colour, instant=true}); return true
        end}))
    return
end

mpjokers = {}
mpcards = {}
function calcMPjokers()
    for k, v in pairs(G.P_CENTERS) do
        -- print("morjokers.lua","looking at "..k)
        if not (string.find(k,"j_") == nil) then
            -- print("morjokers.lua","adding"..k.."to mpjokers")
            table.insert(mpjokers,k)
        end
    end
end

function SMODS.INIT.MorJokers()
    calcMPjokers()
    --Create and register jokers

    --Create sprite atlas
    --SMODS.Sprite:new("MorJokers", SMODS.findModByID("morjkrs").path, "MorJokers.png", 71, 95, "asset_atli"):register()
end	
----------------------------------------------
------------MOD CODE END----------------------
