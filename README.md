# Get-Weather
A PowerShell function that will display weather conditions in the console. 
![Alt text](/get-weather_ss.png?raw=true "Get-Weather Screenshot")

This script has only been tested on PowerShell v5. Add this function to your profile for best results.
The function is called by way of Get-Weather. 

You will need to obtain an API Key from http://openweathermap.org/api
This script will use XML to gather the weather data, except for the sunrise/sunset information which was easier to interpret via JSON.

For more information, use Get-Help Get-Weather
