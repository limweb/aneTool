package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;

	public class UI extends Sprite
	{
		private var _ui:AneTool ;
		
		//ane Parameter
		public var ID_TXT:TextField ;
		public var VERSION_TXT:TextField ;
		public var AIR_VERSION_TXT:TextField ;
		public var ANE_NAME_TXT:TextField ;
		public var ANE_DES_TXT:TextField ;
		public var ANE_RIGHTS_TXT:TextField ;
		
		//android
		public var JAR_PATH_TXT:TextField ;
		public var JAR_INI_TXT:TextField ;
		public var JAR_FIN_TXT:TextField ;
		public var JAR_CHECKBOX:CheckBox ;
		public var JAR_BTN:Button ;
		public var JAR_ANNEX_BTN:Button ;
		public var JAR_ANNEX_TXT:TextField ;
		public var JAR_YILAI_BTN:Button ;
		public var JAR_YILAI_TXT:TextField ;
		
		//ios
		public var IOS_PATH_TXT:TextField ;
		public var IOS_INI_TXT:TextField ;
		public var IOS_FIN_TXT:TextField ;
		public var IOS_CHECKBOX:CheckBox ;
		public var IOS_ZHENJI_CHECKBOX:CheckBox ;
		public var IOS_MONIJI_CHECKBOX:CheckBox ;
		public var IOS_BTN:Button ;
		public var IOS_ANNEX_BTN:Button ;
		public var IOS_ANNEX_TXT:TextField ;
		public var IOS_YILAI_BTN:Button ;
		public var IOS_YILAI_TXT:TextField ;
		
		//win
		public var WIN_PATH_TXT:TextField ;
		public var WIN_INI_TXT:TextField ;
		public var WIN_FIN_TXT:TextField ;
		public var WIN_CHECKBOX:CheckBox ;
		public var WIN_BTN:Button ;
		public var WIN_ANNEX_BTN:Button ;
		public var WIN_ANNEX_TXT:TextField ;
		
		//mac
		public var MAC_PATH_TXT:TextField ;
		public var MAC_INI_TXT:TextField ;
		public var MAC_FIN_TXT:TextField ;
		public var MAC_CHECKBOX:CheckBox ;
		public var MAC_BTN:Button ;
		public var MAC_ANNEX_BTN:Button ;
		public var MAC_ANNEX_TXT:TextField ;
		
		//swc
		public var SWC_PATH_TXT:TextField ;
		public var SWC_BTN:Button ;
		public var SDK_BTN:Button ;
		public var SDK_PATH_TXT:TextField ;
		
		//java
		
		public var JAVA_PATH_TXT:TextField ;
		public var JAVA_BTN:Button ;
		//cer
		public var CER_PATH_TXT:TextField ;
		public var PASSWORD_PATH_TXT:TextField ;
		public var CER_BTN:Button ;
		
		//ane
		public var ANE_PATH_TXT:TextField ;
		public var ANE_BTN:Button ;
		public var CREATE_BTN:Button ;
		public var LOG_TXT:TextField ;
		public var MAC_FUJIAN_CHECKBOX:CheckBox;
		public var WIN_FUJIAN_CHECKBOX:CheckBox;
		public var JAR_FUJIAN_CHECKBOX:CheckBox;
		public var JAR_YILAI_CHECKBOX:CheckBox;
		public var IOS_FUJIAN_CHECKBOX:CheckBox;
		public var IOS_YILAI_CHECKBOX:CheckBox;
		public var OPEN_CONFIG_BTN:Button;
		public var SAVE_CONFIG_BTN:Button;
		public var TIMESTAP:CheckBox;
		
		public function UI()
		{
			_ui = new AneTool();
			addChild(_ui);
			
			//ane Parameter
			ID_TXT = _ui.ID_TXT;
			VERSION_TXT = _ui.VERSION_TXT;
			AIR_VERSION_TXT = _ui.AIR_VERSION_TXT ;
			ANE_NAME_TXT = _ui.ANE_NAME_TXT ;
			ANE_DES_TXT = _ui.ANE_DES_TXT ;
			ANE_RIGHTS_TXT = _ui.ANE_RIGHTS_TXT ;
			
			//android
			JAR_PATH_TXT = _ui.JAR_PATH_TXT;
			JAR_INI_TXT = _ui.JAR_INI_TXT;
			JAR_FIN_TXT = _ui.JAR_FIN_TXT;
			JAR_CHECKBOX = _ui.ANDROID_CHECKBOX ;
			JAR_FUJIAN_CHECKBOX = _ui.JAR_FUJIAN_CHECKBOX ;
			JAR_YILAI_CHECKBOX = _ui.JAR_YILAI_CHECKBOX ;
			JAR_BTN =_ui.JAR_BTN ;
			JAR_ANNEX_BTN = _ui.JAR_ANNEX_BTN ;
			JAR_ANNEX_TXT = _ui.JAR_ANNEX_TXT ;
			JAR_YILAI_BTN = _ui.JAR_YILAI_BTN ;
			JAR_YILAI_TXT = _ui.JAR_YILAI_TXT ;
			
			//ios
			IOS_PATH_TXT = _ui.IOS_PATH_TXT;
			IOS_INI_TXT = _ui.IOS_INI_TXT;
			IOS_FIN_TXT = _ui.IOS_FIN_TXT;
			IOS_CHECKBOX= _ui.IOS_CHECKBOX ;
			IOS_FUJIAN_CHECKBOX = _ui.IOS_FUJIAN_CHECKBOX ;
			IOS_YILAI_CHECKBOX = _ui.IOS_YILAI_CHECKBOX ;
			IOS_BTN= _ui.IOS_BTN ;
			IOS_ANNEX_TXT = _ui.IOS_ANNEX_TXT ;
			IOS_ANNEX_BTN = _ui.IOS_ANNEX_BTN ;
			IOS_YILAI_BTN = _ui.IOS_YILAI_BTN ;
			IOS_YILAI_TXT = _ui.IOS_YILAI_TXT ;
			IOS_ZHENJI_CHECKBOX = _ui.IOS_ZHENJI_CHECKBOX ;
			IOS_MONIJI_CHECKBOX = _ui.IOS_MONIJI_CHECKBOX ;
			
			//win
			WIN_PATH_TXT= _ui.WIN_PATH_TXT;
			WIN_INI_TXT= _ui.WIN_PATH_TXT;
			WIN_FIN_TXT= _ui.WIN_PATH_TXT;
			WIN_CHECKBOX = _ui.WIN_CHECKBOX ;
			WIN_FUJIAN_CHECKBOX = _ui.WIN_FUJIAN_CHECKBOX ;
			WIN_BTN= _ui.WIN_BTN ;
			WIN_ANNEX_TXT = _ui.WIN_ANNEX_TXT ;
			WIN_ANNEX_BTN = _ui.WIN_ANNEX_BTN ;
			
			
			//mac
			MAC_PATH_TXT= _ui.MAC_PATH_TXT;
			MAC_INI_TXT= _ui.MAC_PATH_TXT;
			MAC_FIN_TXT= _ui.MAC_PATH_TXT;
			MAC_CHECKBOX= _ui.MAC_CHECKBOX;
			MAC_FUJIAN_CHECKBOX = _ui.MAC_FUJIAN_CHECKBOX ;
			MAC_BTN = _ui.MAC_BTN ;
			MAC_ANNEX_TXT = _ui.MAC_ANNEX_TXT ;
			MAC_ANNEX_BTN = _ui.MAC_ANNEX_BTN ;
			
			
			
			//swc
			SWC_PATH_TXT = _ui.SWC_PATH_TXT;
			SWC_BTN= _ui.SWC_BTN ;
			
			//java
			SDK_PATH_TXT = _ui.SDK_PATH_TXT;
			JAVA_PATH_TXT = _ui.JAVA_PATH_TXT;
			SDK_BTN =_ui.SDK_BTN ;
			JAVA_BTN = _ui.JAVA_BTN ;
			//swc
			CER_PATH_TXT = _ui.CER_PATH_TXT;
			PASSWORD_PATH_TXT = _ui.PASSWORD_PATH_TXT;
			CER_BTN=_ui.CER_BTN;
			
			//ane
			ANE_PATH_TXT = _ui.ANE_PATH_TXT;
			ANE_BTN =_ui.ANE_BTN ;
			CREATE_BTN = _ui.CREATE_BTN ;
			LOG_TXT =  _ui.LOG_TXT ;
			TIMESTAP = _ui.TIMESTAP ;
			
			OPEN_CONFIG_BTN = _ui.OPEN_CONFIG_BTN ;
			SAVE_CONFIG_BTN = _ui.SAVE_CONFIG_BTN ;
		}
	}
}