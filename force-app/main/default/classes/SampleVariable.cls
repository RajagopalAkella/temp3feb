public class SampleVariable {
	@AuraEnabled
    public string MyString {get;set;}
    @AuraEnabled
  	public static SampleVariable initClass(string TempVal){
        SampleVariable obj = new SampleVariable();
   		obj.MyString = TempVal;
        return obj;
    }
}