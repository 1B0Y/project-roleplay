--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 24/10/2014 (Jack)
	Authors: Jack
]]--

-- Let's start off by adding our custom events that we'll need for later.
addEvent("onPlayerAttemptLogin",true)
addEvent("onPlayerAttemptRegister",true)
addEvent("onPlayerAttemptRecovery",true)

-- Setup some variables and tables we'll need.
local REGISTER_WAITTIME = 60 -- Registration limit between account registrations (to prevent players making multiple accounts quickly).

-- Setup some pre-definers since we'll be using custom functions
local _logIn = logIn

function logIn(username,password,encrypted,remember)
	--Handle the login crap here + ban handling
end
addEventHandler("onPlayerAttemptLogin",root,logIn)

function register(username,password,email)
	--Handle the register crap here
end
addEventHandler("onPlayerAttemptRegister",root,register)

--FUTURE NOTE: We'll have to do some PHP stuff with this (meaning the hoster might need a email service)
function recover(username,email)
	--Handle recovery crap here
end
addEventHandler("onPlayerAttemptRecovery",root,recover)