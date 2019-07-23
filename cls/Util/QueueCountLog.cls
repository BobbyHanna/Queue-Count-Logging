Class Util.QueueCountLog Extends %Persistent
{

Property CreateTS As %TimeStamp;

Property ConfigName As %String;

Property QueueCount As %Integer;

Property BusinessType As %String;

Property Production As %String;

Index CreateTSidx On CreateTS;

Index ConfigNameidx On ConfigName;

Index Productionidx On Production [ Type = bitmap ];

Index BusinessTypeidx On BusinessType [ Type = bitmap ];

Storage Default
{
<Data name="QueueCountLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateTS</Value>
</Value>
<Value name="3">
<Value>ConfigName</Value>
</Value>
<Value name="4">
<Value>QueueCount</Value>
</Value>
<Value name="5">
<Value>BusinessType</Value>
</Value>
<Value name="6">
<Value>Production</Value>
</Value>
</Data>
<DataLocation>^Util.QueueCountLogD</DataLocation>
<DefaultData>QueueCountLogDefaultData</DefaultData>
<IdLocation>^Util.QueueCountLogD</IdLocation>
<IndexLocation>^Util.QueueCountLogI</IndexLocation>
<StreamLocation>^Util.QueueCountLogS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
