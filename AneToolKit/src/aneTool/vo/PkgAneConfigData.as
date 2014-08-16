package aneTool.vo
{

	public class PkgAneConfigData
	{
		
		public function PkgAneConfigData(){
			
		}
		
		public var swcFilePath:String="";
		public var javaFilePath:String="";
		public var flexOrAirSdkFilePath:String="";
		public var adtFilePath:String="";
		public var certFilePath:String="";
		public var certPassword:String="";
		public var aneExportPath:String="";
		public var aneAirVersion:String="";
		public var aneName:String="";
		public var aneDesc:String="";
		public var aneCopyright:String="";
		public var aneDescFileContent:String="";
		public var aneId:String="";
		public var aneVersion:String="";
		
		public var selectAndroidPlatform:Boolean=false;
		public var androidExtNativeLibFilePath:String="";
		public var androidExtInitializer:String="";
		public var androidExtFinalizer:String="";
		public var androidExtSelectAttachments:Boolean=false;
		public var androidExtAttachments:String="";
		public var androidExtSelectDepends:Boolean=false;
		public var androidExtDepends:String="";//Android Java 依赖项，依赖项均为Java格式的jar文件，不能为dex格式
		
		public var selectiOSPlatform:Boolean=false;
		public var iOSExtUseRealDevice:Boolean=true;
		public var iOSExtNativeLibFilePath:String="";
		public var iOSExtInitializer:String="";
		public var iOSExtFinalizer:String="";
		public var iOSExtSelectAttachments:Boolean=false;
		public var iOSExtAttachments:String="";
		public var iOSExtSelectPlatformOptionsFile:Boolean=false;
		public var iOSExtPlatformOptionsFilePath:String="";
		
		public var selectWindowsPlatform:Boolean=false;
		public var windowsExtNativeLibFilePath:String="";
		public var windowsExtInitializer:String="";
		public var windowsExtFinalizer:String="";
		public var windowsExtSelectAttachments:Boolean=false;
		public var windowsExtAttachments:String="";
		
		public var selectMacPlatform:Boolean=false;
		public var macExtNativeLibFilePath:String="";
		public var macExtInitializer:String="";
		public var macExtFinalizer:String="";
		public var macExtSelectAttachments:Boolean=false;
		public var macExtAttachments:String="";
		public var useTimeStap:Boolean=false;
		
	}
}