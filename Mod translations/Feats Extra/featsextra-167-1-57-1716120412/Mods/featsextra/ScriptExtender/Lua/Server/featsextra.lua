---@diagnostic disable: undefined-global

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_HuntersMark_feytouched_cha' then
    ApplyStatus(uuid, "FEYTOUCHED_HUNTERSMARK_CHA", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_HuntersMark_feytouched_int' then
    ApplyStatus(uuid, "FEYTOUCHED_HUNTERSMARK_INT", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_HuntersMark_feytouched_wis' then
    ApplyStatus(uuid, "FEYTOUCHED_HUNTERSMARK_WIS", -1, 1)    
    end
end)

-- FEY TOUCHED------------------

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Bless_feytouched_cha' then
    ApplyStatus(uuid, "FEYTOUCHED_BLESS_CHA", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Bless_feytouched_int' then
    ApplyStatus(uuid, "FEYTOUCHED_BLESS_INT", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Bless_feytouched_wis' then
    ApplyStatus(uuid, "FEYTOUCHED_BLESS_WIS", -1, 1)    
    end
end)

--- Add dodge, shove prone and help attack to player characters on game load 
function GetPartyMembers()
    local partymembers = {}
    local players = Osi.DB_Players:Get(nil)
    for _, player in pairs(players) do
        table.insert(partymembers, player[1])
    end
    local origins = Osi.DB_Origins:Get(nil)
    for _, origin in pairs(origins) do
        table.insert(partymembers, origin[1])
    end

--- Remove duplicates
    local seen = {}
    local i = 1
    while i <= #partymembers do
        if seen[partymembers[i]] then
            table.remove(partymembers, i)
        else
            seen[partymembers[i]] = true
            i = i + 1
        end
    end
    return partymembers
end

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditorMode)
    local partymembers = GetPartyMembers()
    for _, k in pairs(partymembers) do
        Osi.AddSpell(k, "Shout_Dodge", 1, 1)
		Osi.AddSpell(k, "Target_Shove_Prone", 1, 1)
		Osi.AddSpell(k, "Target_Help_Attack_Action", 1, 1)
	end
end)

-- Artificer Initiate Level one spells

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_AbsorbElements_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_ABSORBELEMENTS", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Throw_Catapult_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_THROWCATAPULT", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_CureWounds_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETCUREWOUNDS", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_DetectMagic_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_SHOUTDETECTMAGIC", -1, 1)    
    end
end)


Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_DisguiseSelf_Cancel' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_SHOUTDISGUISESELF", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_ExpeditiousRetreat_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_SHOUTEXPEDITIOUSRETREAT", -1, 1)    
    end
end)


Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_FaerieFire_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETFAERIEFIRE", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_FalseLife_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_SHOUTFALSELIFE", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Shout_FeatherFall_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_SHOUTFEATHERFALL", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Grease_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETGREASE", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Jump_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETJUMP", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Longstrider_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETLONGSTRIDER", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Sanctuary_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETSANCTUARY", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_Snare_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_TARGETSNARE", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function (uuid, name, _, _, _, _)
--- Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Zone_TashasCausticBrew_FE' then
    ApplyStatus(uuid, "ARTIFICER_INITIATE_ZONECAUSTICBREW", -1, 1)    
    end
end)


-- Polearm Master
Ext.Osiris.RegisterListener("UsingSpell", 5, "before", function (uuid, name, _, _, _, _)
--    Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_PolearmMaster_BonusAttack' then
    ApplyStatus(uuid, "POLEARMMASTER_CHANGE_TO_D4", -1, 1)    
    end
end)

Ext.Osiris.RegisterListener("UsingSpell", 5, "before", function (uuid, name, _, _, _, _)
--    Ext.Utils.PrintWarning("UsingSpell",character, spell)
	if name == 'Target_PolearmMaster_BonusAttack_Shillelagh' then
    ApplyStatus(uuid, "POLEARMMASTER_CHANGE_TO_SHILLELAGH", -1, 1)    
    end
end)


Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function (character, status, _, _)
		if	status == "REMOVE_POISONER_KITS" then
			TemplateRemoveFrom("c87cad16-da6c-488e-933d-86881d400134", character, 1) 
			TemplateRemoveFrom("a3974aeb-ec29-4307-9297-dddf7a59596d", character, 1) 
			RemoveSpell(character, "Shout_Remove_Poisoner_Kits", 0)
	end
end)

