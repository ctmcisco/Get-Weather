function Get-Weather {
<#
    .SYNOPSIS
		Shows current weather conditions in PowerShell console.
	   
    .DESCRIPTION
		This scirpt will show the current weather conditions for your area in your PowerShell console.
		While you could use the script on its own, it is highly recommended to add it to your profile.
		See https://technet.microsoft.com/en-us/library/ff461033.aspx for more info.

		You will need to get an OpenWeather API key from http://openweathermap.org/api - it's free.
		Once you have your key, replace "YOUR_API_KEY" with your key.
	   
		Note that weather results are displayed in metric (°C) units.
		To switch to imperial (°F) change all instances of '&units=metric' to '&units=imperial'
		as well as all instances of '°C' to '°F'. 
	   
    .EXAMPLE
		Get-Weather -City Toronto -Country CA
	   
		In this example, we will get the weather for Toronto, CA.
		If you do not leave in a major city, select the closest one to you. Note that the country code is the two-digit code for your country. 
		For a list of country codes, see https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements
	   
    .NOTES
		Written by Nick Tamm, nicktamm.com
		I take no responsibility for any issues caused by this script.
	   
    .LINK
		https://github.com/obs0lete/Get-Weather
		
#>

param(
	[string]$City,
	[string]$Country)


<# BEGIN VARIABLES #>

<# Get your API Key (it's free) from http://openweathermap.org/api #>
$API = "YOUR_API_KEY"

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
$currentTemp = "Current Temp: " + [Math]::Round($data.temperature.value, 0) + " °C"
$high = "Today's High: " + [Math]::Round($data.temperature.max, 0) + " °C"
$low = "Today's Low: " + [Math]::Round($data.temperature.min, 0) + " °C"
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
IF ($thunder.Contains($data.weather.number))
{	
	Write-Host "	    .--.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
	Write-Host "	 .-(    ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
	Write-Host "	(___.__)__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
	Write-Host "	  /_   /_  		" -f yellow -nonewline; Write-Host "$low			$windcondition" -f white;
	Write-Host "	   /    /  		" -f yellow -nonewline; Write-Host "$sunrise			$sunset" -f white;
	Write-Host ""
}
	ELSEIF ($drizzle.Contains($data.weather.number))
		{
			Write-Host "	  .-.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 / / / 			" -f cyan -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	  /  			" -f cyan -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF  ($rain.Contains($data.weather.number))
		{
			Write-Host "	    .-.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	   (   ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	  (___(__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 //////// 		" -f cyan -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	 /////// 		" -f cyan -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF  ($lightSnow.Contains($data.weather.number))
		{
			Write-Host "	  .-.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 *  *  *		$low			$windcondition"
			Write-Host "	*  *  * 		$sunrise		$sunset"
			Write-Host ""
		}
	ELSEIF  ($heavySnow.Contains($data.weather.number))
		{
			Write-Host "	    .-.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	   (   ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	  (___(__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	  * * * * 		$low			$windcondition"
			Write-Host "	 * * * *  		$sunrise			$sunset"
			Write-Host "	  * * * * "
			Write-Host ""
		}
	ELSEIF  ($snowAndRain.Contains($data.weather.number))
		{
			Write-Host "	  .-.   		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 (   ). 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	(___(__)		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 */ */* 		$low			$windcondition"
			Write-Host "	* /* /* 		$sunrise			$sunset"
			Write-Host ""
		}
	ELSEIF  ($atmosphere.Contains($data.weather.number))
		{
			Write-Host "	_ - _ - _ -		" -f gray -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	 _ - _ - _ 		" -f gray -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	_ - _ - _ -		" -f gray -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	 _ - _ - _ 		" -f gray -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "				$sunrise			$sunset"
			Write-Host ""
		}
	<#	
		The following will be displayed on clear evening conditions
		It is set to 18:00:00 (6:00PM). Change this to any value you want.
	#>
	ELSEIF  ($clear.Contains($data.weather.number) -and $time -gt "18:00:00")
		{
			Write-Host "	    *  --.			$weather		$humidity"
			Write-Host "	        \  \   *		$currenttemp			$precipitation"
			Write-Host "	         )  |    *		$high			$windspeed"
			Write-Host "	*       <   |			$low			$windcondition"
			Write-Host "	   *    ./ /	  		$sunrise			$sunset"
			Write-Host "	       ---'   *   "
			Write-Host ""
		}
	ELSEIF  ($clear.Contains($data.weather.number))
		{
			Write-Host "	   \ | /  		" -f Yellow -nonewline; Write-Host "$weather		$humidity" -f white;
			Write-Host "	    .-.   		" -f Yellow -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	-- (   ) --		" -f Yellow -nonewline; Write-Host "$high			$windspeed" -f white;
			Write-Host "	    ``'``   		" -f Yellow -nonewline; Write-Host "$low			$windcondition" -f white;
			Write-Host "	   / | \  		"-f yellow -nonewline; Write-Host "$sunrise			$sunset" -f white;
			Write-Host ""
		}
	ELSEIF ($partlyCloudy.Contains($data.weather.number))
		{
			Write-Host "	   \ | /   		" -f Yellow -nonewline; Write-Host "$weather	$humidity" -f white;
			Write-Host "	    .-.    		" -f Yellow -nonewline; Write-Host "$currenttemp			$precipitation" -f white;
			Write-Host "	-- (  .--. 		$high			$windspeed"  
			Write-Host "	   .-(    ). 		$low			$windcondition" 
			Write-Host "	  (___.__)__)		$sunrise			$sunset"
			Write-Host ""
		}
	ELSEIF ($cloudy.Contains($data.weather.number))
		{
		Write-Host "	    .--.   		$weather		$humidity"
		Write-Host "	 .-(    ). 		$currenttemp			$precipitation"
		Write-Host "	(___.__)__)		$high			$windspeed"
		Write-Host "	            		$low			$windcondition"
		Write-Host "				$sunrise			$sunset"
		Write-Host ""
		}
	ELSEIF ($windy.Contains($data.weather.number))
		{
		Write-Host "	~~~~      .--.   		$weather		$humidity"
		Write-Host "	 ~~~~~ .-(    ). 		$currenttemp			$precipitation"
		Write-Host "	~~~~~ (___.__)__)		$high			$windspeed"
		Write-Host "	                 		$low			$windcondition"
		Write-Host "					$sunrise			$sunset"
		}
}
