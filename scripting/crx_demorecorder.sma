#include <amxmodx>
#include <colorchat>

#define PLUGIN_VERSION "1.0"

new g_Delay
new g_Filename, g_Message, g_Message2
new const g_Colors[][] = { "!g", "^x04", "!t", "^x03", "!n", "^x01" }
new const g_Symbols[][] = { " ", ":", ".", "*", "/", "|", "\", "?", ">", "<" }

public plugin_init()
{
	register_plugin("Simple Demo Recorder", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXDemoRecorder", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	
	g_Delay = register_cvar("dem_delay", "15.0")
	g_Filename = register_cvar("dem_name", "CRX Auto Demo")
	g_Message = register_cvar("dem_message", "!g[!tDemo RecordeR!g] !nWe are now recording in your !gcstrike !nfolder: !t<name>")
	g_Message2 = register_cvar("dem_message2", "!g[!tDemo RecordeR!g] !nDemo recording has been started at: !t<time>")
}

public client_putinserver(id)
	set_task(get_pcvar_float(g_Delay), "dem_start", id)

public dem_start(id)
{
	if(!is_user_connected(id))
		return
	
	new szMessage[256], szMessage2[256], szFilename[128], szTime[9]
	get_time("%H:%M:%S", szTime, charsmax(szTime))
	get_pcvar_string(g_Message, szMessage, charsmax(szMessage))
	get_pcvar_string(g_Message2, szMessage2, charsmax(szMessage2))
	get_pcvar_string(g_Filename, szFilename, charsmax(szFilename))
	
	for(new i = 0; i < sizeof(g_Symbols); i++)
		replace_all(szFilename, charsmax(szFilename), g_Symbols[i], "_")
	
	for(new i = 0; i < sizeof(g_Colors) - 1; i += 2)
	{
		replace_all(szMessage, charsmax(szMessage), g_Colors[i], g_Colors[i + 1])
		replace_all(szMessage2, charsmax(szMessage2), g_Colors[i], g_Colors[i + 1])
	}
	
	replace(szMessage, charsmax(szMessage), "<name>", "^"<name>.dem^"")
	replace(szMessage, charsmax(szMessage), "<name>", szFilename)
	replace(szMessage2, charsmax(szMessage2), "<time>", szTime)
	
	ColorChat(id, TEAM_COLOR, "%s", szMessage)
	ColorChat(id, TEAM_COLOR, "%s", szMessage2)
	client_cmd(id, "stop; record ^"%s^"", szFilename)
}