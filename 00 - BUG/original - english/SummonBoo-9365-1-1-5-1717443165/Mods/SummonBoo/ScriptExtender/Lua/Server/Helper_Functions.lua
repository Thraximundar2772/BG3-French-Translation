-- global UID storage
Hooker1 = nil
Hooker2 = nil
Hooker3 = nil
BlackJackTable = nil

-- boo quest messages
BooQuestMessages = nil
BooQuestMessageCounter = 0


-- helper functions
-- WanderingBunnies / NOT USED
function WanderAround(character)
  local x, y, z = Osi.GetPosition(character)
  if ((x ~= nil) and (y ~= nil) and (z ~= nil)) then
    Osi.CharacterMoveToPosition(character, x+Random(5)-2, y, z+Random(5)-2, "walking", "")
  end
end

-- get x and z coordinate in RotAngle direction and dist distance from character 
function GetXZcoordsForRotAngle(character, RotAngle, dist)
    -- get rotation angle of character
    local _, angley, _ = Osi.GetRotation(character)
    -- calculate x and z coords for front + RotAngle 
    local x_calc = dist * math.cos(math.rad(angley+RotAngle))
    local z_calc = dist * math.sin(math.rad(angley+RotAngle))
    return x_calc, z_calc
  end

function UpdateBnuyHandle()
  -- update bnuy handle
  local summons = Osi.DB_PlayerSummons:Get(nil)
  for _,summon in pairs(summons) do
    if(string.find(summon[1],"BooRabbit_")) then --startswith BooRabbit_
      BooBunnyID = summon[1]
    end
  end
end
  
function BooRotatingQuestMessageCounter(message)
  -- build quest text message
  if(BooQuestMessages == nil) then
    BooQuestMessages = message
    Osi.QuestMessageShow("BooQuestMessage", BooQuestMessages)
  else
    -- hide old message, start display timer for new
    BooQuestMessages = BooQuestMessages .. "\n" .. message
    Osi.QuestMessageHide("BooQuestMessage")
    Osi.TimerLaunch("BooQuestMessageShow",250)
  end

  -- restart hide timer
  if (Osi.TimerExists("BooQuestMessageHide")) then
    Osi.TimerCancel("BooQuestMessageHide")
  end
  Osi.TimerLaunch("BooQuestMessageHide",5000)
end

-- listener here to keep functions together
Ext.Osiris.RegisterListener("TimerFinished",1,"after",function(guid)
  if(guid == "BooQuestMessageHide") then
    Osi.QuestMessageHide("BooQuestMessage")
    BooQuestMessages = nil
  end
end)

Ext.Osiris.RegisterListener("TimerFinished",1,"after",function(guid)
  if(guid == "BooQuestMessageShow") then
    Osi.QuestMessageShow("BooQuestMessage",BooQuestMessages)
  end
end)

function PlayBlackJack(caster)
  -- gamble
  local dist = 0.5
  -- spawn small table in front
  local x,y,z = Osi.GetPosition(caster)
  -- why the HECK is 180° angle IN FRONT? Are devs at Larian only capable of walking backwards?
  local x_calc, z_calc = GetXZcoordsForRotAngle(caster,180,dist)
  local x_safe, y_safe, z_safe = Osi.FindValidPosition(x+x_calc, y, z+z_calc, 3, "52a7403b-1191-4114-be0c-1d5680b0d276", 0)
  if((x_safe ~= nil) and (y_safe ~= nil) and (z_safe ~= nil)) then
    if (BlackJackTable == nil) then
      -- Different table ID (Inlaid Game Table with Mat, this is included as well) "7cc5029e-bed9-4838-a974-476d868564e6"
      BlackJackTable = Osi.CreateAt("52a7403b-1191-4114-be0c-1d5680b0d276", x_safe, y_safe, z_safe, 0, 0, "")
    else
    -- check for distance to bnuy, only teleport if far away
      local table_distance = Osi.GetDistanceToPosition(BlackJackTable, Osi.GetPosition(caster))
      if (table_distance > 3) then
       Osi.TeleportToPosition(BlackJackTable, x_safe, y_safe, z_safe)
      end
    end
  end

  local win = Random(3)
  local winnings = Random(30)+1
  -- winning
  if(win == 1) then
    ApplyStatus(caster, "BOO_HAPPY_GAMBLE",5,1,caster)
    if(winnings > 26) then
      Osi.TemplateAddTo("8c68e68d-96d4-45d6-804c-5f31ac948ff3", GetHostCharacter(), 1, 1)
      BooRotatingQuestMessageCounter("Boo won A SOUL!")
    else
      Osi.AddGold(GetHostCharacter(), winnings)
      BooRotatingQuestMessageCounter("Boo won " .. winnings .. " gold!")
    end
    -- also winning, but losing gold
  elseif (win == 2) then
    Osi.RemoveGoldFromMagicPockets(GetHostCharacter(), winnings)
    ApplyStatus(caster, "BOO_HAPPY_GAMBLE",5,1,caster)
    BooRotatingQuestMessageCounter("Boo lost " .. winnings .. " gold!")
  else
    local boorage = Random(5)
    if(boorage == 0) then
      if (BooBunnyID == nil) then
        UpdateBnuyHandle()
      end
      -- FUCK THE TABLE RAAAHHHHH
      Osi.Attack(BooBunnyID, BlackJackTable, 1)
      Osi.Die(BlackJackTable)
      BlackJackTable = nil
      ApplyStatus(caster, "BOO_HAPPY_GAMBLE",5,1,caster)
      BooRotatingQuestMessageCounter("Boo destroyed the table.")
    else
      Osi.ApplyStatus(caster, "BOO_UPSET_TUMMY", 5, 1, caster)
      BooRotatingQuestMessageCounter("Boo ate some cards.")
    end
  end
end

function SummonTheHookers(caster)
  local x,y,z,x_safe,y_safe,z_safe,x_calc,z_calc
  local dist = 0.5
  -- put one at 1/3rd of a circle
  x,y,z = Osi.GetPosition(caster)
  -- Hooker 1
  x_calc, z_calc = GetXZcoordsForRotAngle(caster,0,dist)
  x_safe, y_safe, z_safe = Osi.FindValidPosition(x+x_calc, y, z+z_calc, 3, "a5330b23-b41f-4e0b-93c2-b7b717ed1dd6", 0)
  if((x_safe ~= nil) and (y_safe ~= nil) and (z_safe ~= nil)) then
    -- no hookers around, spawn them from scratch
    if(Hooker1 == nil) then
      Hooker1 = Osi.CreateAt("a5330b23-b41f-4e0b-93c2-b7b717ed1dd6", x_safe, y_safe, z_safe, 0, 0, "")
    else
    -- teleport the hooker
      Osi.TeleportToPosition(Hooker1, x_safe, y_safe, z_safe)
    end
  end
  -- Hooker 2
  x_calc, z_calc = GetXZcoordsForRotAngle(caster,120,dist)
  x_safe, y_safe, z_safe = Osi.FindValidPosition(x+x_calc, y, z+z_calc, 3, "88357ead-dcd9-4b92-b0b5-ac142eadaaa2", 0)
  if((x_safe ~= nil) and (y_safe ~= nil) and (z_safe ~= nil)) then
    if(Hooker2 == nil) then
      Hooker2 = Osi.CreateAt("88357ead-dcd9-4b92-b0b5-ac142eadaaa2", x_safe, y_safe, z_safe, 0, 0, "")
    else
      Osi.TeleportToPosition(Hooker2, x_safe, y_safe, z_safe)
    end
  end
  -- Hooker 3
  x_calc, z_calc = GetXZcoordsForRotAngle(caster,240,dist)
  x_safe, y_safe, z_safe = Osi.FindValidPosition(x+x_calc, y, z+z_calc, 3, "74a10ca6-0286-46cf-9e0a-db571eb67c9a", 0)
  if((x_safe ~= nil) and (y_safe ~= nil) and (z_safe ~= nil)) then
    if(Hooker3 == nil) then
      Hooker3 = Osi.CreateAt("74a10ca6-0286-46cf-9e0a-db571eb67c9a", x_safe, y_safe, z_safe, 0, 0, "")
    else
      Osi.TeleportToPosition(Hooker3, x_safe, y_safe, z_safe)
    end
  end
end

function UpdateBlackJackGold()
  local cash = Osi.PartyGetGold(GetHostCharacter())
  --try update bnuy handle
  if(BooBunnyID == nil) then
    UpdateBnuyHandle()
  end
  -- failsave
  if(BooBunnyID ~= nil) then
    if cash >= 25 and cash ~= nil then
      Osi.ApplyStatus(BooBunnyID,"BOO_BLACKJACK_GOLDCOST",-1.0,1,BooBunnyID)
    elseif cash ~= nil and Osi.HasActiveStatus(BooBunnyID,"BOO_BLACKJACK_GOLDCOST") == 1  then
      Osi.RemoveStatus(BooBunnyID,"BOO_BLACKJACK_GOLDCOST")
    end
  end
end