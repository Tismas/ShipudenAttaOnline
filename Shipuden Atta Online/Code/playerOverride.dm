#define ceil(x) (-round(-(x)))

#include "playerVars.dm"

mob
	Player
		Login()
			// Initializing Browser tab
			ShowBrowserHelp()
			world << "\[<font color='aqua'>SAO</font>\] <font color='red'>[usr]</font> has logged in!"

			// If new user has logged in
			loc = locate(24,80,1)
			..()

			// Reseting values
			LastAttack = world.time
			LastJutsu = world.time
			LoopCount = 0
			WaterTraining = 0
			invisibility = 0
			CoolDown = 0
			resting = 0
			speeding = 0

			sleep(1)
			// Removing clone verbs
			AddClone(new/mob/Shadowclone(src,src))
			call(/verb/Bunshin_Dispear)()

			//Updating inventory
			Inventory()
			icon = 'player.dmi'

		Logout()
			world << "\[<font color='aqua'>SAO</font>\] <font color='red'>[usr]</font> has logged out!"
			..()

		Stat()
			stat(src)
			stat("World Time:", time2text(world.realtime))
			stat("CPU Usage:", "[world.cpu]%")
			stat("Location:", "[loc.x],[loc.y]")
			stat("Age:",10)
			stat("Country:", "[Village]")
			stat("Speciality:","[Speciality]")
			stat("Rank","[Rank]")
			stat("Profession:", "None")
			stat(" ")
			stat("Stamina: ","[Stamina] / [MaxStamina]")
			stat("Chakra: ","[Chakra] / [MaxChakra]")
			stat("Chakra control: ", "[ChakraControl]%")
			stat("Taijutsu: ","[Tai]  \[[TaiExp/TaiExpNeed]%\]")
			stat("Ninjutsu: ","[Nin]  \[[NinExp/NinExpNeed]%\]")
			stat("Genjutsu: ","[Gen]  \[[GenExp/GenExpNeed]%\]")
			stat("Seal Speed", "[SealSpeed] per second")
			if(Katon>0)
				stat("Katon","[Katon]")
			if(Suiton>0)
				stat("Suiton","[Suiton]")
			if(Doton>0)
				stat("Doton","[Doton]")
			if(Raiton>0)
				stat("Raiton","[Raiton]")
			if(Fuuton>0)
				stat("Fuuton","[Fuuton]")
			stat(" ")
			if(KawarimiUses>0 || BunshinUses>0)
				stat("Jutsu uses")
			if(BunshinUses>0)
				stat("Bunshin no Jutsu","[BunshinUses]")
			if(KawarimiUses>0)
				stat("Kawarimi no Jutsu","[KawarimiUses]")
			if(KageBunshinUses>0)
				stat("Kawarimi no Jutsu","[KageBunshinUses]")
			if(KatonGoukakyouUses>0)
				stat("Katon Goukakyou no Jutsu","[KatonGoukakyouUses]")
			if(KatonHousenkaUses>0)
				stat("Katon Housenka no Jutsu", "[KatonHousenkaUses]")
			stat(" ")
			stat("Money: ","[Money] Yen")

		Move()
			if(resting) return

			// Fix wejscia do aka
			JustTeleported = 0

			// Zwolnienie chodzenia
			if(speeding <= 0)
				speeding = 1
				..()
				sleep(rundelay)
				speeding = 0
			else
				return

			// Gorka staminy
			if(hasWeights || isOnMountain && usr.dir == NORTH)
				if(rand(1,10) == 5)
					MaxStamina += rand(5,20)
			if(hasWeights || isOnMountain && usr.dir != SOUTH)
				rundelay = 5
			else
				rundelay = 2

			// Przeniesienie z respa przed akademie
			if(loc == locate(2, 99, 1))
				loc = locate(526, 534, 1)

			// Wejscie do akademii
			if(get_step(usr,dir) == locate(525,533,1))
				JustTeleported = 1
				if(Rank == "Academy Student")
					loc = locate(23,2,1)
				else
					usr << "<font size='1' color='gray'>Only academy students may enter there.</font>"
					loc = locate(525,534,1)
			if(get_step(usr,dir) == locate(526,533,1))
				JustTeleported = 1
				if(Rank == "Academy Student")
					loc = locate(24,2,1)
				else
					usr << "<font size='1' color='gray'>Only academy students may enter there.</font>"
					loc = locate(526,534,1)

			// Wyjscie z akademii
			if(get_step(usr,dir) == locate(23,1,1) && !JustTeleported)
				loc = locate(525,534,1)
			if(get_step(usr,dir) == locate(24,1,1) && !JustTeleported)
				loc = locate(526,534,1)

			// Wejscie na egzamin na genina
			var/examTime = TimeToGeninExam/60
			if(get_step(usr,dir) == locate(1,17,1))
				if(examTime == 0)
					usr << "<font color='gray' size='1'>You are late! Exam already started!</font>"
				else if(examTime <=5)
					loc = locate(18,135,1)
				else
					usr << "<font color='gray' size='1'>You need to wait for next exam which will take place in [ceil(examTime)] minutes</font>"
					loc = locate(2,17,1)
			if(get_step(usr,dir) == locate(1,16,1))
				if(examTime == 0)
					usr << "<font color='gray' size='1'>You are late! Exam already started!</font>"
				else if(examTime <=5)
					loc = locate(18,134,1)
				else
					usr << "<font color='gray' size='1'>You need to wait for next exam which will take place in [ceil(examTime)] minutes</font>"
					loc = locate(2,16,1)

			// Wyjscie z egzaminu na genina
			if(get_step(usr,dir) == locate(19,135,1))
				if(TimeToGeninExam == 0)
					usr << "<font color='gray' size='1'>You can't exit untill exam ends!</font>"
				else
					loc = locate(2,17,1)
			else if(get_step(usr,dir) == locate(19,134,1))
				if(TimeToGeninExam == 0)
					usr << "<font color='gray' size='1'>You can't exit untill exam ends!</font>"
				else
					loc = locate(2,16,1)

			// Zdobywanie kamieni
			var/wasRockThere = 0 // in the inventory
			for(var/Item/I in contents) // 1/1000 na dostanie kamienia co ruch
				if(I.type == /Item/Rock)
					wasRockThere = 1
					var/los = rand(1,1000)
					if(loc.name == "water")
						los = 0
					else if(loc.name == "gravel")
						los = rand(1,500)
					if(los == 100)
						I.amount++
						I.UpdateName()
						usr << "<font color='gray' size='1'>You've just found a rock!</font>"
			if(wasRockThere == 0)
				var/los = rand(1,1000)
				if(los == 100)
					contents.Add(new/Item/Rock)

			// Updatowanie ekwipunku
			Inventory()

		Die()
			var/obj/Yen/g = new(loc)
			g.amount = round(Money/10)
			Money -= round(Money/10)
			Health = MaxHealth
			Chakra = MaxChakra
			Stamina = MaxStamina
			WaterTraining = 0
			call(/verb/Bunshin_Dispear)()
			loc = locate(24, 99, 1) // pustka
			sleep(40)
			loc = locate(2, 99, 1) // respawn

		Del()
			call(/verb/Bunshin_Dispear)()
			..()