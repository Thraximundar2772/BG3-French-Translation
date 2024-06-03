-- global vars
BooBunnyID = nil
Bnuyspawns = 30
BnuyID = "35bf6dea-cac0-4cf0-bf8f-789aef48774d"
BnuyFleeCooldown = 0

The_Bnuys = {}
BnuyFleeList = {}

local function OnSessionLoaded()
  _P("Summon Boo mod loaded!")
end

-- on load, add spell
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
  local players = Osi.DB_Players:Get(nil)
  local mainchar = {}
  for _, player in pairs(players) do
    table.insert(mainchar, player[1])
  end
  for _, player in pairs(mainchar) do
    if(player ~= nil) then
     if (Osi.HasSpell(player, "Target_FindFamiliar_RabbitBoo") == 0) then
       Osi.AddSpell(player, "Target_FindFamiliar_RabbitBoo", 1, 1)
     end
     break
    end
  end
  UpdateBnuyHandle()
  UpdateBlackJackGold()
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
    if (spell == "Shout_BooRabbit_SummonHookers") then
        SummonTheHookers(caster)

    elseif (spell == "Shout_BooRabbit_PlayBlackjack") then
        PlayBlackJack(caster)

    elseif (spell == "Target_FindFamiliar_RabbitBoo") then
      --this update seems to fail a lot? Set 1 second timer to retry
      BooBunnyID = nil
      UpdateBnuyHandle()
      UpdateBlackJackGold()
      Osi.TimerLaunch("BnuyTimer",1000) -- for safety

    elseif (spell == "Shout_Dismiss_Self") then
      if(BooBunnyID ~= nil) then
        if(caster == BooBunnyID) then
          BooBunnyID = nil
        end
      end
    -- WanderingBunnies / NOT USED
    elseif (spell == "Shout_BooRabbit_UNLEASHBNUYS") then
      if (BooBunnyID ~= nil) then
        for i=Bnuyspawns,1,-1 do
          local x,y,z = Osi.GetPosition(caster)
          local x_rng = Random(20) - 10
          local z_rng = Random(20) - 10
          local x_safe, y_safe, z_safe = Osi.FindValidPosition(x+x_rng, y, z+z_rng, 4, BnuyID, 1)
          if (x_safe ~= nil) and (y_safe ~= nil) and (z_safe ~= nil) then
            local bnuy = Osi.CreateAt(BnuyID, x_safe, y_safe, z_safe, 0 ,1,"")
            table.insert(The_Bnuys,bnuy)
          end
        end
        Osi.TimerLaunch("BnuyTimer_moving",1000)
        if (Osi.TimerExists("BnuysExpired")) then
          Osi.TimerCancel("BnuysExpired")
        end
        --Osi.TimerLaunch("BnuysExpired",30000)
      end
    end
end)

-- WanderingBunnies / NOT USED
Ext.Osiris.RegisterListener("TimerFinished",1,"after",function(guid)
  if(guid == "BnuyTimer") then
      UpdateBnuyHandle()
      UpdateBlackJackGold()
      Osi.TimerLaunch("BnuyTimer",10000)
  elseif(guid == "BnuysExpired") then
    _P("delete all the bunnies")
    for _,bnuy in pairs(The_Bnuys) do
      if(Osi.Exists(bnuy)) then -- if bnuy in table exists
        Osi.DisappearOutOfSightTo(bnuy, bnuy, "", 0, "")
      end
    end
  elseif(guid=="BnuyTimer_moving") then
    for key,j in pairs(The_Bnuys) do
      if(Osi.Exists(j)) then -- if bnuy in table exists
        if(Random(3) == 0) then
          WanderAround(j)
        end
      else
        table.remove(The_Bnuys,key) -- else delete bnuy
      end
    end
    Osi.TimerLaunch("BnuyTimer_moving",1000+Random(1500))
  end
end)

-- Gold Tracking
Ext.Osiris.RegisterListener("GoldChanged", 2, "after", function (_, _)
    UpdateBlackJackGold()
end)

-- Gold Tracking 2
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, _)
    if level ~= "SYS_CC_I" then
        UpdateBlackJackGold()
    end
end)

-- Gold Tracking 3
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function (_)
    UpdateBlackJackGold()
end)

-- Gold Check after Removal
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function (_, status, _, _)
	if ((status == "BOO_HAPPY_GAMBLE") or (status == "BOO_UPSET_TUMMY")) then
        UpdateBlackJackGold()
    end
end)

-- Boo gets attacked
Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, _, _, _, _, _, _)
  if ((BooBunnyID ~= nil) and (BnuyFleeCooldown == 0)) then
    if(defender == BooBunnyID) then
      for i=6,1,-1 do
        local bnuy = Osi.CreateAtObject(BnuyID, BooBunnyID, 1, 0, "", 1)
        table.insert(BnuyFleeList,bnuy)
      end
    end
    BnuyFleeCooldown = 1
    Osi.TimerLaunch("BnuyDespawnTimer",5000)
    Osi.TimerLaunch("BnuyFleeTimer",250)
  end
end)

Ext.Osiris.RegisterListener("TimerFinished",1,"after",function(guid)
  if(guid == "BnuyFleeTimer") then
    for _,bnuy in pairs(BnuyFleeList) do
      Osi.FleeFromObject(bnuy, BooBunnyID, 30)
    end
  elseif(guid == "BnuyDespawnTimer") then
    for _,bnuy in pairs(BnuyFleeList) do
      if(Osi.Exists(bnuy)) then
        Osi.DisappearOutOfSightTo(bnuy, bnuy, "", 0, "")
      end
    end
    BnuyFleeList = {}
    BnuyFleeCooldown = 0
  end
end)



Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
