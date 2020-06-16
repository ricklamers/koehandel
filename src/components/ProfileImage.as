package components
{
	import starling.textures.Texture;

	public class ProfileImage
	{
		public var profileImageName:String;
		public var profileImageTexture:Texture;
		public function ProfileImage(name:String, texture:Texture)
		{
			profileImageName = name;
			profileImageTexture = texture;
		}
	}
}