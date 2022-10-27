if not EID then return end


--Lucky seven
local Sevendesc = "Whenever any of the player's pickup counts ends in a 7, Isaac has a chance to shoot golden tears that spawn special slot machines when they hit monsters"
local SevendescRu = "Всякий раз, когда один из предметов игрока заканчивается на 7, у Исаака есть шанс выстрелить золотыми слезами, которые при попадании во врагов превращают их в особые игровые автоматы"
local SevendescSpa = "Si el numero de cualquier recolectable del jugador termina en 7, se tendrá la posibilidad de lanzar una lágrima dorada que genera una máquina tragaperras especial al golpear a un enemigo"

EID:addCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN, Sevendesc, "Lucky Seven")
EID:addCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN, SevendescRu, "Счастливая семерка", "ru")
EID:addCollectible(LostItemsPack.CollectibleType.LUCKY_SEVEN, SevendescSpa, "7 de la suerte", "spa")


---Pill crusher
local PCDesc = "Gives a random {{Pill}} pill when picked up#Increase pill drop rate when held#Consumes currently held pill and applies an effect to the entire room depending on the type of pill"
local PCDescSpa = "Otorga una {{Pill}} pildora aleatoria al tomarlo#Las pildoras aparecen con mas frecuencia#Consume la pildora que posees y aplica un efecto a la sala, basado en la pildora"
local PCDescRu = "Дает случайную {{Pill}} пилюлю#Увеличивает шанс появления пилюль#Использует текущую пилюлю и накладывает зависимый от её типа эффект на всю комнату"
local PCDescPt_Br = "Gere uma pílula {{Pill}} aleatória quando pego#Almente a taxa de queda de pílulas# Consome a pílula segurada e aplique um efeito na sala inteira dependendo no tipo de pílula"

EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDesc, "Pill Crusher", "en_us")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescSpa, "Triturador de Pildoras", "spa")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescRu, "Дробилка пилюль", "ru")
EID:addCollectible(LostItemsPack.CollectibleType.PILL_CRUSHER, PCDescPt_Br, "Triturador de Pílula", "pt_br")
