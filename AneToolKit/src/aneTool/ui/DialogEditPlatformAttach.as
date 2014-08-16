package aneTool.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class DialogEditPlatformAttach extends Sprite
	{
		private var _closeHandler:Function=null;
//		private var _listDataSource:ArrayCollection = new ArrayCollection;
		private var _ui:DialogEditPlatform ;
		
		
		public function show(parent:Stage ,title:String,attach:String,closeHandler:Function):void
		{
			if(!_ui)
			{
				_ui = new DialogEditPlatform();
				parent.addChild(_ui);
				
				_ui.btnAddFile.addEventListener(MouseEvent.CLICK,btnAddFile_clickHandler);
				_ui.btnAddDir.addEventListener(MouseEvent.CLICK,btnAddDir_clickHandler);
				_ui.btnDelSelecedItem.addEventListener(MouseEvent.CLICK,btnDelSelecedItem_clickHandler);
				_ui.btnOk.addEventListener(MouseEvent.CLICK,btnOk_clickHandler);
				_ui.btnCancel.addEventListener(MouseEvent.CLICK,btnCancel_clickHandler);
			}
				
			_ui.title.text = title ;
			this._closeHandler = closeHandler;
			var attachPaths:Array = attach.split(";");
			for (var i:int = 0; i < attachPaths.length; i++) 
			{
				try{
//					listDataSource.addItem(new File(attachPaths[i]));
				}catch(e:Error){
				}
			}
			
		}
		
		private function btnCancel_clickHandler(event:MouseEvent):void
		{
			parent.removeChild(_ui);
		}
		
		private function btnOk_clickHandler(event:MouseEvent):void
		{
			
			if (_closeHandler!=null) 
			{
				var paths:Array=[];
				
//				for (var i:int = 0; i < listDataSource.length; i++) 
//				{
//					paths.push(listDataSource[i].nativePath);
//				}
				
				_closeHandler(paths.join(";"));
			}
		}
		
		private function btnDelSelecedItem_clickHandler(event:MouseEvent):void
		{
			if(_ui.listFiles.selectedIndex>-1){
//				listDataSource.removeItemAt(_ui.listFiles.selectedIndex);
			}
		}
		
		private function btnAddFile_clickHandler(event:MouseEvent):void
		{
			fileBrowser.browseForOpen("选择一个文件");
		}
		
		private function btnAddDir_clickHandler(event:MouseEvent):void
		{
			fileBrowser.browseForDirectory("选择一个文件夹");
		}
		
		public function get fileBrowser():File
		{
			if (_file==null) 
			{
				_file=new File;
				_file.addEventListener(Event.SELECT,_file_selectHandler);
			}
			return _file;
		}
		
		private var _file:File=null;
		
		private function _file_selectHandler(event:Event):void
		{
//			listDataSource.addItem(new File(fileBrowser.nativePath));
		}
	}
}