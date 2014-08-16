package
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import aneTool.Config;
	import aneTool.FileFilters;
	import aneTool.Log;
	import aneTool.TextTool;
	import aneTool.data.SimpleFilePromise;
	import aneTool.ui.DialogEditPlatformAttach;
	import aneTool.vo.PkgAneConfigData;
	import aneTool.vo.PkgAneProgressMessage;
	import aneTool.vo.VOManager;
	
	public class UIManager
	{
		private var _ui:UI ;
		private var _fileSwc:File;
		private var _fileJava:File;
		private var _dirFlexOrAirSDK:File;
		private var _fileAdt:File;
		private var _fileAndroidNativeLib:File;
		private var _fileiOSNativeLib:File;
		private var _fileCert:File;
		private var _fileAneExport:File;
		private var _fileWindowsNativeLib:File;
		private var _fileMacNativeLib:File;
		private var _dirAndroidAttach:File ;
		private var _diriOSAttach:File ;
		private var _fileCurrentConfig:File ;
		private var _baseDir:File=null;		
		private var _pkgAneWorker:Worker=null;
		private var _pkgAneWorkerProgressMC:MessageChannel=null;
		private  var _dragOutForSaveStartPoint:Point=new Point;
		private  var _dragOutForSaveCurrentPoint:Point=new Point;
		private var _dragOutForSaveDataSetted:Boolean=false;
		private var _atconfFileIcon:BitmapData=null;
		private var _stage:Stage ;
		private var _dialogEditPlatformAttach:DialogEditPlatformAttach ;
		private var _filePlatformOptions:File;
		
		[Embed(source="../assets/Res_icon_at_conf_48.png")]
		private static var IconAtConfClass:Class;
		
		public function UIManager(ui:UI,stage:Stage)
		{
			_ui = ui ;
			_stage = stage ;
			VOManager.regVO();
			Log.outTextArea = _ui.LOG_TXT;
			_dialogEditPlatformAttach = new DialogEditPlatformAttach ;
			
			
			
			_ui.SWC_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForSwcPath_clickHandler);
			_ui.JAVA_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForJavaPath_clickHandler);
			_ui.SDK_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForFlexOrAirSdk_clickHandler);
			_ui.JAR_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForAndroidExtNativeLibPath_clickHandler);
			_ui.IOS_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForiOSExtNativeLibPath_clickHandler);
			_ui.CER_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForCertPath_clickHandler);
			_ui.ANE_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForAneExportPath_clickHandler);
			
			//暂时屏蔽附件选项
			_ui.JAR_ANNEX_BTN.addEventListener(MouseEvent.CLICK,btnEditAndroidExtAttach_clickHandler);
			_ui.IOS_ANNEX_BTN.addEventListener(MouseEvent.CLICK,btnEditiOSExtAttach_clickHandler);
			_ui.WIN_ANNEX_BTN.addEventListener(MouseEvent.CLICK,btnEditWindowsExtAttach_clickHandler);
			_ui.MAC_ANNEX_BTN.addEventListener(MouseEvent.CLICK,btnEditMacExtAttach_clickHandler);
			
			_ui.JAR_YILAI_BTN.addEventListener(MouseEvent.CLICK,btnEditAndroidExtDepends_clickHandler);
			_ui.IOS_YILAI_BTN.addEventListener(MouseEvent.CLICK,btnBrowseForiOSExtPlatformOptionsFile_clickHandler);
			
			_ui.CREATE_BTN.addEventListener(MouseEvent.CLICK,btnGenAne_clickHandler);
			_ui.OPEN_CONFIG_BTN.addEventListener(MouseEvent.CLICK,btnOpenConfigFile_clickHandler);
			_ui.SAVE_CONFIG_BTN.addEventListener(MouseEvent.CLICK,btnSaveConfigFile_clickHandler);


		}
	
		
		
		//选项检查
		private function checkConfig():Boolean{
			if (TextTool.isTextEmpty(_ui.SWC_PATH_TXT)) 
			{
				Log.error("SWC路径未指定");
				return false;
			}
			try{
				_fileSwc = new File(_ui.SWC_PATH_TXT.text.replace(/\\/g,"/"));
				if (!_fileSwc.exists) 
				{
					Log.error("所指定的SWC文件不存在");
					return false;
				}
			}catch(e:Error){
				Log.error("所指定的SWC文件不存在");
				return false;
			}
			
			if (TextTool.isTextEmpty(_ui.JAVA_PATH_TXT))
			{
				Log.error("Java命令文件未指定");
				return false;
			}
			try{
				_fileJava = new File(_ui.JAVA_PATH_TXT.text.replace(/\\/g,"/"));
				trace(_ui.JAVA_PATH_TXT.text.replace(/\\/g,"/"));
				if (!_fileJava.exists) 
				{
					Log.error("所指定的Java命令文件不存在");
					return false;
				}
			}catch(e:Error){
				Log.error("所指定的Java命令文件不存在");
				return false;
			}
			
			if (TextTool.isTextEmpty(_ui.SDK_PATH_TXT)) 
			{
				Log.error("Flex/AIR SDK 未指定");
				return false;
			}
			try{
				_dirFlexOrAirSDK = new File(_ui.SDK_PATH_TXT.text.replace(/\\/g,"/"));
				if (!_dirFlexOrAirSDK.exists) 
				{
					Log.error("所指定的Flex/AIR SDK不存在");
					return false;
				}
			}catch(e:Error){
				Log.error("所指定的Flex/AIR SDK不存在");
				return false;
			}
			try{
				_fileAdt = _dirFlexOrAirSDK.resolvePath("lib/adt.jar");
				if (!_fileAdt.exists) 
				{
					Log.error("所指定的Flex/AIR SDK已经损坏");
					return false;
				}
			}catch(e:Error){
				Log.error("所指定的Flex/AIR SDK已经损坏");
				return false;
			}
			if (TextTool.isTextEmpty(_ui.ID_TXT)) 
			{
				Log.error("未指定本机扩展的ID");
				return false;
			}
			if (TextTool.isTextEmpty(_ui.VERSION_TXT)) 
			{
				Log.error("未指定本机扩展的版本");
				return false;
			}
			if (_ui.JAR_CHECKBOX && _ui.JAR_CHECKBOX.selected) 
			{
				if (TextTool.isTextEmpty(_ui.JAR_PATH_TXT)) 
				{
					Log.error("您选择的Android平台没有指定本机库");
					return false;
				}
				try{
					_fileAndroidNativeLib = new File(_ui.JAR_PATH_TXT.text.replace(/\\/g,"/"));
					if (!_fileAndroidNativeLib.exists) 
					{
						Log.error("所选择的Android本机库不存在");
						return false;
					}
				}catch(e:Error){
					Log.error("所选择的Android本机库不存在");
					return false;
				}
				if (TextTool.isTextEmpty(_ui.JAR_INI_TXT)) 
				{
					Log.error("您选择的Android平台未指定Initializer");
					return false;
				}
				if (_ui.JAR_FUJIAN_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.JAR_ANNEX_TXT)) 
					{
						Log.error("你选择了Android附件，但未指定该值");
						return false;
					}
				}
				if (_ui.JAR_YILAI_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.JAR_YILAI_TXT)) 
					{
						Log.error("你选择了Android依赖项，但未指定该值");
						return false;
					}
				}
			}
			if (_ui.IOS_CHECKBOX && _ui.IOS_CHECKBOX.selected)
			{
				if (TextTool.isTextEmpty(_ui.IOS_PATH_TXT)) 
				{
					Log.error("您选择的iOS平台没有指定本机库");
					return false;
				}
				try{
					_fileiOSNativeLib = new File(_ui.IOS_PATH_TXT.text.replace(/\\/g,"/"));
					if (!_fileiOSNativeLib.exists) 
					{
						Log.error("所选择的iOS本机库不存在");
						return false;
					}
				}catch(e:Error){
					Log.error("所选择的iOS本机库不存在");
					return false;
				}
				if (TextTool.isTextEmpty(_ui.IOS_INI_TXT)) 
				{
					Log.error("您选择的iOS平台未指定Initializer");
					return false;
				}
				if (_ui.IOS_FUJIAN_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.IOS_ANNEX_TXT)) 
					{
						Log.error("您选择了iOS附件，但未指定该值");
						return false;
					}
				}
				if (_ui.IOS_YILAI_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.IOS_YILAI_TXT)) 
					{
						Log.error("您选择了iOS平台选项，但未指定该文件");
						return false;
					}
					try{
						_filePlatformOptions = new File(_ui.IOS_YILAI_TXT.text.replace(/\\/g,"/"));
						if (!_filePlatformOptions.exists) 
						{
							Log.error("您选择的iOS平台选项描述文件不存在");
							return false;
						}
					}catch(e:Error){
						Log.error("您选择的iOS平台选项描述文件不存在");
						return false;
					}
				}
			}
			if (_ui.WIN_CHECKBOX && _ui.WIN_CHECKBOX.selected) 
			{
				if (TextTool.isTextEmpty(_ui.WIN_PATH_TXT)) 
				{
					Log.error("您选择的Windows平台没有指定本机库");
					return false;
				}
				try{
					_fileWindowsNativeLib = new File(_ui.WIN_PATH_TXT.text.replace(/\\/g,"/"));
					if (!_fileWindowsNativeLib.exists) 
					{
						Log.error("所选择的Windows本机库不存在");
						return false;
					}
				}catch(e:Error){
					Log.error("所选择的Windows本机库不存在");
					return false;
				}
				if (TextTool.isTextEmpty(_ui.WIN_INI_TXT)) 
				{
					Log.error("您选择的Windows平台未指定Initializer");
					return false;
				}
				if (_ui.WIN_FUJIAN_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.WIN_ANNEX_TXT)) 
					{
						Log.error("您选择了Windows附件，但未指定该值");
						return false;
					}
				}
			}
			if (_ui.MAC_CHECKBOX.selected) 
			{
				if (TextTool.isTextEmpty(_ui.MAC_PATH_TXT)) 
				{
					Log.error("您选择的Mac平台没有指定本机库");
					return false;
				}
				try{
					_fileMacNativeLib = new File(_ui.MAC_PATH_TXT.text.replace(/\\/g,"/"));
					if (!_fileMacNativeLib.exists) 
					{
						Log.error("所选择的Mac本机库不存在");
						return false;
					}
				}catch(e:Error){
					Log.error("所选择的Mac本机库不存在");
					return false;
				}
				if (TextTool.isTextEmpty(_ui.MAC_INI_TXT)) 
				{
					Log.error("您选择的Mac平台未指定Initializer");
					return false;
				}
				if (_ui.MAC_FUJIAN_CHECKBOX.selected) 
				{
					if (TextTool.isTextEmpty(_ui.MAC_ANNEX_TXT)) 
					{
						Log.error("您选择了Mac附件，但是未指定该值");
						return false;
					}
				}
			}
			if (!_ui.JAR_CHECKBOX.selected&&!_ui.IOS_CHECKBOX.selected&&!_ui.MAC_CHECKBOX.selected&&!_ui.WIN_CHECKBOX.selected) 
			{
				Log.error("平台选项 必须至少选择一个");
				return false;
			}
			if (TextTool.isTextEmpty(_ui.CER_PATH_TXT)) 
			{
				Log.error("证书未指定");
				return false;
			}
			try{
				_fileCert = new File(_ui.CER_PATH_TXT.text.replace(/\\/g,"/"));
				if (!_fileCert.exists) 
				{
					Log.error("所选的签名证书不存在");
					return false;
				}
			}catch(e:Error){
				Log.error("所选的签名证书不存在");
				return false;
			}
			if (TextTool.isTextEmpty(_ui.PASSWORD_PATH_TXT)) 
			{
				Log.error("证书密码未指定");
				return false;
			}
			if (TextTool.isTextEmpty(_ui.PASSWORD_PATH_TXT)) 
			{
				Log.error("ANE导出路径未指定");
				return false;
			}
			try{
				_fileAneExport = new File(_ui.ANE_PATH_TXT.text.replace(/\\/g,"/"));
			}catch(e:Error){
				Log.error("ANE导出路径不合法，请使用绝对路径");
				return false;
			}
			return true;
		}
		
		protected function btnGenAne_clickHandler(event:MouseEvent):void
		{
			if (checkConfig()) 
			{
				
				_pkgAneWorker  = WorkerDomain.current.createWorker(Workers.com_plter_anetool_workers_pkganework_PkgAneWorker,true);
				
				_pkgAneWorkerProgressMC = _pkgAneWorker.createMessageChannel(Worker.current);
				_pkgAneWorkerProgressMC.addEventListener(Event.CHANNEL_MESSAGE,pkgAneWorkerProgressMC_messageHandler);
				_pkgAneWorker.setSharedProperty("progressMC",_pkgAneWorkerProgressMC);
				_pkgAneWorker.setSharedProperty("pkgAneConfigData",getPkgAneConfigData());
				
				_pkgAneWorker.addEventListener(Event.WORKER_STATE,pkgAneWorker_workerStateHandler);
				_pkgAneWorker.start();
			}
		}
		
		protected function pkgAneWorkerProgressMC_messageHandler(event:Event):void
		{
			var msg:PkgAneProgressMessage = _pkgAneWorkerProgressMC.receive();
			if (msg) 
			{
				switch(msg.type)
				{
					case "info":
						Log.info(msg.message);
						break;
					case "error":
						Log.error(msg.message);
						break;
					case "warn":
						Log.warn(msg.message);
						break;
				}
			}
		}
		
		protected function pkgAneWorker_workerStateHandler(event:Event):void
		{
			if(_pkgAneWorker.state=="terminated"){
				_ui.CREATE_BTN.enabled=true;
			}
		}
		
		public function getPkgAneConfigData():PkgAneConfigData{
			var data:PkgAneConfigData = new PkgAneConfigData;
			data.swcFilePath = fileSwc.nativePath;
			data.javaFilePath = fileJava.nativePath;
			data.flexOrAirSdkFilePath = _ui.SDK_PATH_TXT.text;
			data.adtFilePath = fileAdt.nativePath;
			
			data.aneDescFileContent = getAneDescFileContent().toXMLString();
			data.aneId = _ui.ID_TXT.text ;
			data.aneVersion = _ui.VERSION_TXT.text ;
			data.aneAirVersion = _ui.AIR_VERSION_TXT.text;
			data.aneName = _ui.ANE_NAME_TXT.text;
			data.aneDesc = _ui.ANE_DES_TXT.text;
			data.aneCopyright = _ui.ANE_RIGHTS_TXT.text;
			data.useTimeStap = _ui.TIMESTAP.selected;
			
			data.selectAndroidPlatform = _ui.JAR_CHECKBOX.selected ;
			if (data.selectAndroidPlatform)
			{
				data.androidExtNativeLibFilePath = fileAndroidNativeLib.nativePath;
				data.androidExtInitializer = _ui.JAR_INI_TXT.text ;
				data.androidExtFinalizer = _ui.JAR_FIN_TXT.text ;
				data.androidExtSelectAttachments = _ui.JAR_FUJIAN_CHECKBOX.selected;
				data.androidExtAttachments = _ui.JAR_ANNEX_TXT.text;
				data.androidExtSelectDepends = _ui.JAR_YILAI_CHECKBOX.selected;
				data.androidExtDepends = _ui.JAR_YILAI_TXT.text;
			}
			
			data.selectiOSPlatform =  _ui.IOS_CHECKBOX.selected ;
			if (data.selectiOSPlatform) 
			{
				data.iOSExtNativeLibFilePath = fileiOSNativeLib.nativePath;
				data.iOSExtUseRealDevice = _ui.IOS_ZHENJI_CHECKBOX.selected;
				data.iOSExtInitializer = _ui.IOS_INI_TXT.text;
				data.iOSExtFinalizer = _ui.IOS_FIN_TXT.text;
 				data.iOSExtSelectAttachments = _ui.IOS_FUJIAN_CHECKBOX.selected;
				data.iOSExtAttachments = _ui.IOS_ANNEX_TXT.text;
				data.iOSExtSelectPlatformOptionsFile = _ui.IOS_YILAI_CHECKBOX.selected;
				data.iOSExtPlatformOptionsFilePath  = _ui.IOS_YILAI_TXT.text;
			}
			
			data.selectWindowsPlatform = _ui.WIN_CHECKBOX.selected ;
			if (data.selectWindowsPlatform) 
			{
				data.windowsExtNativeLibFilePath = fileWindowsNativeLib.nativePath;
				data.windowsExtInitializer = _ui.WIN_INI_TXT.text;
				data.windowsExtFinalizer = _ui.WIN_FIN_TXT.text;
				data.windowsExtSelectAttachments = _ui.WIN_FUJIAN_CHECKBOX.selected;
				data.windowsExtAttachments = _ui.WIN_ANNEX_TXT.text;
			}
			
			data.selectMacPlatform = _ui.MAC_CHECKBOX.selected ;
			if (data.selectMacPlatform) 
			{
				data.macExtNativeLibFilePath = fileMacNativeLib.nativePath;
				data.macExtInitializer = _ui.MAC_INI_TXT.text;
				data.macExtFinalizer = _ui.MAC_FIN_TXT.text;
				data.macExtSelectAttachments = _ui.MAC_FUJIAN_CHECKBOX.selected;
				data.macExtAttachments = _ui.MAC_ANNEX_TXT.text;
			}
			
			data.useTimeStap = _ui.TIMESTAP.selected;
			data.certFilePath = _ui.CER_PATH_TXT.text;
			data.certPassword = _ui.PASSWORD_PATH_TXT.text;
			data.aneExportPath = fileAneExport.nativePath;
			return data;
		}
		
		//swc
		private function btnBrowseForSwcPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void
			{
				_ui.SWC_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择一个SWC文件",FileFilters.SWC_FILE_FILTERS);
		}
		
		//java
		protected function btnBrowseForJavaPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.JAVA_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择java命令",FileFilters.JAVA_EXE_FILTERS);
		}
		//SDK
		protected function btnBrowseForFlexOrAirSdk_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.SDK_PATH_TXT.text = file.nativePath;
			});
			file.browseForDirectory("选择 Flex SDK 或者 AIR SDK");
		}
		//Android库
		protected function btnBrowseForAndroidExtNativeLibPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.JAR_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择一个Android库文件",FileFilters.ANDROID_LIB_FILE_FILTERS);
		}
		//iOS库
		protected function btnBrowseForiOSExtNativeLibPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.IOS_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择一个iOS库文件",FileFilters.A_FILE_FILTERS);
		}
		
		
		protected function btnBrowseForCertPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.CER_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择一个数字签名证书文件",FileFilters.P12_FILE_FILTERS);
		}
		
		protected function btnBrowseForAneExportPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.ANE_PATH_TXT.text = file.nativePath;
			});
			file.browseForSave("选择一个路径用于保存ANE文件");
		}
		
		protected function btnBrowseForWindowsExtNativeLibPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.WIN_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择一个DLL库文件",FileFilters.DLL_FILE_FILTERS);
		}
		
		protected function btnBrowseForMacExtNativeLibPath_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.MAC_PATH_TXT.text = file.nativePath;
			});
			file.browseForDirectory("选择一个Mac库文件");
		}
		
		
		public function getAneDescFileContent():XML{
			
			var airVersion:String = TextTool.isTextEmpty(_ui.AIR_VERSION_TXT) ? Config.DEFAULT_AIR_VERSION : _ui.AIR_VERSION_TXT.text ; ;
			
			var xml:XML = XML("<extension xmlns=\"http://ns.adobe.com/air/extension/"+airVersion+"\"></extension>");
			xml.id = _ui.ID_TXT.text;
			xml.versionNumber = _ui.VERSION_TXT.text;
			if (!TextTool.isTextEmpty(_ui.ANE_NAME_TXT)) 
			{
				xml.name = _ui.ANE_NAME_TXT.text;
			}
			if (!TextTool.isTextEmpty(_ui.ANE_DES_TXT)) 
			{
				xml.description = _ui.ANE_DES_TXT.text;
			}
			if (!TextTool.isTextEmpty(_ui.ANE_RIGHTS_TXT)) 
			{
				xml.copyright = _ui.ANE_RIGHTS_TXT.text;
			}
			
			//setup platforms
			var platformsXML:XML = <platforms></platforms>;
			var platformXML:XML=null;
			var applicationDeploymentXML:XML=null;
			xml.appendChild(platformsXML);
			if (_ui.JAR_CHECKBOX.selected) 
			{
				platformXML = <platform name="Android-ARM"></platform>;
				platformsXML.appendChild(platformXML);
				applicationDeploymentXML = <applicationDeployment></applicationDeployment>;
				platformXML.appendChild(applicationDeploymentXML);
				applicationDeploymentXML.nativeLibrary = fileAndroidNativeLib.name;
				applicationDeploymentXML.initializer = _ui.JAR_INI_TXT.text;
				if (!TextTool.isTextEmpty(_ui.JAR_FIN_TXT)) 
				{
					applicationDeploymentXML.finalizer = _ui.JAR_FIN_TXT.text;
				}
			}
			if (_ui.IOS_CHECKBOX.selected) 
			{
				if (_ui.IOS_ZHENJI_CHECKBOX.selected) 
				{
					platformXML = <platform name="iPhone-ARM"></platform>;
					platformsXML.appendChild(platformXML);
					applicationDeploymentXML = <applicationDeployment></applicationDeployment>;
					platformXML.appendChild(applicationDeploymentXML);
					applicationDeploymentXML.nativeLibrary = fileiOSNativeLib.name;
					applicationDeploymentXML.initializer = _ui.IOS_INI_TXT.text;
					if (!TextTool.isTextEmpty(_ui.IOS_FIN_TXT))
					{
						applicationDeploymentXML.finalizer = _ui.IOS_FIN_TXT.text;
					}
				}else{
					platformXML = <platform name="iPhone-x86"></platform>;
					platformsXML.appendChild(platformXML);
					applicationDeploymentXML = <applicationDeployment></applicationDeployment>;
					platformXML.appendChild(applicationDeploymentXML);
					applicationDeploymentXML.nativeLibrary = fileiOSNativeLib.name;
					applicationDeploymentXML.initializer = _ui.IOS_INI_TXT.text;
					if (!TextTool.isTextEmpty(_ui.IOS_INI_TXT)) 
					{
						applicationDeploymentXML.finalizer = _ui.IOS_FIN_TXT.text;
					}
				}
			}
			if (_ui.WIN_CHECKBOX.selected) 
			{
				platformXML = <platform name="Windows-x86"></platform>;
				platformsXML.appendChild(platformXML);
				applicationDeploymentXML = <applicationDeployment></applicationDeployment>;
				platformXML.appendChild(applicationDeploymentXML);
				applicationDeploymentXML.nativeLibrary = fileWindowsNativeLib.name;
				applicationDeploymentXML.initializer = _ui.WIN_INI_TXT.text;
				if (!TextTool.isTextEmpty(_ui.WIN_FIN_TXT)) 
				{
					applicationDeploymentXML.finalizer = _ui.WIN_FIN_TXT.text;
				}
			}
			if (_ui.MAC_CHECKBOX.selected) 
			{
				platformXML = <platform name="MacOS-x86"></platform>;
				platformsXML.appendChild(platformXML);
				applicationDeploymentXML = <applicationDeployment></applicationDeployment>;
				platformXML.appendChild(applicationDeploymentXML);
				applicationDeploymentXML.nativeLibrary = fileMacNativeLib.name;
				applicationDeploymentXML.initializer = _ui.MAC_INI_TXT.text;
				if (!TextTool.isTextEmpty(_ui.MAC_FIN_TXT)) 
				{
					applicationDeploymentXML.finalizer = _ui.MAC_FIN_TXT.text;
				}
			}
			return xml;
		}
		
		
		protected function btnEditAndroidExtAttach_clickHandler(event:MouseEvent):void
		{
			_dialogEditPlatformAttach.show(_stage,"编辑Android本机扩展附件",_ui.JAR_ANNEX_TXT.text,function(result:String):void{
				_ui.JAR_ANNEX_TXT.text = result;
			});
		}
		
		
		protected function btnEditAndroidExtDepends_clickHandler(event:MouseEvent):void
		{
			_dialogEditPlatformAttach.show(_stage,"编辑Android本机扩展依赖项",_ui.JAR_ANNEX_TXT.text,function(result:String):void{
				_ui.JAR_ANNEX_TXT.text = result;
			});
		}
		
		
		protected function btnEditiOSExtAttach_clickHandler(event:MouseEvent):void
		{
			_dialogEditPlatformAttach.show(_stage,"编辑iOS本机扩展附件",_ui.IOS_ANNEX_TXT.text,function(result:String):void{
				_ui.IOS_ANNEX_TXT.text = result;
			});
		}
		
		protected function btnBrowseForiOSExtPlatformOptionsFile_clickHandler(event:MouseEvent):void
		{
			var file:File = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				_ui.IOS_PATH_TXT.text = file.nativePath;
			});
			file.browseForOpen("选择iOS平台选项配置文件",FileFilters.XML_FILE_FILTERS);
		}
		
		protected function btnEditWindowsExtAttach_clickHandler(event:MouseEvent):void
		{
			_dialogEditPlatformAttach.show(_stage,"编辑Windows本机扩展附件",_ui.WIN_ANNEX_TXT.text,function(result:String):void{
				_ui.WIN_ANNEX_TXT.text = result;
			});
		}
		
		protected function btnEditMacExtAttach_clickHandler(event:MouseEvent):void
		{
			_dialogEditPlatformAttach.show(_stage,"编辑Windows本机扩展附件",_ui.MAC_ANNEX_TXT.text,function(result:String):void{
				_ui.MAC_ANNEX_TXT.text = result;
			});
		}
		
		public function get dirAndroidAttach():File
		{
			return _dirAndroidAttach;
		}
		
		public function get fileSwc():File
		{
			return _fileSwc;
		}
		
		public function get fileJava():File
		{
			return _fileJava;
		}
		
		public function get dirFlexOrAirSDK():File
		{
			return _dirFlexOrAirSDK;
		}
		
		public function get fileAndroidNativeLib():File
		{
			return _fileAndroidNativeLib;
		}
		
		public function get fileiOSNativeLib():File
		{
			return _fileiOSNativeLib;
		}
		
		public function get fileWindowsNativeLib():File
		{
			return _fileWindowsNativeLib;
		}
		
		public function get fileMacNativeLib():File
		{
			return _fileMacNativeLib;
		}
		
		public function get fileCert():File
		{
			return _fileCert;
		}
		
		public function get fileAdt():File
		{
			return _fileAdt;
		}
		
		public function get diriOSAttach():File
		{
			return _diriOSAttach;
		}
		
		public function get fileAneExport():File
		{
			return _fileAneExport;
		}
		
		
		protected function btnSaveConfigFile_clickHandler(event:MouseEvent):void
		{
			saveCurrentConfigToFile();
		}
		
		
		public function saveCurrentConfigToFile():void{
			if (checkConfig()) 
			{
				var dataForSave:String = JSON.stringify(getPkgAneConfigData());
				
				var s:FileStream=null;
				try{
					if (fileCurrentConfig.exists) 
					{
						s= new FileStream;
						s.open(fileCurrentConfig,FileMode.WRITE);
						s.writeUTFBytes(dataForSave);
						s.close();
						
						Log.info("配置文件保存成功");
					}else{
						fileCurrentConfig.save(dataForSave,"build_ane.atconf");
					}
				}catch(e:Error){
					fileCurrentConfig.save(dataForSave,"build_ane.atconf");
				}
			}else{
				Log.error("配置有误，无法保存文件");
			}
		}
		
		public function readConfigFile(file:File):void{
			try{
				if (file.exists) 
				{
					try{
						var s:FileStream = new FileStream;
						s.open(file,FileMode.READ);
						var jsonStr:String = s.readUTFBytes(s.bytesAvailable);
						s.close();
						
						var obj:Object = JSON.parse(jsonStr);
						var configData:PkgAneConfigData = new PkgAneConfigData;
						for(var k:String in obj){
							configData[k] = obj[k];
						}
						setPropertiesByConfigData(configData);
					}catch(e:Error){
						Log.error("配置文件格式错误");
						trace(e.getStackTrace());
					}
				}else{
					Log.error("所选择的文件不存在");
				}
			}catch(err:Error){
				trace(err.getStackTrace());
			}
		}
		
		public function setPropertiesByConfigData(configData:PkgAneConfigData):void
		{
			_ui.SWC_PATH_TXT.text = configData.swcFilePath;
			_ui.JAVA_PATH_TXT.text = configData.javaFilePath;
			_ui.SDK_PATH_TXT.text = configData.flexOrAirSdkFilePath;
			_ui.ID_TXT.text=configData.aneId;
			_ui.VERSION_TXT.text=configData.aneVersion;
			_ui.AIR_VERSION_TXT.text=configData.aneAirVersion;
			_ui.ANE_NAME_TXT.text=configData.aneName;
			_ui.ANE_DES_TXT.text=configData.aneDesc;
			_ui.ANE_RIGHTS_TXT.text=configData.aneCopyright;
			
			_ui.JAR_CHECKBOX.selected = configData.selectAndroidPlatform;
			_ui.JAR_PATH_TXT.text=configData.androidExtNativeLibFilePath;
			_ui.JAR_INI_TXT.text=configData.androidExtInitializer;
			_ui.JAR_FIN_TXT.text=configData.androidExtFinalizer;
			_ui.JAR_FUJIAN_CHECKBOX.selected = configData.androidExtSelectAttachments;
			_ui.JAR_ANNEX_TXT.text=configData.androidExtAttachments;
			_ui.JAR_YILAI_CHECKBOX.selected = configData.androidExtSelectDepends;
			_ui.JAR_YILAI_TXT.text = configData.androidExtDepends;
			
			_ui.IOS_CHECKBOX.selected=configData.selectiOSPlatform;
			_ui.IOS_ZHENJI_CHECKBOX.selected = configData.iOSExtUseRealDevice;
			_ui.IOS_PATH_TXT.text = configData.iOSExtNativeLibFilePath;
			_ui.IOS_INI_TXT.text=configData.iOSExtInitializer;
			_ui.IOS_FIN_TXT.text=configData.iOSExtFinalizer;
			_ui.IOS_FUJIAN_CHECKBOX.selected=configData.iOSExtSelectAttachments;
			_ui.IOS_ANNEX_TXT.text=configData.iOSExtAttachments;
			_ui.IOS_YILAI_CHECKBOX.selected=configData.iOSExtSelectPlatformOptionsFile;
			
			_ui.WIN_CHECKBOX.selected=configData.selectWindowsPlatform;
			_ui.WIN_PATH_TXT.text=configData.windowsExtNativeLibFilePath;
			_ui.WIN_INI_TXT.text=configData.windowsExtInitializer;
			_ui.WIN_FIN_TXT.text=configData.windowsExtFinalizer;
			_ui.WIN_FUJIAN_CHECKBOX.selected = configData.windowsExtSelectAttachments;
			_ui.WIN_ANNEX_TXT.text=configData.windowsExtAttachments;
			
			_ui.MAC_CHECKBOX.selected = configData.selectMacPlatform;
			_ui.MAC_PATH_TXT.text=configData.macExtNativeLibFilePath;
			_ui.MAC_PATH_TXT.text=configData.macExtInitializer;
			_ui.MAC_PATH_TXT.text=configData.macExtFinalizer;
			_ui.MAC_FUJIAN_CHECKBOX.selected = configData.macExtSelectAttachments;
			_ui.MAC_PATH_TXT.text=configData.macExtAttachments;
			
			_ui.CER_PATH_TXT.text = configData.certFilePath;
			_ui.PASSWORD_PATH_TXT.text = configData.certPassword;
			_ui.ANE_PATH_TXT.text = configData.aneExportPath;
		}
		
		
		
		public function get fileCurrentConfig():File
		{
			if (_fileCurrentConfig==null) 
			{
				_fileCurrentConfig = new File;
			}
			return _fileCurrentConfig;
		}
		
		public function set fileCurrentConfig(value:File):void{
			_fileCurrentConfig = value;
		}
		
		
		public function openConfigFile():void{
			fileCurrentConfig.browseForOpen("打开配置文件",FileFilters.ATCONF_FILE_FILTERS);
			fileCurrentConfig.addEventListener(Event.CANCEL,fileCurrentConf_cancelHandler);
			fileCurrentConfig.addEventListener(Event.SELECT,fileCurrentConf_selectHandler);
		}
		
		protected function btnOpenConfigFile_clickHandler(event:MouseEvent):void
		{
			openConfigFile();
		}
		
		private function removeFileCurrentConfigListeners():void{
			fileCurrentConfig.removeEventListener(Event.CANCEL,fileCurrentConf_cancelHandler);
			fileCurrentConfig.removeEventListener(Event.SELECT,fileCurrentConf_selectHandler);
		}
		
		protected function fileCurrentConf_cancelHandler(event:Event):void
		{
			removeFileCurrentConfigListeners();
		}
		
		protected function fileCurrentConf_selectHandler(event:Event):void
		{
			removeFileCurrentConfigListeners();
			readConfigFile(fileCurrentConfig);
		}
		
		
		protected function btnDonate_clickHandler(event:MouseEvent):void
		{
//			DonateWindow.show(this);
		}
		
		protected function windowedapplication1_invokeHandler(event:InvokeEvent):void
		{
			if (event.arguments&&event.arguments.length>0) 
			{
				var path:String = event.arguments[0];
				
				try{
					fileCurrentConfig = new File(path.replace(/\\/g,"/"));
					readConfigFile(fileCurrentConfig);
				}catch(e:Error){
					trace(e.getStackTrace());
				}
			}
		}
		
		protected function windowedapplication1_nativeDragEnterHandler(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (files&&files.length>0) 
			{
				var file:File = files[0];
//				if (file.exists&&FileReference(file).extension) 
//				{
//					if (file.extension.toLowerCase()=="atconf") 
//					{
//						NativeDragManager.acceptDragDrop(this);
//					}
//				}
			}
		}
		
		protected function windowedapplication1_nativeDragDropHandler(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (files&&files.length>0) 
			{
				var file:File = files[0];
//				if (file.exists&&file.extension) 
//				{
//					if (file.extension.toLowerCase()=="atconf") 
//					{
//						fileCurrentConfig = file;
//						readConfigFile(fileCurrentConfig);
//					}
//				}
			}
		}
		
		
		private function get atconfFileIcon():BitmapData{
			if (_atconfFileIcon==null) 
			{
				_atconfFileIcon = new IconAtConfClass().bitmapData;
			}
			return _atconfFileIcon;
		}
		
		protected function windowedapplication1_mouseDownHandler(event:MouseEvent):void
		{
			_dragOutForSaveDataSetted=false;
			_dragOutForSaveStartPoint.x = _stage.mouseX;
			_dragOutForSaveStartPoint.y = _stage.mouseY;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,stage_dragOutForSaveMouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,stage_dragOutForSaveMouseUpHandler);
		}
		
		protected function stage_dragOutForSaveMouseMoveHandler(event:MouseEvent):void
		{
			
			if (!_dragOutForSaveDataSetted) 
			{
				_dragOutForSaveCurrentPoint.x=_stage.mouseX;
				_dragOutForSaveCurrentPoint.y=_stage.mouseY;
				
				if (Point.distance(_dragOutForSaveCurrentPoint,_dragOutForSaveStartPoint)>5) 
				{
					
					if (checkConfig()) 
					{
						var dataForSave:String = JSON.stringify(getPkgAneConfigData());
						var bytes:ByteArray = new ByteArray;
						bytes.writeUTFBytes(dataForSave);
						bytes.position=0;
						
						var fp:SimpleFilePromise = new SimpleFilePromise(bytes);
						
						var cb:Clipboard = new Clipboard;
						cb.setData(ClipboardFormats.FILE_PROMISE_LIST_FORMAT,[fp]);
						NativeDragManager.doDrag(_stage,cb,atconfFileIcon);
						
					}else{
						Log.error("配置有误，无法保存文件");
					}
					
					_dragOutForSaveDataSetted=true;
				}
			}
		}
		
		protected function stage_dragOutForSaveMouseUpHandler(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,stage_dragOutForSaveMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,stage_dragOutForSaveMouseUpHandler);
		}
		
		

	}
}