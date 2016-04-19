# Get-Weather
A Powershell function that will display weather conditions in the console. 
![Alt text](/get-weather_ss.png?raw=true "Get-Weather Screenshot")

This script has only been tested on Powershell v5. Add this function to your profile for best results.
The function is called by way of Get-Weather. 

You will need to obtain an API Key from http://openweathermap.org/api
This script will use XML to gather the weather data, except for the sunrise/sunset information which was easier to interpret via JSON.

There are a vew variables which you must change, these are documented within the script.
