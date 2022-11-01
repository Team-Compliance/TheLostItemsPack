local Translations = {}

local itemTranslations = {
    es = {
        [LostItemsPack.CollectibleType.ANCIENT_REVELATION] = {"Antigua Revelación", "Recuerda lo que solía haber"},
        [LostItemsPack.CollectibleType.BETHS_HEART] = {"Corazón de Beth", "Acumulador de fe"},
        [LostItemsPack.CollectibleType.BLANK_BOMBS] = {"Bombas de fogueo", "Entra al sótano"},
        [LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS] = {"Libro de las ilusiones", "Un ejército de ti"},
        [LostItemsPack.CollectibleType.CHECKED_MATE] = {"Rey en jaque", "Amigo ajedrezado"},
        [LostItemsPack.CollectibleType.KEEPERS_ROPE] = {"La soga de Keeper", "¡Sácales todo el dinero!"},
        [LostItemsPack.CollectibleType.LUCKY_SEVEN] = {"7 de la suerte", "La suerte favorece a la audacia"},
        [LostItemsPack.CollectibleType.PACIFIST] = {"Pacifista", "Haz el amor, no la guerra"},
        [LostItemsPack.CollectibleType.PILL_CRUSHER] = {"Triturador de píldoras", "¡Dáselas a todos!"},
        [LostItemsPack.CollectibleType.SAFETY_BOMBS] = {"Bombas de seguridad", "Es por tu propio bien"},
        [LostItemsPack.CollectibleType.VOODOO_PIN] = {"Pin de vudú", "¡Au!"}
    }
}

local queueLastFrame
local queueNow
function Translations:onUpdate(player)
	queueNow = player.QueuedItem.Item

    if queueNow then
        local translations = itemTranslations[Options.Language]
        if translations then
            local translation = translations[queueNow.ID]
            if translation and queueNow:IsCollectible() and queueLastFrame == nil then
                Game():GetHUD():ShowItemText(translation[1], translation[2])
            end
        end
    end

	queueLastFrame = queueNow
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Translations.onUpdate)