package aneTool.pkgAne 
{
	import flash.display.Sprite;
	import flash.system.Worker;
	
	import aneTool.vo.VOManager;
	
	public class PkgAneWorker extends Sprite
	{
		
		public function PkgAneWorker()
		{
			super();
			
			VOManager.regVO();
			
			PkgAneWorkerConfig.progressMessageChannel = Worker.current.getSharedProperty("progressMC");
			PkgAneWorkerConfig.pkgAneConfigData = Worker.current.getSharedProperty("pkgAneConfigData");
			
			new PkgAneProcess().startPkgAne();
		}
	}
}