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
        [LostItemsPack.CollectibleType.SAFETY_BOMBS] = {"Bombas de seguridad", "Por tu propio bien, +5 bombas"},
        [LostItemsPack.CollectibleType.VOODOO_PIN] = {"Pin de vudú", "Comparte tu dolor"}
    },

    ru = {
        [LostItemsPack.CollectibleType.ANCIENT_REVELATION] = {"Древнее откровение", "Помни, что было раньше"},
        [LostItemsPack.CollectibleType.BETHS_HEART] = {"Сердце Вифании", "Аккумулятор веры"},
        [LostItemsPack.CollectibleType.BLANK_BOMBS] = {"Пустые бомбы", "Спускаемся в подвал"},
        [LostItemsPack.CollectibleType.BOOK_OF_ILLUSIONS] = {"Книга иллюзий", "Армия тебя"},
        [LostItemsPack.CollectibleType.CHECKED_MATE] = {"Шахматная фигура", "Шахматный друг"},
        [LostItemsPack.CollectibleType.KEEPERS_ROPE] = {"Веревка Хранителя", "Выбей деньги из них!"},
        [LostItemsPack.CollectibleType.LUCKY_SEVEN] = {"Счастливая семерка", "Удача благоволит смелым"},
        [LostItemsPack.CollectibleType.PACIFIST] = {"Пацифист", "Неси любовь, а не войну"},
        [LostItemsPack.CollectibleType.PILL_CRUSHER] = {"Дробилка пилюль", "Раздай их всем!"},
        [LostItemsPack.CollectibleType.SAFETY_BOMBS] = {"Безопасные бомбы", "Для твоего блага"},
        [LostItemsPack.CollectibleType.VOODOO_PIN] = {"Вуду булавка", "Ай!"}
    }
}

function Translations:onUpdate(player)
	if player.Parent then return end
    local data = player:GetData()
    if data.queueNow == nil and player.QueuedItem.Item then
        data.queueNow = player.QueuedItem.Item
        local translations = itemTranslations[Options.Language]
        if translations then
            local translation = translations[data.queueNow.ID]
            if translation and data.queueNow:IsCollectible() then
                Game():GetHUD():ShowItemText(translation[1], translation[2])
            end
        end
    elseif data.queueNow ~= nil and player.QueuedItem.Item == nil then
        data.queueNow = nil
    end
end
LostItemsPack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Translations.onUpdate)