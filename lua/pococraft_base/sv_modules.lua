Logging = {}

function Logging.CreateLog()
	Logging.File = string.format( "%s/%s", ServerManager.LoggingDirectory, #file.Find( ServerManager.LoggingDirectory, "DATA" ) + 1)
	file.Write( Logging.File, "*** Logging Started on " .. os.date("%m/%d/%y @ " .. game.GetMap()) .. " ***\n" )
end

function Logging.AddLog( message, closing )
	if IsValid(closing) and closing then
		file.Append( Logging.File, 
			string.format("%s%s\n", file.Read( Logging.File, "DATA" ), 
				string.format( "*** Logging Terminated! Reason: %s ***", message )
			)
		)
		Logging.CreateLog() -- Close the current logging method and start a new file
	else
		file.Append( Logging.File, 
			string.format("%s[%s] $ %s\n", file.Read( Logging.File, "DATA" ), os.date("%H:%M | %m/%d/%y @ " .. game.GetMap()), message )
		)
	end
end

hook.Add( "ShutDown", "EndLogging", Logging.AddLog( "Changing Maps", true ) ) -- Fires when changing maps

function _loadmodule( location )
	files, directories = file.Find( location, "LUA" )
	for _, module in pairs( directories ) do
		ModInfo = {
			Name = string.format("%s (No ModInfo Table)", module),
			Author = "Unknown (No ModInfo Table)",
		}

		include( string.format( "%s%s/init.lua", string.gsub(location, "*", ""), module ) )

		if TestSuccess() then
			Logging.AddLog( "| + Pococraft Base: Sucessfully loaded module \"" .. module .. "\"!" )
			Logging.AddLog( "| ? Name: " .. ModInfo.Name )
			Logging.AddLog( "| ? Author: " .. ModInfo.Author )
		else
			Logging.AddLog( "| + Pococraft Base: Failed to load module \"" .. module .. "\"!" )
		end
	end
end

function _startloading()
	_loadmodule( "pococraft_base/modules/all/*" )
	_loadmodule( "pococraft_base/modules/" .. tostring( GetConVar("hostport"):GetInt() ) .. "/*" )
end