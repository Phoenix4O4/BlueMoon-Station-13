/datum/design/roller_normal
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	id = "normal_roller_bed"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/roller
	category = list("Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL|DEPARTMENTAL_FLAG_SECURITY

/datum/techweb_node/base/New()
	var/extra_designs = list(
		"normal_roller_bed"
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()
