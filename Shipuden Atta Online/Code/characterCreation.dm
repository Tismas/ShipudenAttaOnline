#include "playerVars.dm"

mob
	creating_character
		base_save_allowed = 0
		Login()
			spawn()
				src.CreateCharacter()
		proc/CreateCharacter()
			var/mob/Player/new_mob = new/mob/Player()
			var/prompt_title = "New Character"
			var/help_text = "What do you want to name the character?"
			var/default_value = key
			var/char_name = input(src, help_text, prompt_title, default_value) as null|text

			if (!char_name)
				client.base_ChooseCharacter()
				return

			var/ckey_name = ckey(char_name)
			var/list/characters = client.base_CharacterNames()
			if (characters.Find(ckey_name))
				alert("You already have a character named that! Please choose another name.")
				src.CreateCharacter()
				return



			var/list/classes = list("Uchiha", "Hyuuga", "Nara", "Aburame", "Haku", "Kaguya")
			help_text = "Which class would you like to be?"
			default_value = "Uchiha"
			var/char_class = input(src, help_text, prompt_title, default_value) in classes
			switch(char_class)
				if ("Uchiha")		new_mob.Clan = "Uchiha"
				if ("Hyuuga")		new_mob.Clan = "Hyuuga"
				if ("Nara")			new_mob.Clan = "Nara"
				if ("Aburame")		new_mob.Clan = "Aburame"
				if ("Haku")			new_mob.Clan = "Haku"
				if ("Kaguya")		new_mob.Clan = "Kaguya"
			var/list/villages = list("Leaf", "Sand", "Rock", "Cloud", "Mist")
			help_text = "Choose your village?"
			default_value = "Leaf"
			var/village = input(src, help_text, prompt_title, default_value) in villages

			var/list/specializations = list("Tai", "Nin", "Gen", "All Around")
			help_text = "Choose your spaciality?"
			default_value = "All Around"
			var/spec = input(src, help_text, prompt_title, default_value) in specializations
			new_mob.Speciality = spec

			new_mob.TaiCap = 500
			new_mob.NinCap = 500
			new_mob.GenCap = 500

			if(new_mob.Speciality == "Tai")
				new_mob.TaiCap = 700
			if(new_mob.Speciality == "Nin")
				new_mob.NinCap = 700
			if(new_mob.Speciality == "Gen")
				new_mob.GenCap = 700
			if(new_mob.Speciality == "All Around")
				new_mob.TaiCap = 600
				new_mob.NinCap = 600
				new_mob.GenCap = 600

			new_mob.Village = village
			switch(village)
				if ("Leaf")			new_mob.PrimaryElement = "Katon"
				if ("Sand")			new_mob.PrimaryElement = "Fuuton"
				if ("Rock")			new_mob.PrimaryElement = "Doton"
				if ("Cloud")		new_mob.PrimaryElement = "Raiton"
				if ("Mist")			new_mob.PrimaryElement = "Suiton"

			var/list/elements = list("Katon", "Suiton", "Doton", "Raiton", "Fuuton") - new_mob.PrimaryElement
			help_text = "Choose your secondary element?"
			default_value = "Katon"
			var/element = input(src, help_text, prompt_title, default_value) in elements

			new_mob.name = char_class + " " + char_name

			switch(village)
				if ("Leaf")			new_mob.Katon = 80
				if ("Sand")			new_mob.Fuuton = 80
				if ("Rock")			new_mob.Doton = 80
				if ("Cloud")		new_mob.Raiton = 80
				if ("Mist")			new_mob.Suiton = 80
			new_mob.SecondaryElement = element
			switch(element)
				if ("Katon")			new_mob.Katon = 10
				if ("Fuuton")			new_mob.Fuuton = 10
				if ("Doton")			new_mob.Doton = 10
				if ("Raiton")			new_mob.Raiton = 10
				if ("Suiton")			new_mob.Suiton = 10
			src.client.mob = new_mob
			var/turf/first_location = locate(24, 80, 1)
			new_mob.Move(first_location)
			del(src)