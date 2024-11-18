/proc/LoadTGSBotConfig()
	return list(
		"name" = CONFIG_GET(string/bot_name),
		"icon" = CONFIG_GET(string/bot_icon)
	)

/datum/tgs_chat_embed/provider/author/glob
	proc/InitializeTGSBot()
		var/list/config = LoadTGSBotConfig()
		name = config["name"]
		icon_url = config["icon"]

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

	var/datum/tgs_message_content/message = new()
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	embed.author = new /datum/tgs_chat_embed/provider/author/glob()
	embed.title = "Статистика окончания раунда"
	//embed.description = "Статистика по завершённому раунду:"
	embed.colour = "#34a5c2"

	var/datum/tgs_chat_embed/field/survivors_field = new(":god_save_me:Выжившие: [num_survivors]")
	var/datum/tgs_chat_embed/field/deads_field = new(":wolf_skull:Погибшие: [num_deads]")
	var/datum/tgs_chat_embed/field/escapees_field = new(":door:Эвакуировавшиеся: [num_escapees]")
	var/datum/tgs_chat_embed/field/shuttle_escapees_field = new(":rocket:Эвакуировались на шаттле: [num_shuttle_escapees]")
	var/datum/tgs_chat_embed/field/another_escapees_field = new(":ambulance:Эвакуировались другими способами: [num_another_escapees]")
	var/datum/tgs_chat_embed/field/station_integrity_field = new(":bar_chart:Состояние станции: [station_integrity]%")

	embed.fields = list(survivors_field, deads_field, escapees_field, shuttle_escapees_field, another_escapees_field, station_integrity_field)

	send2chat(message, channel_tag)

	if (CONFIG_GET(string/roundend_chat_command_enabled))
		var/commands_string = CONFIG_GET(string/random_bot_commands)
		var/list/random_commands = list()
		for (var/command in splittext(commands_string, ","))
			random_commands += trim(command)
		var/random_command = pick(random_commands)
		var/datum/tgs_message_content/random_message = new(random_command)
		send2chat(random_message, channel_tag)
