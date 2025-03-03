function PetTrainingManual:CreateText(table)
	
	if(table.text == nil) then
		print("Missing text")
	end

	local parent = table.parent or self.panel_main
	local textVal = table.text
	local location = table.location or "TOPLEFT"
	local offset = table.offset or {x=0,y=0}
	local alignment = table.alignment or "LEFT"

	local myText = CreateFrame("Frame", nil, parent)
	myText:SetSize(200, 50)
	myText:SetPoint(location, offset.x , offset.y)
	local font = myText:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	font:SetText(textVal)
	font:SetPoint(location, 0 , 0)
	font:SetJustifyH(alignment)

	if(table.colour ~= nil) then
		local opacity = table.colour.opacity or 1
		font:SetTextColor(table.colour.red, table.colour.green, table.colour.blue, opacity)
	end

	if(table.style ~= nil) then
		local fontPath = table.style.font or "Fonts\\FRIZQT__.TTF"  
		local size = table.style.size or 16
		font:SetFont(fontPath, size)
	end	
end


function PetTrainingManual:CreateCheckboxGroup(data)

	local parent = data.parent or self.panel_main
	local option = data.option
	local optionValues = data.optionValues

	local location = data.location or "TOPLEFT"
	local offset = data.offset or {x=0,y=0}

	local group = {}

	for _, key in ipairs(optionValues) do
		local cb = PetTrainingManual:CreateCheckbox({
			parent = parent,
			text = key.text,			
			option = option,
			optionValue = key.value,
			checked = (key.value == self.db[option]),
			offset = {x=offset.x,y=offset.y - (#group * 20)}
		})
		table.insert(group, cb)

	    for i,v in ipairs(group) do
			v.optionGroup = group
		end		

	end

end

function PetTrainingManual:CreateCheckbox(table)
	
	if(table.text == nil) then
		print("Missing text")
	end
	if(table.option == nil) then
		print("Missing Option")
	end
	if(table.optionValue == nil) then
		print("Missing OptionValue")
	end

	local parent = table.parent or self.panel_main
	local textVal = table.text
	local option = table.option
	local optionValue = table.optionValue
	local location = table.location or "TOPLEFT"
	local offset = table.offset or {x=0,y=0}
	local checked = table.checked or false

	local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	cb.Text:SetText(textVal)
	cb:SetPoint(location, offset.x , offset.y)
	cb:SetChecked(checked)

	cb.option = option
	cb.Value = optionValue

	cb:HookScript("OnClick", function(_, btn, down)
		for _, button in ipairs(cb.optionGroup) do
			button:SetChecked(cb == button)
		end
		self.db[cb.option] = cb.Value
	end)

	return cb
end


function PetTrainingManual:CreateBorderedFrame(table)

	local location = table.location or "TOPLEFT"
	local offset = table.offset or {x=0,y=0}
	local size = table.size or {width=100,height=100}	

	local f = CreateFrame("Frame", "FizzleTestSomeFrameName", self.panel_main, "BackdropTemplate")
	f:SetSize(size.width, size.height)
	f:SetPoint(location , offset.x , offset.y)

	f:SetBackdrop({
		bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		edgeSize = 16,
	})
	f:SetBackdropColor(0, 0, 0, 0.25)
	
	return f
end	