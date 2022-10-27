if not EID then return end


---Pill crusher desc
local PCDesc = "Gives a random {{Pill}} pill when picked up#Increase pill drop rate when held#Consumes currently held pill and applies an effect to the entire room depending on the type of pill"
local PCDescSpa = "Otorga una {{Pill}} pildora aleatoria al tomarlo#Las pildoras aparecen con mas frecuencia#Consume la pildora que posees y aplica un efecto a la sala, basado en la pildora"
local PCDescRu = "Дает случайную {{Pill}} пилюлю#Увеличивает шанс появления пилюль#Использует текущую пилюлю и накладывает зависимый от её типа эффект на всю комнату"
local PCDescPt_Br = "Gere uma pílula {{Pill}} aleatória quando pego#Almente a taxa de queda de pílulas# Consome a pílula segurada e aplique um efeito na sala inteira dependendo no tipo de pílula"

EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDesc, "Pill Crusher", "en_us")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescSpa, "Triturador de Pildoras", "spa")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescRu, "Дробилка пилюль", "ru")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescPt_Br, "Triturador de Pílula", "pt_br")
