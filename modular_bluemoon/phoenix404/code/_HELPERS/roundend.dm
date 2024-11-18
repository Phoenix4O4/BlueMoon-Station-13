#define FUNNY_VIDEOS_FILE_NAME "config/bluemoon/discord_videos.json"

/proc/init_discord_videos()
	if (!fexists(FUNNY_VIDEOS_FILE_NAME))
		return null
	var/list/videos_json = json_decode(file2text(FUNNY_VIDEOS_FILE_NAME))
	if (!length(videos_json))
		return null

	var/list/contents = list()
	for (var/entry in videos_json)
		if (entry["content"])
			contents += entry["content"]

	return contents

/datum/tgs_chat_embed/provider/author/glob
	name = "Цунода вещает"
	icon_url = "https://cdn.discordapp.com/attachments/1049298549550100480/1287452387660791900/browser_UtXYhWxGEZ.png?ex=673c15b8&is=673ac438&hm=17d75b172b3da57164549e1523d4f20ad5ffb494643f0b6ee3cc8c71b1706a09&format=webp&"

/datum/controller/subsystem/ticker/proc/send_roundend_stats_tgs_message(popcount)
	if (!CONFIG_GET(string/roundend_status_enabled))
		return
	var/num_survivors = popcount[POPCOUNT_SURVIVORS]
	var/num_deads = popcount[POPCOUNT_DEADS]
	var/num_escapees = popcount[POPCOUNT_ESCAPEES]
	var/num_shuttle_escapees = popcount[POPCOUNT_SHUTTLE_ESCAPEES]
	var/num_another_escapees = popcount[POPCOUNT_ANOTHER_ESCAPEES]
	var/station_integrity = popcount["station_integrity"]
	var/channel_tag = CONFIG_GET(string/chat_roundend_notice_tag)

	var/datum/tgs_message_content/message = new(":blushcat:")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	embed.author = new /datum/tgs_chat_embed/provider/author/glob()
	embed.title = "Статистика окончания раунда"
	embed.description = " "
	embed.colour = "#34a5c2"

	var/datum/tgs_chat_embed/field/survivors_field = new(":god_save_me:Выжившие", "[num_survivors]")
	var/datum/tgs_chat_embed/field/deads_field = new(":wolf_skull:Погибшие:[num_deads]")
	var/datum/tgs_chat_embed/field/escapees_field = new(":door:Эвакуировавшиеся", "[num_escapees]")
	var/datum/tgs_chat_embed/field/shuttle_escapees_field = new(":rocket:Эвакуировались на шаттле", "[num_shuttle_escapees]")
	var/datum/tgs_chat_embed/field/another_escapees_field = new(":ambulance:Эвакуировались другими способами", "[num_another_escapees]")
	var/datum/tgs_chat_embed/field/station_integrity_field = new(":bar_chart:Состояние станции", "[station_integrity]%")

	embed.fields = list(survivors_field, deads_field, escapees_field, shuttle_escapees_field, another_escapees_field, station_integrity_field)

	send2chat(message, channel_tag)

	if (CONFIG_GET(string/roundend_chat_command_enabled))
		var/list/random_links = init_discord_videos()
		if (!random_links || !length(random_links))
			send2chat("Ошибка: не удалось загрузить ссылки из FUNNY_VIDEOS_FILE_NAME", channel_tag)
			return

		var/random_link = null
		var/attempts = 0
		while (attempts < 5)
			random_link = pick(random_links)
			var/discord_count = count_substring_occurrences(random_link, "discordapp").len
			if (discord_count <= 1)
				break
			attempts++
		var/datum/tgs_message_content/random_message = new(random_link)

		send2chat(random_message, channel_tag)

/proc/count_substring_occurrences(haystack, needle)
	var/pos = findtext(haystack, needle)
	var/count = 0
	while (pos)
		count++
		pos = findtext(haystack, needle, pos + length(needle))
	return count

#undef FUNNY_VIDEOS_FILE_NAME
