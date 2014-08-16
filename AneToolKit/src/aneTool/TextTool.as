package aneTool
{
	import flash.text.TextField;

	public class TextTool
	{
		public static function isTextEmpty(ti:TextField):Boolean
		{
			return ti.text==null||ti.text=="";
		}
		
		
		public static function isStringEmpty(s:String):Boolean{
			return s==null||s=="";
		}
	}
}