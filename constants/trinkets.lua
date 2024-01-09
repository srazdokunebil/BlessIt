vr.trinkets = {}

vr.trinkets.available = {}

vr.trinkets.numberOfTrinkets = 0;

function vr.trinkets.ScanTrinkets()
	local idx,i,j,k,texture = 1
	local itemLink,itemID,itemName,equipSlot,itemTexture

	-- go through bags and gather trinkets into .BaggedTrinkets
	for i=0,4 do
		for j=1,GetContainerNumSlots(i) do
			itemLink = GetContainerItemLink(i,j)

			if itemLink then
				_,_,itemID,itemName = string.find(GetContainerItemLink(i,j) or "","item:(%d+).+%[(.+)%]")
				_,_,_,_,_,_,_,equipSlot,itemTexture = GetItemInfo(itemID or "")
				if equipSlot=="INVTYPE_TRINKET" then
					if not vr.trinkets.available[idx] then
						vr.trinkets.available[idx] = {}
					end
					vr.trinkets.available[idx].bag = i
					vr.trinkets.available[idx].slot = j
					vr.trinkets.available[idx].name = itemName
					vr.trinkets.available[idx].texture = itemTexture
					idx = idx + 1
                    --vr.log.Debug("trinket: +" .. itemName);
				end
			end
		end
	end
    vr.trinkets.numberOfTrinkets = idx - 1;
end

function vr.trinkets.ReportTrinkets()
    for i = 1, table.getn(vr.trinkets.available) do
        vr.log.Debug(vr.trinkets.available[i].name)
    end
end

function vr.trinkets.HaveTrinket(trinketName)
    for i = 1, vr.trinkets.numberOfTrinkets do
        if vr.trinkets.available[i].name == trinketName then
            return true;
        end
    end
    return false;
end


-- vr.trinkets = {
--     DraconicInfusedEmblem = "Draconic Infused Emblem",
--     ScrollsOfBlindingLight = "Scrolls of Blinding Light",
--     ZandalarianHeroCharm = "Zandalarian Hero Charm",
-- }


-- function Account:Withdraw (v)
--     self.balance = self.balance - v
-- end

-- function Account:New (o)
--     o = o or {}   -- create object if user does not provide one
--     setmetatable(o, self)
--     self.__index = self
--     return o
-- end