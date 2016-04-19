function Get-Weather {
<# Change to your City/Country #>
param(
	[string]$City = "YourCity",
	[string]$Country = "YourCountry")


<# BEGIN VARIABLES #>


<# Get your API Key (it's free) from http://openweathermap.org/api #>

$API = "YourKey"
<#
	The following will capture weather data. Note that this is in metric (�C) units.
	To change to imperial (�F) change '&units=metric' to '&units=imperial'
	as well as all instances of '�C' to '�F'.
#>


<#JSON request for sunrise/sunset #>
$resultsJSON = Invoke-WebRequest "api.openweathermap.org/data/2.5/weather?q=$City,$Country&units=metric&appid=$API&mode=json"
$json = $resultsJSON.Content
$jsonData = ConvertFrom-Json $json
$sunriseJSON = $jsonData.sys.sunrise
$sunsetJSON = $jsonData.sys.sunset

<# Convert UNIX UTC time to readable format #>
$sunrise = [TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($sunriseJSON))
$sunset = [TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($sunsetJSON))
$sunrise =  "{0:hh:mm:ss tt}" -f (Get-Date $sunrise)
$sunset = "{0:hh:mm:ss tt}" -f (Get-Date $sunset)

<# XML request for everything else #>
[xml]$results = Invoke-WebRequest "api.openweathermap.org/data/2.5/weather?q=$City,$Country&units=metric&appid=$API&mode=xml"
$data = $results.current

<# Get current weather value. Needed to convert case of characters. #>
$currentValue = $data.weather.value

<# Get rain value. Needed to convert case of characters. #>
$rainValue = $data.precipitation.mode

<# Get rain value. Needed to convert case of characters. #>
$windValue = $data.wind.speed.name

<# Get the current time. This is for clear conditions at night time. #>
$time = Get-Date -DisplayHint Time

<# Define the numbers for various weather conditions #>
$thunder = "200","201","202","210","211","212","221","230","231","232"
$drizzle = "300","301","302","310","311","312","313","314","321","500","501","502"
$rain = "503","504","520","521","522","531"
$lightSnow = "600","601"
$heavySnow = "602","622"
$snowAndRain = "611","612","615","616","620","621"
$atmosphere = "701","711","721","731","741","751","761","762","771","781"
$clear = "800"
$partlyCloudy = "801","802","803"
$cloudy = "804"
$windy = "900","901","902","903","904","905","906","951","952","953","954","955","956","957","958","959","960","961","962"

<# Create the variables we will use to display weather information #>
$weather = "Current Weather: " + (Get-Culture).textinfo.totitlecase($currentValue.tolower())
$currentTemp = "Current Temp: " + [Math]::Round($data.temperature.value, 0) + " �C"
$high = "Today's High: " + [Math]::Round($data.temperature.max, 0) + " �C"
$low = "Today's Low: " + [Math]::Round($data.temperature.min, 0) + " �C"
$humidity = "Humidity: " + $data.humidity.value + $data.humidity.unit
$precipitation = "Rain: " + (Get-Culture).textinfo.totitlecase($rainValue.tolower())
$windSpeed = "Wind Speed: " + ([math]::Round(([decimal]$data.wind.speed.value * 1.609344),1)) + " km/h" + " - Direction: " + $data.wind.direction.code
$windCondition = "Wind Condition: " + (Get-Culture).textinfo.totitlecase($windvalue.tolower())
$sunrise = "Sunrise: " + $sunrise
$sunset = "Sunset: " + $sunset


<# END VARIABLES #>


Write-Host ""
Write-Host "Current weather conditions for" $data.city.name
Write-Host ""
IF ($data.weather.number -contains $thunder)
{	
	Write-Host "	    .--.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
	Write-Host "	 .-(    ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
	Write-Host "	(___.__)__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
	Write-Host "	  /_   /_  		" -f yellow -nonewline; Write-Host "$low			$windcondition" -f white;
	Write-Host "	   /    /  		" -f yellow -nonewline; Write-Host "$sunrise			$sunset" -f white;
	Write-Host ""
}
	ELSEIF ($data.weather.number -contains $drizzle)
		{
			Write-Host "	  .-.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 / / / 			" -f cyan -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	  /  			" -f cyan -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $rain)
		{
			Write-Host "	    .-.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	   (   ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	  (___(__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 //////// 		" -f cyan -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	 /////// 		" -f cyan -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $lightSnow)
		{
			Write-Host "	  .-.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 *  *  *		$low			$windcondition"
			Write-Host "	*  *  * 		$sunrise		$sunset"
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $heavySnow)
		{
			Write-Host "	    .-.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	   (   ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	  (___(__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	  * * * * 		$low			$windcondition"
			Write-Host "	 * * * *  		$sunrise		$sunset"
			Write-Host "	  * * * * "
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $snowAndRain)
		{
			Write-Host "	  .-.   		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 */ */* 		$low			$windcondition"
			Write-Host "	* /* /* 		$sunrise		$sunset"
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $atmosphere)
		{
			Write-Host "	_ - _ - _ -		" -f grey -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 _ - _ - _ 		" -f grey -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	_ - _ - _ -		" -f grey -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 _ - _ - _ 		" -f grey -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "					$sunrise		$sunset"
			Write-Host ""
		}
	<#	
		The following will be displayed on clear evening conditions
		It is set to 18:00:00 (6:00PM). Change this to any value you want.
	#>
	ELSEIF  ($data.weather.number -contains $clear -and $time -gt "18:00:00")
		{
			Write-Host "	    *  --.			$weather		$humidity"
			Write-Host "	        \  \   *		$currenttemp			$precipitation"
			Write-Host "	         )  |    *		$high			$windspeed"
			Write-Host "	*       <   |			$low			$windcondition"
			Write-Host "	   *    ./ /	  		$sunrise			$sunset"
			Write-Host "	       ---'   *   "
			Write-Host ""
		}
	ELSEIF  ($data.weather.number -contains $clear)
		{
			Write-Host "	   \ | /  		" -f Yellow -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	    .-.   		" -f Yellow -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	-- (   ) --		" -f Yellow -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	    ``'``   		" -f Yellow -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	   / | \  		"-f yellow -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF ($data.weather.number -contains $partlyCloudy)
		{
			Write-Host "	   \ | /   		" -f Yellow -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	    .-.    		" -f Yellow -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	-- (  .--. 		$high			$windspeed"  
			Write-Host "	   .-(    ). 	$low			$windcondition" 
			Write-Host "	  (___.__)__)	$sunrise		$sunset"
			Write-Host ""
		}
	ELSEIF ($data.weather.number -contains $cloudy)
		{
		Write-Host "	    .--.   		$weather		$humidity"
		Write-Host "	 .-(    ). 		$currenttemp			$precipitation"
		Write-Host "	(___.__)__)		$high			$windspeed"
		Write-Host "	            	$low			$windcondition"
		Write-Host "					$sunrise		$sunset"
		Write-Host ""
		}
	ELSEIF ($data.weather.number -contains $windy)
		{
		Write-Host "	~~~~      .--.   		$weather		$humidity"
		Write-Host "	 ~~~~~ .-(    ). 		$currenttemp			$precipitation"
		Write-Host "	~~~~~ (___.__)__)		$high			$windspeed"
		Write-Host "	                 		$low			$windcondition"
		Write-Host "							$sunrise		$sunset"
		}
}