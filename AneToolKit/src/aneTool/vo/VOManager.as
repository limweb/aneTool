package aneTool.vo
{
	import flash.net.registerClassAlias;

	public class VOManager
	{
		public function VOManager()
		{
		}
		
		public static function regVO():void{
			registerClassAlias("vo.PrePkgAneConfigData",PkgAneConfigData);
			registerClassAlias("vo.PkgAneProgressMessage",PkgAneProgressMessage);
		}
	}
}