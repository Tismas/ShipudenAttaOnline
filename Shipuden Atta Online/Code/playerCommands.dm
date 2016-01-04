#define ceil(x) (-round((-x)))

#include "playerVars.dm"
#include "playerJutsus.dm"
#include "mobs.dm"

var/tmp
	mob/clone_target = null
	list/clones


verb
	Bunshin_Attack()
		var/list/l = oviewers(6,usr) - usr:clones
		if(l.len)
			var/mob/target = input(usr,"Who should your clones attack?","Clone attack") as mob in l
			if(target)
				usr:clone_target = target
				for(var/mob/Shadowclone/m in usr:clones)
					m.target = target
	Bunshin_Follow()
		for(var/mob/Shadowclone/m in usr:clones)
			m.target = null
		usr:clone_target = null

	Bunshin_Dispear()
		for(var/mob/Shadowclone/m in usr:clones)
			m.Health = 0
			del(m)
	Activate_Cursed_Seal()
		set category = "CS"
		if(usr:csActivated)
			return
		usr:icon_state = "CSE"
		usr:csActivated = 1

	Deactivate_Cursed_Seal()
		set category = "CS"
		if(usr:csActivated)
			usr:icon_state = "male"
			usr:csActivated = 0
mob
	Player
		verb
			// Info
			Check_Genin_Exam()
				set category = "Help"
				set hidden = 1
				var/time = ceil(TimeToGeninExam/60)
				if(TimeToGeninExam>0)
					usr << "<b><font color='red' size='1'>Next exam will take place in [time] minutes</font></b>"
				else
					usr << "<font color='gray' size='1'>Exam has just started</font>"
			// Website
			ShowBrowserHelp()
				set category = "Help"
				set hidden = 1
				var/text = {"
					<style>
					* {
						padding: 0;
						margin:0;
						background-color: black;
						text-allign: center;
						decoration: none;
						text-align: center;
					}
					li{
						list-style-type: none;
					}
					</style>
					<font color='red'>
					<h4>Welcome to<h4>
					<b><h1> Shipuden Atta Online </h1></b>
					<p> Game made by Naszos&Astuli </p></br>
					<p>This game is based on Kisioj's game named Naruto Ryuu Gakure
					which is no longer mantained. If you are skilled programmer or
					graphic feel free to contact us on e-mail: shipudenattaonline@gmail.com</br>
					We encourage to follow us on any of these:</br>
					Facebook:  </br>
					Twitter:  </br>
					Instagram:  </br>
					Google+:  </br></br>
					Our subreddit:
					</br></br><hr></br>
					</font>

					<font color = 'white'>
					<h1>General</h1>
					<h3>Kage Bunshin no Jutsu</h3>
					500 nin </br>
					200 bunshin uses </br></br>

					<h3>Katon Goukakyou no Jutsu</h3>
					1500 nin </br>

					<h1>Kekkei Genkai</h1>
					<h2>Uchiha</h2>
					<h2>Hyuuga</h2>
					<h2>Nara</h2>
					<h2>Kaguya</h2>
					<h2>Aburame</h2>
					<h2>Inuzuka</h2>

					</font>
					</br>
				"}
				usr << browse(text)
			// Regular verbs
			Drop_Gold()							//	All /Item have this verb as well.
				var/amt=max(0,input("How much gold do you wish to drop? Maximum amount: [src.Money]","Item drop",1) as num|null)
				if(!amt) return 0		//	Safety checking if the item is actually in the usr's contents.
				else
					src.Money-=amt
					new/obj/Yen(src.loc,amt)
					usr << "<font size='1' color='gray'>You dropped [amt] gold.</font>"

			OOC(msg as text)
				if(!msg) return
				world << "\[<font color='aqua'>OOC</font>\] <font color='red'>[usr]</font>: [msg]"

			Say(msg as text)
				if(!msg) return
				oview() << "<font color='blue'>[usr]</font>: [msg]"
				usr << "<font color='red'>[msg]</font>"

			Whisper(mob/M as mob in oview(), msg as text)
				if(!msg || !(istype(M,/mob/Player))) return
				M << "<font color='blue'>[usr]</font>: [msg]"
				usr << "<font color='red'>[M]</font><- [msg]"
			// flick(State,usr) - attack animation
			Attack()
				set category = "Tai"
				for(var/mob/M in get_step(loc,dir))
					if(!M) return
					if(resting) return
					if(world.time - LastAttack > 5 && Stamina>0)
						var/damage = Tai
						flick("Attack",usr)
						// usr << "<font size='1' color='gray'>You did [damage] damage to [M]!</font>"
						F_damage(M, damage, "#ffffff")
						if(istype(M,/mob/Treestump))
							Stamina -= round(Stamina/30) + rand(1,150)
							if(Stamina <0)
								Stamina = 0
							AddExp("Tai")
							var/random = rand(1,10) // dodawania stamki
							if(random == 5)
								MaxStamina += rand(1,20)
							CheckExpCaps()
						if(istype(M,/mob/Player))
							M:Stamina -= damage
							M:DeathCheck()
						else
							M.Health -= damage
							M.DeathCheck()
						LastAttack = world.time
					else if(Stamina == 0)
						Stamina = 0

			Rest()
				set category = "Tai"

				if(Henged) return

				// Dodawanie Jutsu i tego typu rzeczy
				if(BunshinUses>=200 && Nin >= 100 && !(/verb/KageBunshinNoJutsu in verbs))
					world << "<b><font size='3'> You've just learnt Kage Bunshins no Jutsu! </font></b>"
					verbs += /verb/KageBunshinNoJutsu
				if(Katon>=10 && Nin >= 1500 && !(/verb/KatonGoukakyou in verbs))
					world << "<b><font size='3'> You've just learnt Katon Goukakyou no Jutsu! </font></b>"
					verbs += /verb/KatonGoukakyou
				if(Katon>=200 && Nin>=2200 && !(/verb/KatonHousenka in verbs))
					world << "<b><font size='3'> You've just learnt Katon Housenka no Jutsu! </font></b>"
					verbs += /verb/KatonHousenka

				// Rest
				if(!resting && (Health < MaxHealth || Stamina < MaxStamina || Chakra < MaxChakra) && invisibility == 0 && !WaterTraining)
					resting = 1
					icon_state = "Rest"
					usr << "<font size='1'>You sit down to rest.</font>"
					while(resting)
						sleep(10)

						Health += round(MaxHealth/12) + rand(1,10)
						Stamina += round(MaxStamina/12) + rand(1,10)
						Chakra += round(MaxChakra/12) + rand(1,10)

						if(Health>=MaxHealth)
							Health = MaxHealth
						if(Stamina>=MaxStamina)
							Stamina = MaxStamina
						if(Chakra>=MaxChakra)
							Chakra = MaxChakra

						if(Health == MaxHealth && Stamina==MaxStamina && Chakra==MaxChakra)
							resting = 0
							Stamina = MaxStamina
							Chakra = MaxChakra
							Health = Health
					usr << "<font size='1'>You have finished resting.</font>"
					icon_state = "male"

					if(ChakraControl > 100)
						ChakraControl = 100

				else
					resting = 0

			// Debugging purposes
			Back_To_Academy()
				set category = "Debug"
				loc = locate(23,19,1)
			Back_To_Spawn()
				set category = "Debug"
				loc = locate(2, 99, 1)
			Get_Shuriken()
				set category = "Debug"
				new/Item/Shuriken(src.loc)
			Get_Rock()
				set category = "Debug"
				new/Item/Rock(src.loc)
			Get_Sword()
				set category = "Debug"
				new/Item/Sword(src.loc)
			Get_CS()
				set category = "Debug"
				verbs += /verb/Activate_Cursed_Seal
				verbs += /verb/Deactivate_Cursed_Seal
			Get_Stats()
				MaxStamina = 10000
				MaxChakra = 10000
				Nin = 10000
				Gen = 10000
				Tai = 10000
				ChakraControl = 100