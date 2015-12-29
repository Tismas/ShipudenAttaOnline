mob
	Player
		Login()
		icon = 'player.dmi'
		icon_state = "male"

		var/tmp
			mob/clone_target = null
			list/clones

		var
			// Caps
			GeninCap = 2500
			GeninCapSpec = 3000
			GeninCapAll = 2700


			ChuninCap = 5000
			ChuninCapSpec = 6000

			JouninCap = 7500
			JouninCapSpec = 9000

			ANBUCap = 12000
			ANBUCapSpec = 14000

			KageCap = 30000
			KageCapSpec = 35000

			TaiCap
			NinCap
			GenCap
			//lists
			list
				cloneList[9]

			//stats
			Village = "Leaf"
			Speciality = "Taijutsu"
			SealSpeed = "12.2"
			PrimaryElement = "Katon"
			SecondaryElement = "Suiton"
			Clan = "Uchiha"
			Katon = 0
			Suiton = 0
			Fuuton = 0
			Doton = 0
			Raiton = 0
			Rank = "Academy Student"
			MaxHealth = 100
			Stamina = 1000
			MaxStamina = 1000
			Chakra = 100
			MaxChakra = 100
			ChakraControl = 20
			Tai = 10
			TaiExp = 0
			TaiExpNeed = 100
			Nin = 10
			NinExp = 0
			NinExpNeed = 100
			Gen = 10
			GenExp = 0
			GenExpNeed = 100
			Money = 1000

			// Uzycia jutsu
			KawarimiUses = 0
			BunshinUses = 0
			HengeUses = 0
			KageBunshinUses = 0
			KatonGoukakyouUses = 0
			KatonHousenkaUses = 0

			// poruszanie i lockowanie
			examinTaken = 0
			JustTeleported = 0
			JutsuSpeed = 10
			Henged = 0
			InitIcon
			csActivated = 0
			LastAttack = 0 // init w Login(), 0 dla pewnosci
			LastJutsu = 0
			speeding = 0
			rundelay = 2
			normalrundelay = 2
			resting = 0
			CoolDown = 0

			WaterTraining
			LoopCount = 0

			hasWeights = 0
			isOnMountain = 0