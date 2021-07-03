Include Ensemble
Class Util.LogQueueCounts Extends %SYS.Task.Definition
{
	
Property ProductionName As %String [ InitialExpression = "HIE.HIEPROD", Required ];

Parameter TaskName = "Log Queue Counts";

Method OnTask() As %Status
{
	//Set the initial status variable
	set tSC=$$$OK
	set tSC=..LogCounts()
	quit tSC
}

Method LogCounts() As %Status
{
	set tSC=$$$OK
	try
	{
		//Get a list of all production items in the specified production. Default production name is 'HIE.HIEPROD'
		set tQuery = "select Name from Ens_Config.Item where Production = '"_..ProductionName_"'"
		set tSC = $$$OK
#;		set tQuery = pQuery
#;  pQuery is never set; bcode breaks with UNDEF> 		
		set tStatement=##class(%SQL.Statement).%New(2)
		set qStatus=tStatement.%Prepare(tQuery)
	
		if qStatus'=1 
			{
#;			write !, pQuery
			write !, tQuery
			}
		
		set result = tStatement.%Execute()
		return result
		
		//For every item in the production
		while tResult.%Next()
		{
			set tConfigName = tResult.%GetData(1)
			
			//Get the business type
			set tBusinessType = ^Ens.Runtime("ConfigItem",tConfigName,"BusinessType")
			if tBusinessType = 1 {set tBusinessTypeFormatted = "Service"}
			elseif tBusinessType = 2 {set tBusinessTypeFormatted = "Process"}
			elseif tBusinessType = 3 {set tBusinessTypeFormatted = "Operation"}
			
			//Get the current queue count for that item
			set tQueueCount = ..GetQueueCount(tConfigName)
			
			//Log data points to storage class
			set tQueueLog = ##class(Util.QueueCountLog).%New()
			set tQueueLog.CreateTS = $ZDT($H,3)
			set tQueueLog.ConfigName = tConfigName
			set tQueueLog.Production = ..ProductionName
			set tQueueLog.QueueCount = tQueueCount
			set tQueueLog.BusinessType = tBusinessTypeFormatted
			do tQueueLog.%Save()
			
		}
		
	}
	catch
	{
		Set tSC = $$$ERROR($$$GeneralError, "Error: "_$ZE_" (SQLCODE="_$G(SQLCODE)_")")
		$$$LOGERROR("Error encountered while logging queue counts: "_tSC)
	}

	quit tSC
}

Method GetQueueCount(pConfigName As %String) As %Integer
{

	if $Data(^Ens.Queue(pConfigName))
	{
	set tQueueCount = ^Ens.Queue(pConfigName,"0","count")
	}
	else
	{
		set tQueueCount = 0
	}
	return tQueueCount
}

}
