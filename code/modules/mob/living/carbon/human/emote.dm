/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	var/ya = sanitize_russian("�")
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	//var/t_his = "its"
	//var/t_him = "it"

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return

	if(act == "oath" && src.miming)
		src.miming = 0
		for(var/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/s in src.spell_list)
			del(s)
		message_admins("[src.name] ([src.ckey]) �������� ���� ���� �������[ya]. (<A HREF='?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</a>)")
		src << "\red An unsettling feeling surrounds you..."
		return

	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "<B>[src]</B> is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			message = "<B>[src]</B> �������."
			m_type = 1

		if ("blink_r")
			message = "<B>[src]</B> �����[ya]��� �������."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> ����[ya]���[ya] � ������� [param]."
				else
					message = "<B>[src]</B> ����[ya]���[ya]"
			m_type = 1

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> ������ ����� [param]."
				else
					message = "<B>[src]</b> ������ �����."
			m_type = 1

		if ("choke")

			if(miming)
				message = "<B>[src]</B> ����[ya]��� ��������[ya] �� �����!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������[ya] � ���� � �����."
					m_type = 2
				else
					message = ("<B>[src]</B> ������ ������������� ����!")
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> �������."
				m_type = 2
				if(miming)
					m_type = 1
		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> �������[ya] ��������� � ������."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings ANGRILY!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			message = "<B>[src]</B> ������."
			m_type = 1

		if ("eyebrow")
			message = "<B>[src]</B> ��������� �����."
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B>��� �� ��������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������."
					m_type = 2
				else
					message = "<B>[src]</B> ��� ������ �����, ������� �� ����."
					m_type = 2

		if ("twitch")
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> ��������[ya]."
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> ������ � �������."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("cough")
			if(miming)
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ����[ya]��!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ��������[ya] � ������ �����, ����������� �� ������."
					m_type = 2

		if ("frown")
			message = "<B>[src]</B> �������[ya]."
			m_type = 1
		if ("nod")
			message = "<B>[src]</B> ������."
			m_type = 1

		if ("blush")
			message = "<B>[src]</B> ��������."
			m_type = 1

		if ("gasp")
			if(miming)
				message = "<B>[src]</B> �������� ���������[ya]!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ���������[ya]!"
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("deathgasp")
			if(M_ELVIS in mutations)
				src.emote("fart")
				message = "<B>[src]</B> ������� ��������..."
			if(M_HARDCORE in mutations)
				message = "<B>[src]</B> ��������� � ��������� �������, <i>'i told u i was hardcore..'</i>"
			else
				message = "<B>[src]</B> ������ �� �����, ����� ����� �������� � �������������..."
			m_type = 1

		if ("giggle")
			if(miming)
				message = "<B>[src]</B> ���� ��������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������."
					m_type = 2
				else
					message = "<B>[src]</B> ������ �����."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> � ���������� ������� �� [param]!"
			else
				message = "<B>[src]</B> � ���������� ����-�� �������."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> ��������[ya] �� [param]."
			else
				message = "<B>[src]</B> ����-�� �������."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> ������� �� [param]."
			else
				message = "<B>[src]</B> ����-�� �������."
			m_type = 1

		if ("grin")
			message = "<B>[src]</B> ���������[ya]."
			m_type = 1

		if ("cry")
			if(miming)
				message = "<B>[src]</B> ����� ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������!"
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> ��������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("laugh")
			if(miming)
				message = "<B>[src]</B> ��������� ������[ya]."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������[ya]."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2
					m_type = 2

		if ("mumble")
			message = "<B>[src]</B> ��������!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "<B>[src]</B> ��������� ������."
				m_type = 1
			if (!muzzled)
				message = "<B>[src]</B> ������!"
				m_type = 2
			else
				message = "<B>[src]</B> �����."
				m_type = 2

		if ("groan")
			if(miming)
				message = "<B>[src]</B> ��������� ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������!"
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("moan")
			if(miming)
				message = "<B>[src]</B> ��������� ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������ ������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<B>[src]</B> ��������� �� ���-��."
				else
					M.point()

				if (M)
					message = "<B>[src]</B> ��������� �� [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> ����[ya]� ���� �����."
			m_type = 1

		if("shake")
			message = "<B>[src]</B> ������ �������."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> �������� �������."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> ��������[ya]."
			m_type = 1

		if ("shiver")
			message = "<B>[src]</B> ������."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "<B>[src]</B> �������� �� �������."
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> �������� � ������!"
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> ������� �����."
					m_type = 2

		if ("sniff")
			message = "<B>[src]</B> ������."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "<B>[src]</B> ������ ����."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ����."
					m_type = 2
				else
					message = "<B>[src]</B> ���� �����."
					m_type = 2

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> �������[ya] �� ����."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> �������[ya] �������."
					m_type = 2

		if ("wink")
			message = "<B>[src]</B> �����������."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> ������."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> ������!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> �������� [M]."
				else
					message = "<B>[src]</B> �������� ���[ya]."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> �������� ���� [M]."
					else
						message = "<B>[src]</B> ����[ya]������ ���� [M]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> ���� �[ya]�� [M]."
				else
					message = "<B>[src]</B> ������� ������� ��� ����� �� ���� �[ya]��, ����� ���� ���� �[ya]�� ����. ��������!"

		if ("scream")
			if (miming)
				message = "<B>[src]</B> ������� ���� � ������ ������ �����, ��� ������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ �����."
					m_type = 2
/*
		if("milk")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M:gender == MALE)
						message = "<B>[src]</B> begins to milk [M] from his penis."

						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/penismilk/V = new/obj/item/weapon/reagent_containers/food/drinks/penismilk(M:loc)
								V.name = "[M:name]'s [V.name]"
					else if (M:gender == FEMALE)
						message = "<B>[src]</B> begins to milk [M] from her breasts."
						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/milk/V = new/obj/item/weapon/reagent_containers/food/drinks/milk(M:loc)
								V.name = "[M:name]'s [V.name]"
					else
						message = "<B>[src]</B> begins to milk [M] from their penis and breasts."
						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/soymilk/V = new/obj/item/weapon/reagent_containers/food/drinks/soymilk(M:loc)
								V.name = "[M:name]'s [V.name]"
				else
					src << "\red You must specify who you want to milk, 'say *milk-Test Dummy' for example."
*/
		if(("poo") || ("poop") || ("shit") || ("crap"))
			if (src.nutrition <= 300)
				src.emote("fart")
				m_type = 2
			else
				if (src.w_uniform)
					message = "<B>[src]</B> ��������[ya] � ���� �����!"
					playsound(src.loc, 'sound/misc/fart.ogg', 60, 1)
					playsound(src.loc, 'sound/misc/squishy.ogg', 40, 1)
					src.nutrition -= 80
					m_type = 2
				else
					message = "<B>[src]</B> ��������� �� ���!"
					playsound(src.loc, 'sound/misc/fart.ogg', 60, 1)
					playsound(src.loc, 'sound/misc/squishy.ogg', 40, 1)
					var/turf/location = src.loc

					var/obj/effect/decal/cleanable/poo/D = new/obj/effect/decal/cleanable/poo(location)
					if(src.reagents)
						src.reagents.trans_to(D, 10)

					var/obj/item/weapon/reagent_containers/food/snacks/poo/V = new/obj/item/weapon/reagent_containers/food/snacks/poo(location)
					if(src.reagents)
						src.reagents.trans_to(V, 10)

//					if(!infinitebutt)
//						src.nutrition -= 80
//						m_type = 2

					// check for being in sight of a working security camera
/*					if(seen_by_camera(src))
						// determine the name of the perp (goes by ID if wearing one)
						var/perpname = src.name
						if(src:wear_id && src:wear_id.registered)
							perpname = src:wear_id.registered
						// find the matching security record
						for(var/datum/data/record/R in data_core.general)
							if(R.fields["name"] == perpname)
								for (var/datum/data/record/S in data_core.security)
									if (S.fields["id"] == R.fields["id"])
										// now add to rap sheet
										S.fields["criminal"] = "*Arrest*"
										S.fields["mi_crim"] = "Public defecation"
										break	*/
/*
		if("cum")
			if(src.nutrition <= 300)
				message = "<B>[src]</B> attempts to cum but nothing comes out."
			else
				if (src.w_uniform)
					if (src.gender == MALE)
						t_his = "his"
						//t_him = "him"
					else if (src.gender == FEMALE)
						t_his = "her"
						//t_him = "her"
					message = "<B>[src]</B> cums in [t_his] panties."
					src.nutrition -= 80
				else
					var/obj/effect/decal/cleanable/urine/D = new/obj/effect/decal/cleanable/cum(src.loc)
					if(src.reagents)
						src.reagents.trans_to(D, 10)
					message = "<B>[src]</B> cums on the floor."
					src.nutrition -= 80
					m_type = 1
*/
				// check for being in sight of a working security camera
/*					if(seen_by_camera(src))
						// determine the name of the perp (goes by ID if wearing one)
						var/perpname = src.name
						if(src:wear_id && src:wear_id.registered)
							perpname = src:wear_id.registered
						// find the matching security record
						for(var/datum/data/record/R in data_core.general)
							if(R.fields["name"] == perpname)
								for (var/datum/data/record/S in data_core.security)
									if (S.fields["id"] == R.fields["id"])
										// now add to rap sheet
										S.fields["criminal"] = "*Arrest*"
										S.fields["mi_crim"] = "Public cumming"
										break*/

		// Needed for M_TOXIC_FART
		if("fart")
			if(src.op_stage.butt != 4)
				if(world.time-lastFart >= 400)
					var/list/farts = sanitize_russian(list("������!","������ [pick("������", "�����", "�[ya]���", "� �������������")]!","������ � ����� ���[ya]�� �����!"))
					if(miming)
						farts = list("���� ������!", "������!", "�������� ���� ��������� ����� �������� ����� �� ����� ������� �������!")
					var/fart = pick(farts)

					for(var/mob/M in view(1))
						if(M != src)
							if(!miming)
								visible_message("\red <b>[src]</b> ������ � ���� <b>[M]</b>!")
							else
								visible_message("\red <b>[src]</b> ���� ������ � ���� <b>[M]</b>!")
						else
							continue
					if(!miming)
						message = "<b>[src]</b> [fart]."
						playsound(get_turf(src), 'sound/misc/fart.ogg', 50, 1)
					else
						message = "<b>[src]</b> [fart]"
						//Mimes can't fart.
					m_type = 2
					var/turf/location = get_turf(src)
					var/aoe_range=2 // Default
					if(M_SUPER_FART in mutations)
						aoe_range+=3 //Was 5

					// If we're wearing a suit, don't blast or gas those around us.
					var/wearing_suit=0
					var/wearing_mask=0
					if(wear_suit && wear_suit.body_parts_covered & LOWER_TORSO)
						wearing_suit=1
						if (internal != null && wear_mask && (wear_mask.flags & MASKINTERNALS))
							wearing_mask=1

					// Process toxic farts first.
					if(M_TOXIC_FARTS in mutations)
						message=""
						playsound(get_turf(src), 'sound/effects/superfart.ogg', 50, 1)
						if(wearing_suit)
							if(!wearing_mask)
								src << "\red You gas yourself!"
								reagents.add_reagent("space_drugs", rand(10,50))
						else
							// Was /turf/, now /mob/
							for(var/mob/M in view(location,aoe_range))
								if (M.internal != null && M.wear_mask && (M.wear_mask.flags & MASKINTERNALS))
									continue
								if(!airborne_can_reach(location,get_turf(M),aoe_range))
									continue
								// Now, we don't have this:
								//new /obj/effects/fart_cloud(T,L)
								// But:
								// <[REDACTED]> so, what it does is...imagine a 3x3 grid with the person in the center. When someone uses the emote *fart (it's not a spell style ability and has no cooldown), then anyone in the 8 tiles AROUND the person who uses it
								// <[REDACTED]> gets between 1 and 10 units of jenkem added to them...we obviously don't have Jenkem, but Space Drugs do literally the same exact thing as Jenkem
								// <[REDACTED]> the user, of course, isn't impacted because it's not an actual smoke cloud
								// So, let's give 'em space drugs.
								M.reagents.add_reagent("space_drugs",rand(1,50))
							/*
							var/datum/effect/effect/system/smoke_spread/chem/fart/S = new /datum/effect/effect/system/smoke_spread/chem/fart
							S.attach(location)
							S.set_up(src, 10, 0, location)
							spawn(0)
								S.start()
								sleep(10)
								S.start()
							*/
					if(M_SUPER_FART in mutations)
						message=""
						playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
						visible_message("\red <b>[name]</b> hunches down and grits their teeth!")
						if(do_after(usr,30))
							visible_message("\red <b>[name]</b> ������������ [pick("������������","����������","�����������")] ������!","�� ������� [pick("������������","���������","�����������")] ������.")
							//playsound(L.loc, 'superfart.ogg', 50, 0)
							if(!wearing_suit)
								for(var/mob/living/V in view(src,aoe_range))
									shake_camera(V,10,5)
									if (V == src)
										continue
									V << "\red �� ������!"
									V.Weaken(5) // why the hell was this set to 12 christ
									step_away(V,location,15)
									step_away(V,location,15)
									step_away(V,location,15)
						else
							usr << "\red ��� ��������, ��� �� ������� �������! ��� �����!"
					lastFart=world.time
				else
					message = "<b>[src]</b> �������[ya] �������"
					m_type = 1
			else
				message = "<b>[src]</b> lets out a [pick("���������","��������������","�������","���������","�����������")] ���� �� ������������ ���������� �������."
				m_type = 2
		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,\nwink, yawn"

		else
			src << "\blue Unusable emote '[act]'. Say *help for a list."





	if (message)
		message = sanitize_multi(message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				O.show_message(message, m_type)

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  copytext(sanitize(input(usr, "This is [src]. \He is...", "Pose", null)  as text), 1, MAX_MESSAGE_LEN)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "����������� �������� ���������� ������������� ������ ��������� �� ������ ������� ����� (������ �� ��� �����)."
	set category = "IC"

	flavor_text =  copytext(sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text), 1)
