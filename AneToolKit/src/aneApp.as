package
{
	import flash.display.Sprite;
	
	public class aneApp extends Sprite
	{
		private var _ui:UI ;
		private var _uiManager:UIManager ;
		public function aneApp()
		{
			_ui = new UI ;
			this.addChild(_ui);
			
			_uiManager = new UIManager(_ui,stage);
		}
	}
}