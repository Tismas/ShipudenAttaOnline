#include "playerVars.dm"
#include "playerProc.dm"

verb
	CancelHenge()
		set category = "Gen"
		set name = "Cancel Henge"

		if(usr:Henged)
			usr:Henged = 0
			usr:verbs -= /verb/CancelHenge
	KageBunshinNoJutsu()
		set category = "Nin"
		set name = "Kage Bunshin no Jutsu"
		if(usr:resting) return
		if(world:time - usr:LastJutsu > usr:CoolDown && usr:Chakra>=25)
			usr:LastJutsu = world.time
			usr:CoolDown = 10

			if(usr:clones && usr:clones.len==8)
				usr << "<font color='gray' size='1'>You can only create 8 bunshins</font>"
				return

			usr << "<font color='gray' size='1'>You are performing seals... </font>"
			sleep(usr:JutsuSpeed)
			// TODO seals animation

			if(usr:DrainChakra(25))
				usr:CoolDown = 20

				view() << "<b>[src]: Kage Bunshin no Jutsu!</b>"
				var/place = get_step_rand(src)
				var/tries = 0
				while(place == null && tries < 10)
					place = get_step_rand(src)
					tries++
				if(tries == 10)
					place = get_step(src,src:dir)
				var/mob/clone = new/mob/Shadowclone(place,src)
				clone:icon = usr:icon
				clone:icon_state = "male"
				clone:name = "[usr] kage bunshin"
				clone:Health = usr:Stamina/8
				clone:kage = 1
				clone:Tai = usr:Tai
				usr:AddClone(clone)
				usr:KageBunshinUses++

				usr:AddExp("Nin")
				usr:CheckExpCaps()
				usr:AddChakraCC()

	KatonGoukakyou()
		set category = "Nin"
		set name = "Katon Goukakyou no Jutsu"

		if(usr:resting) return
		if(world.time - usr:LastJutsu > usr:CoolDown && usr:Chakra>=50)
			usr:LastJutsu = world.time
			usr:CoolDown = 10

			usr << "<font color='gray' size='1'>You are performing seals...</font>"
			sleep(usr:JutsuSpeed)
			// TODO seals animation

			if(usr:DrainChakra(50))
				usr:CoolDown = 20

				usr:KatonGoukakyouUses++
				view() << "<b>[src]: Katon Goukakyou no Jutsu!</b>"

				usr:Katon++
				usr:AddExp("Nin")
				usr:CheckExpCaps()
				usr:AddChakraCC()

				var/origin = get_step(src,usr:dir)
				var/maxDist
				if(usr:ChakraControl >= 100)
					maxDist = 8
				else
					maxDist = 4
				var fireball = new/obj/katon(usr:loc, usr:dir, src)
				while(fireball && get_dist(origin,fireball:loc) < maxDist)
					step(fireball,fireball:dir,32)
					sleep(1)
				del(fireball)

	KatonHousenka(mob/M as mob in oview())
		set category = "Nin"
		set name = "Katon Housenka no Jutsu"

		if(usr:resting) return
		if(world.time - usr:LastJutsu > usr:CoolDown && usr:Chakra>=80)
			usr:LastJutsu = world.time
			usr:CoolDown = 10

			usr << "<font color='gray' size='1'>You are performing seals... </font>"
			sleep(usr:JutsuSpeed)
			// TODO seals animation

			if(usr:DrainChakra(80))
				usr:CoolDown = 20

				usr:KatonHousenkaUses++
				view() << "<b>[src]: Katon Housenka no Jutsu!</b>"

				usr:Katon++
				usr:AddExp("Nin")
				usr:CheckExpCaps()
				usr:AddChakraCC()

				var/origin = get_step(src,usr:dir)
				var/maxDist
				if(usr:ChakraControl >= 100)
					maxDist = 12
				else
					maxDist = 4
				var fireball = new/obj/katon(usr:loc, usr:dir, src)
				var firstFireball = world.timeofday
				var fireball2 = null
				var fireball3 = null
				var/dest = M.loc
				while(fireball || fireball2 || fireball3 || world.timeofday - firstFireball < 8)
					if(world.timeofday - firstFireball == 3)
						fireball2 = new/obj/katon(usr:loc, usr:dir, src)
					if(world.timeofday - firstFireball == 6)
						fireball3 = new/obj/katon(usr:loc, usr:dir, src)
					if(fireball)
						step_to(fireball,dest,0,32)
						if(fireball && (get_dist(origin,fireball:loc) == maxDist || fireball:loc == dest))
							del(fireball)
					if(fireball2)
						step_to(fireball2,dest,0,32)
						if(fireball2 && (get_dist(origin,fireball2:loc) == maxDist || fireball2:loc == dest))
							del(fireball2)
					if(fireball3)
						step_to(fireball3,dest,0,32)
						if(fireball3 && (get_dist(origin,fireball3:loc) == maxDist || fireball3:loc == dest))
							del(fireball3)
					sleep(1)
				del(fireball3)

mob
	Player
		verb
			// Basic Jutsus that player has on the beginning
			BunshinNoJutsu()
				set category = "Gen"
				set name = "Bunshin no Jutsu"
				if(resting) return
				if(world.time - LastJutsu > CoolDown && Chakra>=20)
					LastJutsu = world.time
					CoolDown = 10

					if(usr:clones && usr:clones.len==8)
						usr << "<font color='gray' size='1'>You can only create 8 bunshins</font>"
						return

					usr << "<font color='gray' size='1'>You are performing seals... </font>"
					sleep(usr:JutsuSpeed)
					// TODO seals animation

					if(DrainChakra(20))
						CoolDown = 20

						view() << "<b>[src]: Bunshin no Jutsu!</b>"
						var/place = get_step_rand(src)
						while(place==null)
							place = get_step_rand(src)
						var/mob/clone = new/mob/Shadowclone(place,src)
						clone:icon = usr:icon
						clone:icon_state = "male"
						clone:name = "[src] bunshin"
						clone:Health = usr:Stamina/10
						clone:kage = 0
						clone:Tai = Tai
						AddClone(clone)
						BunshinUses++
						usr:AddExp("Gen")
						usr:CheckExpCaps()
						usr:AddChakraCC()

			KawarimiNoJutsu()
				set category = "Nin"
				set name = "Kawarimi no Jutsu"

				if(resting) return
				if(world.time - LastJutsu > CoolDown && Chakra>=10)
					LastJutsu = world.time
					CoolDown = 20

					usr << "<font color='gray' size='1'>You are performing seals... </font>"
					sleep(usr:JutsuSpeed)
					// TODO seals animation

					if(DrainChakra(10))
						CoolDown = 80

						view() << "<b>[src]: Kawarimi no Jutsu!</b>"
						KawarimiUses++
						usr:AddExp("Nin")
						usr:CheckExpCaps()
						usr:AddChakraCC()
						invisibility = 100
						sleep(45) // 1.5 sekundy
						invisibility = 0

			HengeNoJutsu(mob/M as mob in view())
				set category = "Gen"
				set name = "Henge no Jutsu"

				if(resting) return
				if(world.time - LastJutsu > CoolDown && Chakra>=10)
					LastJutsu = world.time
					CoolDown = 20

					usr << "<font color='gray' size='1'>You are performing seals... </font>"
					sleep(usr:JutsuSpeed)
					// TODO seals animation

					if(DrainChakra(10))
						CoolDown = 80

						view() << "<b>[src]: Kawarimi no Jutsu!</b>"
						HengeUses++
						usr:AddExp("Gen")
						usr:CheckExpCaps()
						usr:AddChakraCC()

						if(!usr:Henged)
							InitIcon = usr:icon
						usr:icon = M.icon
						usr:Henged = 1
						verbs += /verb/CancelHenge
						while(Chakra>=10 && usr:Henged)
							Chakra -= 10
							sleep(20)
						usr:icon = InitIcon