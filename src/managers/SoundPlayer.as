package managers
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class SoundPlayer
	{
		private var clockSound:Sound;

		private var clockSoundC:SoundChannel;

		private var hammerSound:Sound;

		private var moneySound:Sound;
		public function SoundPlayer()
		{
		}
		public function playAnimalSound(name:String):void{
			var animalSound:Sound;
			switch(name){
				case "cow":
					animalSound = new Assets.AnimalSoundCow();
					break;
				case "dog":
					animalSound = new Assets.AnimalSoundDog();
					break;
				case "chicken":
					animalSound = new Assets.AnimalSoundChicken();
					break;
				case "donkey":
					animalSound = new Assets.AnimalSoundDonkey();
					break;
				case "goat":
					animalSound = new Assets.AnimalSoundGoat();
					break;
				case "sheep":
					animalSound = new Assets.AnimalSoundSheep();
					break;
				case "pig":
					animalSound = new Assets.AnimalSoundPig();
					break;
				case "cat":
					animalSound = new Assets.AnimalSoundCat();
					break;
				case "horse":
					animalSound = new Assets.AnimalSoundHorse();
					break;
				case "duck":
					animalSound = new Assets.AnimalSoundDuck();
					break;
			}
			animalSound.play(0,0);
		}
		public function playHammer():void{
			if(hammerSound == null){
			hammerSound = new Assets.HammerSound();
			}
			hammerSound.play(0,0);
		}
		public function playMoneySound():void{
			if(moneySound == null){
			moneySound = new Assets.MoneySoundEffect();
			}
			moneySound.play(0,0);
		}
		public function playClock():void{
			if(clockSound == null){
			clockSound = new Assets.ClockSound();
			}
			clockSoundC = clockSound.play(0,0);
		}
		public function stopClock():void{
			if(clockSoundC != null){
				clockSoundC.stop();
			}
		}
	}
}